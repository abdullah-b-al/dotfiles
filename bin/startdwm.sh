while true; do
  # Log stderror to a file 
  mkdir -p ~/.cache/dwm
  dwm 2> ~/.cache/dwm/dwm.log
  if [ -n "$(cat ~/.cache/dwm/dwm.log)" ]; then
    cp ~/.cache/dwm/dwm.log ~/.cache/dwm/dwm.log.backup
  fi
  # No error logging
  #dwm >/dev/null 2>&1
done
