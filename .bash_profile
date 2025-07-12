# ~/.bash_profile

[ -f ~/.bashrc ] && . ~/.bashrc
[ -n "$DESKTOP_SESSION" ] && eval $(gnome-keyring-daemon --start) && export SSH_AUTH_SOCK
# Simply disable Caps Lock
#[ -n $(command -v setxkbmap) ] && setxkbmap -option '' -option 'ctrl:nocaps'
# Map Caps Lock to Escape
#[ -n $(command -v xmodmap) ] && xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
# Map Caps Lock to Tab
#[ -n $(command -v xmodmap) ] && xmodmap -e 'clear Lock' -e 'keycode 0x42 = Tab'
# Custom Keyboard Remapping

# Disable internal keyboard for laptaps
#[[ -n $DISPLAY ]] && [[ -n $(command -v xinput) ]] && xinput float $(xinput list | grep AT | awk '{sub(".*id=", ""); print $1}')
# Enable internal keyboard for laptaps
[[ -n $DISPLAY ]] && [[ -n $(command -v xinput) ]] && xinput reattach $(xinput list | grep AT | awk '{sub(".*id=", ""); print $1}') $(xinput list | grep "slave  keyboard" | awk -F"[()]" 'NR==1{ print $2 }')
# Keep this at bottom
[[ -n $(command -v tbsm) && -z  $DISPLAY  && -n  $XDG_VTNR  ]] && dbus-launch tbsm r 1
#[[ -n $(command -v tbsm) && -z  $DISPLAY  && -n  $XDG_VTNR  ]] && tbsm
set _JAVA_AWT_WM_NONREPARENTING=1
