if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
fi

swww img -o "DP-1" ~/Pictures/wallpapers/jellyfish.jpg
swww img -o "DP-2" ~/Pictures/wallpapers/hexmoon.jpg

# kitty --start-as=hidden kitten panel --edge background --output-name "DP-2" --detach btop
