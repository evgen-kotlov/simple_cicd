import pytest
import requests
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService

def test_selenium():
    options = webdriver.ChromeOptions()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.binary_location = "/usr/bin/google-chrome-stable"

    service = ChromeService(executable_path="/usr/bin/chromedriver")  # <-- системный путь
    driver = webdriver.Chrome(service=service, options=options)

    try:
        driver.get("https://example.com")
        assert "Example" in driver.title
    finally:
        driver.quit()

#2
def test_get_status_code_200():
    response = requests.get("https://httpstat.us/200")
    assert response.status_code == 200

def test_post_status_code_200():
    response = requests.post("https://httpstat.us/200", json={"key": "value"})
    assert response.status_code == 200

@pytest.mark.skip(reason="Пример пропущенного теста3")
def test_skipped():
    assert False
