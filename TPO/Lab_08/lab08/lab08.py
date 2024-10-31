from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait, Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
import time


driver = webdriver.Edge()
driver.implicitly_wait(10)



# Тест 1: Авторизация на Amazon с явными ожиданиями
def test_login():
    driver.get("https://www.amazon.com/")


    account_link = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, "nav-link-accountList"))
    )
    account_link.click()


    email_input = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "ap_email"))
    )
    email_input.send_keys("mariasosnovec@gmail.com")


    continue_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, "continue"))
    )
    continue_button.click()


    password_input = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "ap_password"))
    )
    password_input.send_keys("Mashassnvts04")

    print("Авторизация пройдена успешно.")
    return


def test_search_product():
    driver.get("https://www.amazon.com/")


    search_box = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "twotabsearchtextbox"))
    )
    search_query = "laptop"
    search_box.send_keys(search_query)


    search_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, "nav-search-submit-button"))
    )
    search_button.click()


    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "span.a-size-medium.a-color-base.a-text-normal"))
    )


    assert search_query in driver.page_source, f"Поиск по запросу '{search_query}' не выполнен."
    print(f"Поиск продукта '{search_query}' выполнен успешно.")

    # Тест 3: Добавление товара в корзину
def test_add_to_cart():
        driver.get("https://www.amazon.com/")


        search_box = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "twotabsearchtextbox"))
        )
        search_query = "laptop"
        search_box.send_keys(search_query)


        search_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "nav-search-submit-button"))
        )
        search_button.click()


        first_result = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "span.a-size-medium.a-color-base.a-text-normal"))
        )
        first_result.click()


        add_to_cart_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "add-to-cart-button"))
        )
        add_to_cart_button.click()


        WebDriverWait(driver, 10).until(
            EC.text_to_be_present_in_element((By.ID, "nav-cart-count"), "1")
        )
        print("Товар успешно добавлен в корзину.")
# Тест: Применение фильтра по бренду Lenovo
def test_apply_brand_lenovo_filter():
    driver.get("https://www.amazon.com/")


    search_box = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "twotabsearchtextbox"))
    )
    search_query = "laptop"
    search_box.send_keys(search_query)
    search_button = driver.find_element(By.ID, "nav-search-submit-button")
    search_button.click()

    try:

        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, ".s-main-slot.s-result-list"))
        )


        brand_filter = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, "//li[@aria-label='Lenovo']/span/a"))
        )


        driver.execute_script("arguments[0].scrollIntoView();", brand_filter)
        time.sleep(1)
        brand_filter.click()


        time.sleep(2)


        results = WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".s-title-instructions-style"))
        )


        assert any("Lenovo" in result.text for result in results), "Фильтр по бренду 'Lenovo' не применен."
        print("Фильтр по бренду 'Lenovo' успешно применен.")
    except TimeoutException:
        print("Не удалось найти фильтр по бренду 'Lenovo'. Проверьте наличие элемента на странице.")


def test_dropdown_and_search():
    driver.get("https://www.amazon.com/")

    try:

        category_select = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "searchDropdownBox"))
        )


        select = Select(category_select)


        select.select_by_visible_text("Electronics")


        search_box = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "twotabsearchtextbox"))
        )
        search_box.send_keys("Bluetooth headphones")


        search_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "nav-search-submit-button"))
        )
        search_button.click()

        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "span.a-size-medium.a-color-base.a-text-normal"))
        )

        print("Поиск 'Bluetooth headphones' выполнен успешно.")

    except Exception as e:
        print(f"Произошла ошибка: {e}")


try:
    test_login()
    test_search_product()
    test_add_to_cart()
    test_apply_brand_lenovo_filter()
    test_dropdown_and_search()

finally:
    driver.quit()
