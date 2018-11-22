# shellcheck shell=bash

# macOS only
[[ $OSTYPE =~ darwin* ]] || return

_RAMDISK_MOUNT_POINT="/Volumes/ramdisk"

rd-attach() {
  local rd_size=512000000 # 512M

  if [[ -d "${_RAMDISK_MOUNT_POINT}" ]]; then
    if ! rmdir "${_RAMDISK_MOUNT_POINT}"; then
      echo "${_RAMDISK_MOUNT_POINT} is not empty." >&2
      return 1
    fi
  fi

  # If we have an integer parameter take it as ramdisk size in bytes.
  if [[ ${1:=$rd_size} =~ ^[0-9]+$ ]]; then
    rd_size=$1
  else # size specified in units. Use GNU numfmt to convert to bytes.
    if hash gnumfmt 2>/dev/null; then
      rd_size=$(gnumfmt --from=auto "$1") || return 1
    else
      echo "gnumfmt: not found. Cannot convert $1 to bytes." >&2
      return 1
    fi
  fi

  local num_sectors=$((rd_size / 512))
  local raw_disk=$(hdiutil attach -nomount ram://${num_sectors} | grep -oE '\S+') || return 1
  diskutil erasevolume HFS+ "ramdisk" "${raw_disk}"
  mount -uwo noatime,noowners ${_RAMDISK_MOUNT_POINT}

  if [[ -n ${ZSH_VERSION} ]]; then
    hash -d ramdisk="${_RAMDISK_MOUNT_POINT}"
  fi
}

rd-eject() {
  diskutil eject "${_RAMDISK_MOUNT_POINT}"

  if [[ -n ${ZSH_VERSION} ]]; then
    unhash -d ramdisk
  fi
}
