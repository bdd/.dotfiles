dns-survey() {
  local DNSLG="http://www.dns-lg.com"
  local anycast_nodes=(google1 google2 opendns1 opendns2 cloudflare quad9 he)
  local default_nodes=(google1 opendns1 cloudflare quad9 he)

  local opt
  local only_anycast_nodes=false only_unicast_nodes=false all_nodes=false
  while getopts :Aauh opt; do
    case "${opt}" in
      a)
        only_anycast_nodes=true
        only_unicast_nodes=false; all_nodes=false
        ;;
      u)
        only_unicast_nodes=true
        only_anycast_nodes=false; all_nodes=false
        ;;
      A)
        all_nodes=true
        only_anycast_nodes=false; only_unicast_nodes=false
        ;;
      h)
        printf "Usage: $0 [-Aauh] name [rrtype]\n"
        return 64 # EX_USAGE
        ;;
      \?)
        printf "Unrecognized option -%s\n" "${OPTARG}"
        printf "Usage: $0 [-Aauh] name [rrtype]\n"
        return 64 # EX_USAGE
        ;;
    esac
  done

  shift $((OPTIND - 1))

  local name=$1
  local rrtype=${2-A}
  [[ $# -ge 1 ]] || return 64 # EX_USAGE
  hash jq 2>/dev/null || return 69 # EX_UNAVAILABLE

  if [[ ${only_unicast_nodes} == "true" || ${all_nodes} == "true" ]]; then
    local unicast_nodes=($(curl -s ${DNSLG}/nodes.json | jq -r '.nodes[].name'))
  fi

  local nodes
  if ${only_anycast_nodes}; then
    nodes=(${anycast_nodes[@]})
  elif ${only_unicast_nodes}; then
    nodes=(${unicast_nodes[@]})
  elif ${all_nodes}; then
    nodes=(${anycast_nodes[@]} ${unicast_nodes[@]})
  else
    nodes=(${default_nodes[@]})
  fi

  for node in ${nodes[@]}; do
    echo "- ${node}:"
    curl -s "${DNSLG}/${node}/${name}/${rrtype}" \
      | (jq -r '.answer[].rdata' 2>/dev/null || echo '[fail]') \
      | sort -n
  done
}
