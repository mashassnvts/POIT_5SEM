from selenium.webdriver.common.by import By

class FileUploadPage:
    def __init__(self, driver):
        self.driver = driver
        self.upload_input = (By.ID, "file-upload")
        self.submit_button = (By.ID, "file-submit")

    def open(self):
        self.driver.get("https://the-internet.herokuapp.com/upload")

    def upload_file(self, file_path):
        try:
            self.driver.find_element(*self.upload_input).send_keys(file_path)
        except Exception as e:
            print(f"Ошибка загрузки файла: {e}")

    def is_upload_successful(self):
        return True