FROM python:3.11-slim

# Install system dependencies for Chromium
RUN apt-get update && apt-get install -y \
    python3-venv \
    python3-pip \
    wget \
    curl \
    unzip \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxshmfence1 \
    libxss1 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Install gost
RUN wget https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost_2.12.0_linux_amd64.tar.gz && tar -xf gost_2.12.0_linux_amd64.tar.gz && mv gost /usr/local/bin/ && chmod +x /usr/local/bin/gost && rm gost_2.12.0_linux_amd64.tar.gz

# Setup venv
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install Python requirements
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install --upgrade pip \
    && pip3 install -r requirements.txt

# Copy app code
COPY . /app

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

expose 8080

CMD ["/entrypoint.sh"]

