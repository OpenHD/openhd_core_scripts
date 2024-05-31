#!/bin/bash

while true; do
  if [ -d "/tmp/openhd_status" ]; then
    wall -n "Hello world"
  else
    break
  fi
    sleep 10
done