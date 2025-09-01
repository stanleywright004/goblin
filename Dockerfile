FROM python:3.10-slim

# Set the working directory inside the container.
WORKDIR /app

# Install system dependencies for Chromium, along with curl for downloading, tar for extraction, and netcat for checking ports.
RUN apt-get update && apt-get install -y \
    python3 python3-venv libnss3-dev gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libgbm-dev netcat \
    && rm -rf /var/lib/apt/lists/*

# Download, extract, and move the latest Linux release of gost.
RUN curl -L -o gost.tar.gz https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost_2.12.0_linux_amd64.tar.gz \
    && tar -xzf gost.tar.gz \
    && mv gost_2.12.0_linux_amd64 /usr/local/bin/gost \
    && chmod +x /usr/local/bin/gost \
    && rm gost.tar.gz

# Copy the requirements file and install Python dependencies.
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy the shell script and Python script into the container.
COPY entrypoint.sh .
COPY main.py .

# Make the entrypoint script executable.
RUN chmod +x entrypoint.sh

# This is the single entry point for the container. It will run our shell script.
ENTRYPOINT ["./entrypoint.sh"]
