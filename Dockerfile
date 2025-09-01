FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y python3-venv

COPY requirements.txt .

RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 8080

CMD ["python3", "app.py"]
