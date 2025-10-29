#!/bin/bash

# Saves closed app names as files in /tmp/quickshell_closed/
TEMP_DIR="/tmp/quickshell_closed"

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Force unbuffered output
exec 2>&1

declare -A windows

# Capture initial windows
while IFS='|' read -r addr class; do
    windows[$addr]="$class"
done < <(hyprctl clients -j | jq -r '.[] | (.address | ltrimstr("0x")) + "|" + .class')

# Check if socket exists (fail fast)
SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[[ -S "$SOCKET_PATH" ]] || exit 1

# Monitor events
socat -u "UNIX-CONNECT:$SOCKET_PATH" - | while IFS= read -r event; do
    case "$event" in
        openwindow\>\>*)
            # Extract fields with parameter expansion
            event="${event#openwindow>>}"
            addr="${event%%,*}"
            event="${event#*,}"
            event="${event#*,}"
            class="${event%%,*}"
            windows[$addr]="$class"
            ;;

        closewindow\>\>*)
            # Extract address
            addr="${event#closewindow>>}"
            class="${windows[$addr]}"

            if [[ -n "$class" ]]; then
                filename="$class"

                # Duplicate handling
                if [[ -e "$TEMP_DIR/$filename" ]]; then
                    counter=1
                    while [[ -e "$TEMP_DIR/${class}_${counter}" ]]; do
                        ((counter++))
                    done
                    filename="${class}_${counter}"
                fi

                : > "$TEMP_DIR/$filename"

                unset 'windows[$addr]'
            fi
            ;;
    esac
done
