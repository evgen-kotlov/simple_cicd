import pytest
import requests


def test_get_status_code_200():
    """Проверка, что GET-запрос возвращает статус 200."""
    response = requests.get("https://httpbin.org/get")
    assert response.status_code == 200


def test_post_status_code_200():
    """Проверка, что POST-запрос возвращает статус 200."""
    response = requests.post("https://httpbin.org/post", json={"key": "value"})
    assert response.status_code == 200


@pytest.mark.skip(reason="Пример пропущенного теста")
def test_skipped():
    """Пропущенный тест."""
    assert False


@pytest.mark.xfail(reason="Пример теста, который ожидаемо падает")
def test_failed():
    """Тест, который ожидаемо падает."""
    assert False


if __name__ == "__main__":
    pytest.main(["-v", "--alluredir=allure-results"])