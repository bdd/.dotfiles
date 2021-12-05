# Map Caps-Lock to Ctrl
#     Right-Alt to Compose
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier', 'compose:ralt']"


# Disable Print-Screen key combinations for taking screenshots.
# keys: (area-|window-)?screenshot(-clip)?
for prefix in "" "area-" "window-"; do
  for suffix in "" "-clip"; do
    gsettings set org.gnome.settings-daemon.plugins.media-keys "${prefix}screenshot${suffix}"
  done
done

# Solid black background
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'

# Misc
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface gtk-key-theme 'Emacs'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
