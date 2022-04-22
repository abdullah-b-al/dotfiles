while true; do
  # Log stderror to a file 
  [[ -d ~/.cache/dwm ]] || mkdir -p ~/.cache/dwm/
  dwm 2> ~/.cache/dwm/dwm.log
  # No error logging
  #dwm >/dev/null 2>&1
done
