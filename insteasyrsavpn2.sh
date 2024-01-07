!/bin/bash
    sudo cp /tmp/server.crt /etc/openvpn/server
	sudo cp /tmp/ca.crt /etc/openvpn/server
	
    cd ~/easy-rsa
    sudo openvpn --genkey --secret ta.key
    
	sudo cp ta.key /etc/openvpn/server
	

    whiptail --msgbox "Настройка завершена. Сервер готов к генерации сертификатов клиентов!"  10 60
    exit 0
