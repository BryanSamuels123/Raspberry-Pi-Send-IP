#!/bin/bash

# Bryan Samuels
# 07 October 2024
# This program serves the current IP Address to a google sheet when the device boots. To facilitate the SSH connection process.

sleep 10
myIP=$(hostname -I)
curl -X POST -d "ip=${myIP}" https://script.google.com/macros/s/{PUT-YOUR-STRING-HERE}/exec  
