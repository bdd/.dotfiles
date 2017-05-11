if [[ $OSTYPE =~ darwin* ]]; then
  __RAMDISK_MOUNTPOINT="/Volumes/ramdisk"
  hash -d ramdisk="${__RAMDISK_MOUNTPOINT}"

  rd-attach () {
    local rd_size="512000"

    if [[ -d $__RAMDISK_MOUNTPOINT ]]; then
      rmdir $__RAMDISK_MOUNTPOINT
      if [[ $? != 0 ]]; then
        echo "$__RAMDISK_MOUNTPOINT is not empty." 1>&2
        return 1
      fi
    fi

    # If we have an integer parameter take it as ramdisk size.
    if [[ $1 =~ ^([0-9]+)([mMgG]{1})$ ]]; then
      (( rd_size = $match[1] * 2 )) # roughly convert to sectors.
      if [[ $match[2]:u == "M" ]]; then
        (( rd_size = rd_size * 1000 )) # from megabytes
      else
        (( rd_size = rd_size * 1000000 )) # from gigabytes
      fi
    fi

    diskutil erasevolume HFS+ "ramdisk" $(hdiutil attach -nomount ram://$rd_size)
    mount -uwo noatime,noowners $__RAMDISK_MOUNTPOINT
  }

  rd-eject () {
    diskutil eject $__RAMDISK_MOUNTPOINT
    unhash -d ramdisk
  }
fi
