export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx "$XINITRC"
fi
