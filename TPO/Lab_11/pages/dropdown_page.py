from selenium.webdriver.common.by import By

class DropdownPage:
    def __init__(self, driver):
        self.driver = driver
        # Элемент выпадающего списка
        self.dropdown = (By.ID, "dropdown")

    def open(self):
        self.driver.get("https://the-internet.herokuapp.com/dropdown")

    def select_option(self, value):
        # Выбор элемента из выпадающего списка
        dropdown_element = self.driver.find_element(*self.dropdown)
        dropdown_element.click()  # Клик по выпадающему списку
        option = self.driver.find_element(By.XPATH, f"//option[@value='{value}']")  # Поиск нужного элемента
        option.click()
        return option.is_selected()  # Проверка, что элемент выбран