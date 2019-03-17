# shellcheck shell=bash
dns-lg() {
  local DNSLG='http://www.dns-lg.com'
  local anycast_nodes="google1 google2 opendns1 opendns2 cloudflare quad9 he"
  local default_nodes="google1 opendns1 cloudflare quad9 he"

  if [[ -n "${BASH_VERSION-}" ]]; then local fn=${FUNCNAME[0]}; else local fn=$0; fi
  local __usage__="Usage: ${fn} [-Aau] name [rrtype]\\n"

  local opt OPTIND=1
  while getopts ':Aau' opt; do
    case "${opt}" in
      A)
        local all_nodes=true
        local only_anycast_nodes=false only_unicast_nodes=false
        ;;
      a)
        local only_anycast_nodes=true
        local only_unicast_nodes=false all_nodes=false
        ;;
      u)
        local only_unicast_nodes=true
        local only_anycast_nodes=false all_nodes=false
        ;;
      *)
        echo "Unrecognized option -${OPTARG}" >&2
        echo "${__usage__}" >&2
        return 64 # EX_USAGE
        ;;
    esac
  done

  shift $((OPTIND - 1))

  if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "${__usage__}" >&2
    return 64 # EX_USAGE
  fi
  if ! hash jq 2>/dev/null; then
    echo "jq: not found" >&2
    return 69 # EX_UNAVAILABLE
  fi
  local name=$1
  local rrtype=${2-A}

  if [[ ${only_unicast_nodes} == 'true' || ${all_nodes} == 'true' ]]; then
    local unicast_nodes
    unicast_nodes=$(
      set -o pipefail;
      curl --fail -s ${DNSLG}/nodes.json | jq -e -r '.nodes[].name' | tr '\n' ' '
    ) || return 69 # EX_UNAVAILABLE
  fi

  if [[ -n "${BASH_VERSION-}" ]]; then
    local read_array='-a'
  else
    local read_array='-A'
  fi

  local nodes
  if ${only_anycast_nodes}; then
    read -r ${read_array} nodes <<< "${anycast_nodes}"
  elif ${only_unicast_nodes}; then
    read -r ${read_array} nodes <<< "${unicast_nodes}"
  elif ${all_nodes}; then
    read -r ${read_array} nodes <<< "${anycast_nodes} ${unicast_nodes}"
  else
    read -r ${read_array} nodes <<< "${default_nodes}"
  fi

  for node in "${nodes[@]}"; do
    echo "- ${node}:"
    curl -s "${DNSLG}/${node}/${name}/${rrtype}" \
      | (jq -r '.answer[].rdata' 2>/dev/null || echo '[fail]') \
      | sort -n
  done
}
