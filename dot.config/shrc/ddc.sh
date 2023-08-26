# x0f: DisplayPort-1
# x1b: USB-C
DDC_SOURCES=("x0f" "x1b")

switchkvm() {
  local vcp_input_src="x60"
  local current next src
  current=$(ddcutil -t getvcp ${vcp_input_src} | awk '{ print $4 }')
  for src in "${DDC_SOURCES[@]}"; do
    if [[ ${src} != "${current}" ]]; then
      next=${src}
    fi
  done

  if [[ -z ${next} ]]; then
    echo "No eligible alternate input in \$DDC_SOURCES" >&2
    echo "\$DDC_SOURCES=(${DDC_SOURCES[*]}); current=${current}"
    return 1
  fi

  ddcutil setvcp "${vcp_input_src}" "${next}"
}
