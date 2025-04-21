FROM python:3.11-slim

# Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    openjdk-17-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Установка Chrome с фиксом ключей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg && \
    # Добавляем ключ через стандартный механизм
    mkdir -p /etc/apt/keyrings && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Настройка переменных окружения
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Проверка версий (опционально)
RUN google-chrome --version

# Установка Allure
ARG ALLURE_VERSION=2.24.1
RUN wget -O allure-${ALLURE_VERSION}.tgz \
    https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz \
    && tar -zxvf allure-${ALLURE_VERSION}.tgz -C /opt/ \
    && ln -s /opt/allure-${ALLURE_VERSION}/bin/allure /usr/bin/allure \
    && rm allure-${ALLURE_VERSION}.tgz

# Рабочая директория
WORKDIR /app

# Копируем зависимости и устанавливаем их
COPY tests/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем тесты
COPY tests/ .

# Создание директорий для Allure
RUN mkdir -p /app/allure-results /app/allure-report /app/.pytest_cache \
    && chmod -R 777 /app/allure-results

VOLUME /app/allure-report

CMD ["pytest", "test_example.py", "-v", "--alluredir=/app/allure-results"]