from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

# Configurando o driver do Firefox
driver = webdriver.Firefox()

# Abrindo a página about:config
driver.get("about:config")

# Encontrando o elemento da preferência media.peerconnection.enabled
preference = driver.find_element_by_xpath("//tr[td/span[text()='media.peerconnection.enabled']]")

# Dando dois cliques na preferência para alterar seu valor para falso
actions = ActionChains(driver)
actions.double_click(preference).perform()

# Fechando o navegador
driver.quit()

#TODO: adc mais comandos com base no livro de opsec do Vieira