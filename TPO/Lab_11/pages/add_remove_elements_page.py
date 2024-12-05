from selenium.webdriver.common.by import By

class AddRemoveElementsPage:
    def __init__(self, driver):
        self.driver = driver
        # Элементы страницы добавления/удаления элементов
        self.add_button = (By.XPATH, "//button[text()='Add Element']")
        self.delete_button_class = "added-manually"

    def open(self):
        self.driver.get("https://the-internet.herokuapp.com/add_remove_elements/")

    def add_elements(self, count):
        # Добавление указанного количества элементов
        for _ in range(count):
            self.driver.find_element(*self.add_button).click()

    def get_elements_count(self):
        # Получение количества добавленных элементов
        return len(self.driver.find_elements(By.CLASS_NAME, self.delete_button_class))

    def delete_all_elements(self):
        # Удаление всех добавленных элементов
        delete_buttons = self.driver.find_elements(By.CLASS_NAME, self.delete_button_class)
        for button in delete_buttons:
            button.click()