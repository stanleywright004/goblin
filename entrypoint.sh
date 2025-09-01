#!/bin/bash
echo "Starting gost proxy in the background..."
nohup gost -L=socks5://127.0.0.1:1082 -F=ss://aes-128-cfb:mikrotik999@cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:8443 > gost.log 2>&1 &

echo "Waiting for proxy port 1082 to be open..."
max_retries=10
retry_count=0
while ! nc -z 127.0.0.1 1082 && [ $retry_count -lt $max_retries ]; do
  echo "Port not open yet. Retrying in 2 seconds..."
  sleep 2
  retry_count=$((retry_count+1))
done

if [ $retry_count -eq $max_retries ]; then
  echo "Timeout: Proxy port not open after multiple retries. Exiting."
  exit 1
fi

echo "Starting proxy health checker..."
nohup bash -c '
while true
do
    if [ "$(curl -sL -x socks5h://127.0.0.1:1082 -w "%{http_code}" http://api.ipify.org -o /dev/null)" = "200" ]; then
        echo "$(date): gost is still online"
    else
        echo "$(date): gost is offline. Attempting to restart..."
        
        pkill gost
        
        new_server="ss://aes-128-cfb:mikrotik999@cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:8443"
        echo "Restarting gost with new server: $new_server"
        nohup gost -L=socks5://127.0.0.1:1082 -F="$new_server" > gost.log 2>&1 &
        
        sleep 5
        
        echo "New gost process started. Checking connectivity..."

        curl -x socks5h://127.0.0.1:1082 http://api.ipify.org
    fi

    sleep 600
done
' >> /app/proxy_checker.log 2>&1 &

echo "Proxy and health checker are running. Executing main Python script..."

exec python3 main.py
