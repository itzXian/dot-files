#!/bin/bash
ARIA2_CONF="$HOME/.config/aria2/aria2.conf"
PERSISTENT_TRACKERS_FILE="$HOME/.config/aria2/persistent_trackers_list.txt"
TRACKER_URL="https://cf.trackerslist.com/all.txt"
INIT="openrc"
ARIA2_SERVICE="aria2"

if [ ! -f "$ARIA2_CONF" ]; then
    echo "Error: Configuration file not found at $ARIA2_CONF"
    exit 1
fi

if [ -f "$PERSISTENT_TRACKERS_FILE" ]; then
    PERSISTENT_TRACKERS=$(grep 'announce' "${PERSISTENT_TRACKERS_FILE}" | tr '\n' ',')
else
    PERSISTENT_TRACKERS=""
fi

echo "Fetching latest aria2 trackers..."
# Fetch the trackers and store them in a variable
NEW_TRACKERS=$(curl -sSL "$TRACKER_URL" | grep 'announce' | tr '\n' ',')

if [ -z "$NEW_TRACKERS" ]; then
    echo "Error: Failed to fetch trackers or the list is empty."
    exit 1
else
    NEW_TRACKERS="bt-tracker=${PERSISTENT_TRACKERS}${NEW_TRACKERS}"
fi

echo "Updating $ARIA2_CONF..."

# Check if bt-tracker line already exists in the config
if grep -q "^bt-tracker=" "$ARIA2_CONF"; then
    # Replace the existing bt-tracker line
    # Using a different sed delimiter (|) because trackers contain slashes/commas
    sed -i "s|^bt-tracker=.*|$NEW_TRACKERS|" "$ARIA2_CONF"
else
    # Append to the end of the file if it doesn't exist
    echo "$NEW_TRACKERS" >> "$ARIA2_CONF"
fi

echo "Trackers successfully updated!"

# Restart aria2 service if applicable
if [ "$INIT" = "systemd" ]; then
    check='systemctl is-active --quiet "$ARIA2_SERVICE"'
    restart='sudo systemctl restart "$ARIA2_SERVICE"'
elif [ "$INIT" = "openrc" ]; then
    check="rc-service --quiet --user $ARIA2_SERVICE status"
    restart="rc-service --quiet --user $ARIA2_SERVICE restart"
else
    echo "Error: Unsupported init system $INIT"
    exit 1
fi

if $(echo $check); then
    echo "Restarting $ARIA2_SERVICE service to apply changes..."
    $restart
    echo $(echo restart)
    echo "Service restarted."
else
    echo "Note: If aria2 is currently running, you will need to restart it for changes to take effect."
fi
