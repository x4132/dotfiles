if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
fi

swww img -o "DP-1" ~/Pictures/wallpapers/great_wave_circle_minimal.jpg
swww img -o "DP-2" ~/Pictures/wallpapers/wolf_cave_mountain_silhouette.png

# kitty --start-as=hidden kitten panel --edge background --output-name "DP-2" --detach btop
