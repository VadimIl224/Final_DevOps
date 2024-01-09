#!/bin/bash
if ! [ -d ~/vpn-clients/keys ]; then
	mkdir -p ~/vpn-clients/keys
	chmod -R 700 ~/vpn-clients
fi



cd ~/easy-rsa

Client=$(whiptail  --inputbox "Введите имя клиента" 10 60 3>&1 1>&2 2>&3)
exitstatusClient=$?
if [ $exitstatusClient = 0 ]; then
		./easyrsa gen-req "$Client" nopass
		cp ~/easy-rsa/pki/private/"$Client".key ~/vpn-clients/keys/

		PET=$(whiptail  --inputbox "Введите имя пользователя и ip-адрес сервера УЦ для подключения ssh в формате user@ip" 10 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		if [ $exitstatus = 0 ]; then
			scp ~/easy-rsa/pki/reqs/"$Client".req $PET:/tmp
		else 
			exit 1
		fi
		whiptail --msgbox "Перейдите на сервер удостоверяющего центра и подпишиите сертификат"  10 60

else 
	exit 1

fi

