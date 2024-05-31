#!/bin/bash

lookForWarning() {
    if [ -d "/tmp/openhd_status" ]; then
        for dir in /tmp/openhd_status/*/; do
            if [ -d "$dir" ] && [ "$(basename "$dir")" == "openhd" ] && [ -f "$dir/warning" ]; then
                cat "$dir/warning"
            fi
        done
    else
        return 1
    fi
}

while true; do
    lookForWarning || break
    sleep 5
done
