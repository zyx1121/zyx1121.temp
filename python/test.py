from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

START_STATION = 2
DESTINATION_STATION = 8

options = webdriver.ChromeOptions()
options.add_experimental_option('detach', True)



driver = webdriver.Chrome(options=options)
driver.get('https://irs.thsrc.com.tw/IMINT/?utm_source=thsrc&utm_medium=btnlink&utm_term=booking')

driver.implicitly_wait(5)

driver.find_element(By.ID, 'cookieAccpetBtn').click()

select = Select(driver.find_element(By.NAME, 'selectStartStation'))
select.select_by_index(START_STATION)

select = Select(driver.find_element(By.NAME, 'selectDestinationStation'))
select.select_by_index(DESTINATION_STATION)

driver.find_element(By.XPATH, '//*[@id="BookingS1Form"]/div[3]/div[2]/div/div[1]/div[1]/input[2]').click()
driver.implicitly_wait(5)
driver.find_element(By.XPATH, '//*[@id="mainBody"]/div[9]/div[2]/div/div[2]/div[2]/span[26]-day').click()
