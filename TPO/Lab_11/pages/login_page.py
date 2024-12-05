from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class LoginPage:
    def __init__(self, driver):
        self.driver = driver
        self.username_input = (By.ID, "username")
        self.password_input = (By.ID, "password")
        self.login_button = (By.CLASS_NAME, "radius")
        self.success_message = (By.CLASS_NAME, "flash.success")
        self.error_message = (By.CLASS_NAME, "flash.error")

    def open(self):
        self.driver.get("https://the-internet.herokuapp.com/login")

    def login(self, username, password):
        self.driver.find_element(*self.username_input).send_keys(username)
        self.driver.find_element(*self.password_input).send_keys(password)
        self.driver.find_element(*self.login_button).click()

    def is_login_successful(self):
        return WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located(self.success_message)
        )

    def is_error_message_displayed(self):
        return WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located(self.error_message)
        ).is_displayed()