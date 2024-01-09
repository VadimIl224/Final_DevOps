#!/bin/bash



cd ~/easy-rsa

Client=$(whiptail  --inputbox "Введите имя клиента" 10 60 3>&1 1>&2 2>&3)
exitstatusClient=$?
if [ $exitstatusClient = 0 ]; then
		./easyrsa import-req /tmp/"$Client".req "$Client"
		./easyrsa sign-req client "$Client"

		PET=$(whiptail  --inputbox "Введите имя пользователя и ip-адрес сервера VPN для подключения ssh в формате user@ip" 10 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus = 0 ]; then
			scp ~/easy-rsa/pki/issued/"$Client".crt $PET:~/vpn-clients/keys/
		
			
		else 
			exit 1
		fi
		whiptail --msgbox "Перейдите на сервер VPN и сформируйте конф.файл клиента"  10 60

else 
	exit 1

fi