from selenium.webdriver.common.by import By

class CheckboxesPage:
    def __init__(self, driver):
        self.driver = driver
        # Элементы чекбоксов
        self.checkboxes = (By.CSS_SELECTOR, "input[type='checkbox']")

    def open(self):
        self.driver.get("https://the-internet.herokuapp.com/checkboxes")

    def toggle_checkbox(self, index, check):
        # Переключение состояния чекбокса по индексу
        checkbox = self.driver.find_elements(*self.checkboxes)[index]  # Получение чекбокса по индексу
        if check and not checkbox.is_selected():
            checkbox.click()  # Выбор чекбокса
            return True
        elif not check and checkbox.is_selected():
            checkbox.click()  # Снятие выбора чекбокса
            return False
        return None  # Если состояние не изменилось