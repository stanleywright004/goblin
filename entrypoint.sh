#!/bin/bash
set -e

gost -L=:1082 -F=ss://aes-128-cfb:mikrotik999@cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:8443 &

sleep 2

exec python3 /app/main.py
