# Use a minimal Python 3.10 image.
FROM python:3.10-slim

# Set the working directory inside the container.
WORKDIR /app

# Install system dependencies for Chromium, along with curl for downloading, tar for extraction, and netcat for checking ports.
RUN apt-get update && apt-get install -y \
    chromium \
    curl \
    netcat-traditional \
    tar \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libfreetype6 \
    libharfbuzz0b \
    libice6 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libx11-6 \
    fonts-liberation \
    libxcursor1 \
    libxrandr2 \
    libxcb1 \
    libxss1 \
    libdbus-1-3 \
    libxkbcommon-x11-0 \
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
