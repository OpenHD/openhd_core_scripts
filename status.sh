#!/bin/bash

# Loop indefinitely
while true; do
  # Check if the directory exists
  if [ -d "/tmp/openhd_status" ]; then
    # Print "Hello, World!"
    echo "Hello, World!"
  else
    # Exit the loop if the directory does not exist
    break
  fi
  
  # Sleep for a short time to prevent excessive CPU usage
  sleep 1
done

echo "Directory /tmp/openhd_status does not exist. Exiting."