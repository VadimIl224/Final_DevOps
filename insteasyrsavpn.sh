#!/bin/bash

    cd ~
    mkdir easy-rsa
    ln -s /usr/share/easy-rsa/*  ~/easy-rsa/
    chmod 700 ~/easy-rsa/
    cd ~/easy-rsa
    ./easyrsa init-pki
    
    echo ' if [ -z "$EASYRSA_CALLER" ]; then
    echo "You appear to be sourcing an Easy-RSA *vars* file. This is" >&2
    echo "no longer necessary and is disallowed. See the section called" >&2
    echo "*How to use this file* near the top comments for more details." >&2
    return 1
    fi

    set_var EASYRSA_REQ_COUNTRY "RUS"
    set_var EASYRSA_REQ_PROVINCE "Moscow"
    set_var EASYRSA_REQ_CITY "Moscow city"
    set_var EASYRSA_REQ_ORG "Byte-code"
    set_var EASYRSA_REQ_EMAIL "BC@example.net"
    set_var EASYRSA_REQ_OU "LLC"
    set_var EASYRSA_ALGO ec
    set_var EASYRSA_DIGEST "sha512"' >> vars

    PET=$(whiptail  --inputbox "Введите имя пользователя и ip-адрес сервера УЦ для подключения ssh в формате user@ip" 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then

	sudo scp $PET:~/easy-rsa/pki/ca.crt /usr/local/share/ca-certificates/ca.crt
    else 
    exit 1

    fi
	sudo update-ca-certificates
    cd ~/easy-rsa
    ./easyrsa gen-req server nopass
    sudo cp ~/easy-rsa/pki/private/server.key /etc/openvpn/server/
    scp ~/easy-rsa/pki/reqs/server.req $PET:/tmp
    whiptail --msgbox "Перейдите на сервер удостоверяющего центра и запустите скрипт insteasyrsa2"  10 60
    exit 0
