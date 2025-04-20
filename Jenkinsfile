pipeline {
    agent any
    stages {
        stage('Run Tests') {
            steps {
                sh '/app/venv/bin/python3 -m pytest /app/test_example.py --alluredir=/app/allure-results'
            }
        }
        stage('Generate Allure Report') {
            steps {
                sh 'allure generate /app/allure-results --clean -o /app/allure-report'
            }
        }
    }
    post {
        always {
            // Публикуем отчёт Allure
            allure results: [[path: '/app/allure-results']]
            // Архивируем отчёт
            archiveArtifacts artifacts: 'allure-report/**', allowEmptyArchive: true
        }
    }
}