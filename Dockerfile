FROM python:3.9-slim

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Установка Allure
RUN curl -o allure-2.24.0.tgz -Ls https://github.com/allure-framework/allure2/releases/download/2.24.0/allure-2.24.0.tgz && \
    tar -zxvf allure-2.24.0.tgz -C /opt/ && \
    ln -s /opt/allure-2.24.0/bin/allure /usr/bin/allure && \
    rm allure-2.24.0.tgz

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY test_example.py .

# Создаем точку монтирования для отчетов
VOLUME /app/allure-report

CMD ["sh", "-c", "pytest test_example.py --alluredir=allure-results && \
     allure generate allure-results --clean -o allure-report && \
     echo 'Отчет сгенерирован в папке allure-report'"]