#!/bin/bash

    cd ~/easy-rsa
   
    ./easyrsa import-req /tmp/server.req server
	
    ./easyrsa sign-req server server
    
    PET=$(whiptail  --inputbox "Введите имя пользователя и ip-адрес сервера VPN для подключения ssh в формате user@ip" 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then

        scp ~/easy-rsa/pki/issued/server.crt  $PET:/tmp
		scp ~/easy-rsa/pki/ca.crt $PET:/tmp
    else
	exit 1
    fi
    whiptail --msgbox "Перейдите на сервер VPN и запустите скрипт insteasyrsavpn2"  10 60

    exit 0
