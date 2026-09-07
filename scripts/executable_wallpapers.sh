if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
fi

awww img -o "HDMI-A-1" ~/Pictures/wallpapers/great_wave_circle_minimal.jpg

# kitty --start-as=hidden kitten panel --edge background --output-name "DP-2" --detach btop
