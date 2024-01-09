#!/bin/bash
# First argument: Client identifier
KEY_DIR=~/vpn-clients/keys
OUTPUT_DIR=~/vpn-clients/files
BASE_CONFIG=~/vpn-clients/base.conf
if ! [ -d ~/vpn-clients/files ]; then
	mkdir ~/vpn-clients/files
	chmod -R 700 ~/vpn-clients/files
fi
if ! [ -f ~/vpn-clients/base.conf ]; then
	echo 'client
dev tun
proto udp
remote '$(ip -o -4 route show to default | awk '{print $9}') '1194
resolv-retry infinite
nobind
user nobody
group nobody
persist-key
persist-tun
remote-cert-tls server
tls-crypt ta.key 1
cipher AES-256-GCM
auth SHA256
key-direction 1
verb 3' >> ~/vpn-clients/base.conf
fi
	

sudo cp ~/easy-rsa/ta.key ~/vpn-clients/keys/
sudo cp /etc/openvpn/server/ca.crt ~/vpn-clients/keys/
sudo chown $USER:$USER ~/vpn-clients/keys/*
cat ${BASE_CONFIG} \
<(echo -e '<ca>') \
${KEY_DIR}/ca.crt \
<(echo -e '</ca>\n<cert>') \
${KEY_DIR}/${1}.crt \
<(echo -e '</cert>\n<key>') \
${KEY_DIR}/${1}.key \
<(echo -e '</key>\n<tls-crypt>') \
${KEY_DIR}/ta.key \
<(echo -e '</tls-crypt>') \
> ${OUTPUT_DIR}/${1}.ovpn