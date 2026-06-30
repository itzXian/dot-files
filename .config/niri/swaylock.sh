swayidle -w \
    timeout 3 'swaylock -f -i ~/.config/wallpaper' \
    timeout 4 'niri msg action power-off-monitors' \
    before-sleep 'swaylock -f -i ~/.config/wallpaper'
