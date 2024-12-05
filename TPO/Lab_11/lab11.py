from selenium import webdriver
from selenium.webdriver.common.by import By
from pages.login_page import LoginPage
from pages.file_upload_page import FileUploadPage
from pages.dropdown_page import DropdownPage
from pages.checkboxes_page import CheckboxesPage
from pages.add_remove_elements_page import AddRemoveElementsPage

def test_login():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        login_page = LoginPage(driver)
        login_page.open()
        login_page.login("tomsmith", "SuperSecretPassword!")
        assert login_page.is_login_successful(), "Авторизация не удалась"
    finally:
        driver.quit()

# Тест для проверки неудачной авторизации с неверными данными
def test_failed_login_with_invalid_credentials():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        login_page = LoginPage(driver)
        login_page.open()
        login_page.login("invalid_user", "invalid_password")  # Ввод неверных данных
        assert login_page.is_error_message_displayed(), "Сообщение об ошибке не отображается при неверных данных"
    finally:
        driver.quit()

# Тест для проверки загрузки файла
def test_file_upload():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        file_upload_page = FileUploadPage(driver)  # Создание объекта страницы загрузки файла
        file_upload_page.open()  # Открытие страницы загрузки
        file_path = r"D:\masha\university\TPO\test_file.txt"
        file_upload_page.upload_file(file_path)
        assert file_upload_page.is_upload_successful(), "Файл не был загружен успешно"
    finally:
        driver.quit()

# Тест для проверки работы выпадающего списка
def test_dropdown():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        dropdown_page = DropdownPage(driver)
        dropdown_page.open()
        assert dropdown_page.select_option("2"), "Не удалось выбрать элемент из выпадающего списка"
    finally:
        driver.quit()

# Тест для проверки работы чекбоксов
def test_checkboxes():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        checkboxes_page = CheckboxesPage(driver)
        checkboxes_page.open()
        checkboxes_page.toggle_checkbox(0, check=True)
        checkboxes_page.toggle_checkbox(1, check=False)
    finally:
        driver.quit()

# Тест для проверки переключения состояния чекбокса
def test_toggle_selected_checkbox():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        checkboxes_page = CheckboxesPage(driver)
        checkboxes_page.open()
        checkboxes_page.toggle_checkbox(0, check=True)
        assert checkboxes_page.toggle_checkbox(0, check=False) == False, "Чекбокс должен быть снят"
        assert not driver.find_elements(*checkboxes_page.checkboxes)[0].is_selected(), "Чекбокс должен быть не выбран"
    finally:
        driver.quit()

# Тест для добавления и удаления элементов
def test_add_remove_elements():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        add_remove_page = AddRemoveElementsPage(driver)
        add_remove_page.open()
        add_remove_page.add_elements(3)
        assert add_remove_page.get_elements_count() == 3, "Количество добавленных элементов неверное"
        add_remove_page.delete_all_elements()
        assert add_remove_page.get_elements_count() == 0, "Не все элементы были удалены"
    finally:
        driver.quit()

# Тест для проверки отображения элементов после добавления
def test_elements_display_after_adding():
    driver = webdriver.Edge()
    driver.implicitly_wait(10)
    try:
        add_remove_page = AddRemoveElementsPage(driver)
        add_remove_page.open()
        add_remove_page.add_elements(2)
        assert add_remove_page.get_elements_count() == 2, "Количество добавленных элементов должно быть 2"
        elements = driver.find_elements(By.CLASS_NAME, "added-manually")  # Получение элементов
        assert len(elements) == 2, "Элементы должны отображаться на странице после добавления"
    finally:
        driver.quit()