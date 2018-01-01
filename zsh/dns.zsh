dns-survey() {
  local DNSLG="http://www.dns-lg.com"
  local name=$1
  local rrtype=${2-A}
  local anycast_nodes=(google1 google2 he opendns1 opendns2)
  local node

  [[ $# -ge 1 ]] || return 64 # EX_USAGE
  hash jq 2>/dev/null || return 69 # EX_UNAVAILABLE

  for node in ${anycast_nodes[@]} \
    $(curl -s ${DNSLG}/nodes.json | jq -r '.nodes[].name')
  do
    echo "- ${node}:"
    curl -s "${DNSLG}/${node}/${name}/${rrtype}" \
      | (jq -r '.answer[].rdata' 2>/dev/null || echo '[fail]') \
      | sort -n
  done
}
