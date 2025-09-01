import os
import requests
import random
import string
import asyncio
from pyppeteer import launch
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer
import threading

# CPU cores (info only, not critical)
num_of_cores = os.cpu_count()

# Unique worker ID
currentdate = datetime.now().strftime('%d-%b-%Y_RenPypp_')
ipaddress = requests.get('https://api.ipify.org').text
underscored_ip = ipaddress.replace('.', '_')
currentdate += underscored_ip
chars = random.choices(string.ascii_letters + string.digits, k=100)
random_word = "".join(chars[:8])
currentdate += random_word

print(f"Your worker ID is: {currentdate}")

# Custom HTTP server with /ping health check
class HealthHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/ping":
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"pong\n")
        else:
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"Service running\n")

def run_dummy_server():
    port = 8080
    server = HTTPServer(("0.0.0.0", port), HealthHandler)
    print(f"Health server running on port {port}")
    server.serve_forever()

threading.Thread(target=run_dummy_server, daemon=True).start()

# Pyppeteer fetch task
async def fetch():
    browser = await launch(
        headless=True,
        args=[
            '--no-sandbox',
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
            '--proxy-server=127.0.0.1:1082'
        ],
        autoClose=False
    )
    page = await browser.newPage()
    url = f"http://sindilesiqhaztraining.teatspray.uk/test.html?workerID={currentdate}"
    await page.goto(url)

    print(f"Browser opened and staying at: {url}")

    # Keep container running forever
    await asyncio.Future()

asyncio.get_event_loop().run_until_complete(fetch())
