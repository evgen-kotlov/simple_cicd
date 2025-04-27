FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99
WORKDIR /app

# Установка Chrome и chromedriver из APT
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libgconf-2-4 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    xauth \
    xvfb \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    chromium-driver && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Установка Python-зависимостей
COPY tests/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Установка Allure
ARG ALLURE_VERSION=2.24.1
RUN wget -O allure-${ALLURE_VERSION}.tgz https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz && \
    tar -zxvf allure-${ALLURE_VERSION}.tgz -C /opt/ && \
    ln -s /opt/allure-${ALLURE_VERSION}/bin/allure /usr/bin/allure && \
    rm allure-${ALLURE_VERSION}.tgz

COPY tests/ .

CMD ["sh", "-c", "Xvfb :99 -screen 0 1024x768x24 -ac & pytest test_example.py -v --alluredir=/app/allure-results"]
