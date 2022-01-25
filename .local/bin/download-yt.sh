#!/bin/sh
url=$(xclip -selection clipboard -o)
download_path="$HOME/.local/music"

notify-send -t 2000 "download-yt.sh" "Running..."

if ! command -v yt-dlp > /dev/null; then
    notify-send -t 5000 -u critical "download-yt.sh" "'yt-dlp' isn't installed."
    exit
fi

if echo "$url" | grep -qi "youtube.com/watch" && [ ${#url} -le 45 ]; then
    video_title=$(yt-dlp --get-title "$url")

    if yt-dlp --extract-audio --audio-format flac "$url" -P "$download_path"; then
        notify-send -t 5000 "download-yt.sh" "Downloading '$video_title' has finished successfully."
    else
        notify-send -u critical "download-yt.sh" "Downloading '$video_title' failed."
    fi

else
    notify-send -t 3000 -u critical "download-yt.sh" "Input isn't a youtube url or is longer than 45 chars"
fi
