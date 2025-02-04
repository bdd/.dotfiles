dt() {
  local opts
  local fmt="%Y-%m-%dT%H:%M" # ISO 8601
  local tsfmt="%Y%m%dT%H%M%S"
  case "$@" in
    utc|zulu|z)
      opts=(-u +"${fmt}Z") ;;
    timestamp|ts)
      opts=(+"${tsfmt}") ;;
    utc-timestamp|zulu-timestamp|uts|zts)
      opts=(-u +"${tsfmt}Z") ;;
    @*)
      # convert from epoch
      opts=(-d "$1" +"${fmt}Z") ;;
    *)
      opts=(+"${fmt}%z")
  esac

  date "${opts[@]}"
}
