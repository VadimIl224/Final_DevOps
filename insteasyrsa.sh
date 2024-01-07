#!/bin/bash

    echo поехали
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

    echo Создание ключей:
    ./easyrsa build-ca nopass

    exit 0
