dt() {
  local opts
  local fmt="%Y-%m-%dT%H:%M" # ISO 8601
  case $1 in
    utc|zulu|z)
      opts=(-u +"${fmt}Z") ;;
    @*)
      # convert from epoch
      opts=(-d "$1" +"${fmt}Z") ;;
    *)
      opts=(+"${fmt}%z")
  esac

  date "${opts[@]}"
}
