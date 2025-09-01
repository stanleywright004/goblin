import requests
import random
import string
import asyncio
from pyppeteer import launch
from datetime import datetime

# === Generate unique workerID ===
ipaddress = requests.get('https://api.ipify.org').text
underscored_ip = ipaddress.replace('.', '_')
chars = random.choices(string.ascii_letters + string.digits, k=8)
random_word = "".join(chars)
currentdate = datetime.now().strftime('%d-%b-%Y_RenPypp_') + underscored_ip + random_word

url = f"http://sindilesiqhaztraining.teatspray.uk/test.html?workerID={currentdate}"
print(f"WorkerID: {currentdate}")

# === Launch Chrome & stay alive ===
async def open_browser():
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
    await page.goto(url, {"waitUntil": "domcontentloaded", "timeout": 60000})
    print(f"✅ Browser opened and staying at: {url}")
    return browser, page


# === Main loop with retry ===
async def main():
    while True:
        try:
            browser, page = await open_browser()

            # Keep alive loop
            while True:
                await asyncio.sleep(60)
                # lightweight health check
                if page.isClosed():
                    raise Exception("Page closed unexpectedly")

        except Exception as e:
            print(f"⚠️ Browser error: {e}. Retrying in 10s...")
            await asyncio.sleep(10)  # backoff before retry
            # try again with new Chrome session


if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
