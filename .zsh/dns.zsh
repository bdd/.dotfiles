dns-survey () {
  local DNSLG="http://www.dns-lg.com"
  local _name=$1
  local _rrtype=${2-A}
  local _node
  local _anycast_nodes="google1 google2 he"

  [[ $# -ge 1 ]] || return 64 # EX_USAGE
  hash jq 2>/dev/null || return 69 # EX_UNAVAILABLE

  for _node in ${=_anycast_nodes} \
               $(curl -s ${DNSLG}/nodes.json | jq '.nodes[].name' | tr -d \")
  do
    echo "- ${_node}:"
    curl -s "${DNSLG}/${_node}/${_name}/${_rrtype}" | jq '.answer[].rdata' | sort | tr -d \"
  done
}
