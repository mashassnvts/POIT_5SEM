import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

@pytest.fixture(scope="class")
def setup_browser():
    options = webdriver.EdgeOptions()
    options.add_argument("--start-maximized")
    driver = webdriver.Edge(options=options)
    yield driver
    driver.quit()

@pytest.mark.parametrize("username,password", [
    ("tomsmith", "SuperSecretPassword!"),
    ("wronguser", "wrongpassword")
])
def test_authorization(setup_browser, username, password):
    driver = setup_browser
    driver.get("https://the-internet.herokuapp.com/login")

    driver.find_element(By.ID, "username").send_keys(username)
    driver.find_element(By.ID, "password").send_keys(password)
    driver.find_element(By.CSS_SELECTOR, "button.radius").click()

    if username == "tomsmith" and password == "SuperSecretPassword!":
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, "h2")))

        assert "Secure Area" in driver.page_source
    else:
        # Ждем появления сообщения об ошибке, но с учетом возможных изменений локаторов
        try:
            WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, ".flash.error")))

            # Проверяем, что отображается сообщение об ошибке
            assert "Your username is invalid!" in driver.page_source
        except Exception as e:
            print("Ошибка авторизации не была найдена в ожидаемом месте:", e)
            # Если сообщение не найдено, выводим ошибку и завершение теста
            assert False, "Ошибка авторизации не была найдена или локатор неверен"

@pytest.mark.regression
def test_add_remove_elements(setup_browser):
    driver = setup_browser
    driver.get("https://the-internet.herokuapp.com/add_remove_elements/")

    driver.find_element(By.CSS_SELECTOR, "button[onclick='addElement()']").click()

    delete_button = driver.find_element(By.CLASS_NAME, "added-manually")
    assert delete_button.is_displayed()

    delete_button.click()

    assert not driver.find_elements(By.CLASS_NAME, "added-manually")

@pytest.mark.regression
def test_dropdown(setup_browser):
    driver = setup_browser
    driver.get("https://the-internet.herokuapp.com/dropdown")
    dropdown = driver.find_element(By.ID, "dropdown")
    dropdown.click()
    option = driver.find_element(By.CSS_SELECTOR, "#dropdown option[value='2']")
    option.click()
    assert option.is_selected()
    driver.save_screenshot('screenshot.png')

@pytest.mark.skip(reason="Этот тест временно отключен для доработки")
def test_skipped_feature():
    assert False  # Этот код не будет выполняться, так как тест помечен как пропущенный

@pytest.mark.xfail(reason="Известная ошибка, ожидаем падение", strict=True)
def test_expected_failure():
    assert False  # Ожидаемая ошибка

@pytest.mark.xfail(reason="Иногда тест может пройти", strict=False)
def test_flaky():
    assert True  # Этот тест пройдет, но pytest отметит его как неожиданно успешный
