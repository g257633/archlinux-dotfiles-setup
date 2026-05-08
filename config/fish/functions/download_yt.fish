function download_yt
    if test -z "$argv[1]"
        echo "Use: download_yt <URL>"
        return 1
    end
    echo "Downloading YouTube video: $argv[1]"
    yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]' --sponsorblock-remove all --output '%(title)s.%(ext)s' $argv[1]
end
