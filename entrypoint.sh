#!/bin/bash
set -e

nohup gost -L=:1082 -F=ss://aes-128-cfb:mikrotik999@cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:8443 > gost.log 2>&1 &

sleep 2

exec python3 /app/main.py
