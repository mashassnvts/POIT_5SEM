from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Edge()

# Открытие сайта
driver.get("https://www.mts.by")
driver.implicitly_wait(10)
#1 CSS
try:
    button = driver.find_element(By.CSS_SELECTOR, '#pay-connection > button')
    print("Найден элемент по CSS-селектору '#pay-connection > button' :", button.text)
except:
    print("элемент по CSS-селектору '#pay-connection > button' не найден")
try:
    us = driver.find_element(By.CSS_SELECTOR, 'body > div.layout.layout--default > header > div.container-fluid > div > div > div.page-header__auth > a > div > svg > use')
    print("Найден элемент по CSS-селектору 'body > div.layout.layout--default > header > div.container-fluid > div > div > div.page-header__auth > a > div > svg > use':", us.text)
except:
    print("элемент по CSS-селектору 'body > div.layout.layout--default > header > div.container-fluid > div > div > div.page-header__auth > a > div > svg > use' не найден")
try:
    basket = driver.find_element(By.CSS_SELECTOR, 'body > div.layout.layout--default > header > div.top > div > div > div.top-links > div:nth-child(2) > a')
    print("Найден элемент по CSS-селектору 'body > div.layout.layout--default > header > div.top > div > div > div.top-links > div:nth-child(2) > a':", basket.text)
except:
    print("элемент по CSS-селектору 'body > div.layout.layout--default > header > div.top > div > div > div.top-links > div:nth-child(2) > a' не найден")
# 1 XPath

try:
    button_xpath1 = driver.find_element(By.XPATH,"/html/body/div[6]/header/div[1]/div/div/div[3]/div/a")
    print("Найден элемент по XPath(карьера) '/html/body/div[6]/header/div[1]/div/div/div[3]/div/a':",
          button_xpath1.text)
except:
    print("Элемент по XPath  '/html/body/div[6]/header/div[1]/div/div/div[3]/div/a' не найден")

# 2
try:
    button_xpath = driver.find_element(By.XPATH, "/html/body/div[6]/main/div/div[2]/div/div[2]/button[3]")
    print("Найден элемент по XPath(принять) '/html/body/div[6]/main/div/div[2]/div/div[2]/button[3]':", button_xpath.text)
except:
    print("Элемент по XPath '/html/body/div[6]/main/div/div[2]/div/div[2]/button[3]'")
# 3
try:
    button_xpath = driver.find_element(By.XPATH, "/html/body/div[6]/main/div/div[4]/section[1]/div[2]/div/div[2]/button[1]")
    print("Найден элемент по XPath swipe '/html/body/div[6]/main/div/div[4]/section[1]/div[2]/div/div[2]/button[1]", button_xpath.text)
except:
    print("Элемент по XPath  '/html/body/div[6]/main/div/div[4]/section[1]/div[2]/div/div[2]/button[1]' не найден")
#тэг
try:
    h2_elements = driver.find_elements(By.TAG_NAME, "h2")
    for h2 in h2_elements:
        print("Найден заголовок h2:", h2.text)
except:
    print("Элемент по тегу 'span' не найден")
# частичный текст
try:
    element_by_partial_link = driver.find_element(By.PARTIAL_LINK_TEXT, "Финансы")
    print("Найден элемент по частичному тексту ссылки 'Финансы':", element_by_partial_link.get_attribute("href"))
except:
    print("Элемент по частичному тексту ссылки 'Финансы' не найден")
driver.quit()
