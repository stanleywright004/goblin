FROM python:3.11-slim

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

RUN wget -O /usr/local/bin/gost https://github.com/go-gost/gost/releases/download/v3.0.0/gost-linux-amd64 \
    && chmod +x /usr/local/bin/gost

RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install --upgrade pip \
    && pip3 install -r requirements.txt

RUN python3 -m pyppeteer install

COPY . /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
