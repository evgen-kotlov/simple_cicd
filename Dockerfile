# Базовый образ Jenkins
FROM jenkins/jenkins:lts

# Переключаемся на root для установки зависимостей
USER root

# Установка tini, Python, Java и других зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tini \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    openjdk-17-jre-headless \
    docker.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка Allure
ARG ALLURE_VERSION=2.30.0
RUN curl -o allure-${ALLURE_VERSION}.tgz -Ls https://github.com/allure-framework/allure2/releases/download/${ALLURE_VERSION}/allure-${ALLURE_VERSION}.tgz && \
    tar -zxvf allure-${ALLURE_VERSION}.tgz -C /opt/ && \
    ln -s /opt/allure-${ALLURE_VERSION}/bin/allure /usr/bin/allure && \
    rm allure-${ALLURE_VERSION}.tgz

# Создание рабочей директории для тестов
WORKDIR /app

# Создание виртуального окружения
RUN python3 -m venv /app/venv

# Копирование файлов проекта
COPY requirements.txt .
# Установка зависимостей в виртуальное окружение
RUN /app/venv/bin/pip install --no-cache-dir -r requirements.txt

COPY test_example.py .

# Создание директорий для Allure и установка прав
RUN mkdir -p /app/allure-results /app/allure-report /app/.pytest_cache && \
    chown -R jenkins:jenkins /app && \
    chmod -R 777 /app

# Точка монтирования для отчётов
VOLUME /app/allure-report

# Возвращаемся к пользователю Jenkins
USER jenkins

# Экспонируем порт Jenkins
EXPOSE 8089 50000

# Команда по умолчанию для запуска Jenkins с tini
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]