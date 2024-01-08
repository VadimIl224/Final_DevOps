#!/bin/bash
eth=$(ip -o -4 route show to default | awk '{print $5}')

sudo echo 'port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key  
dh none
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
keepalive 10 120
tls-crypt ta.key 
cipher AES-256-GCM
auth SHA256
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
explicit-exit-notify 1' 
push "redirect-gateway def1"' >> /tmp/server.conf
sudo cp /tmp/server.conf /etc/openvpn/server/server.conf
sudo rm /tmp/server.conf
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p

sudo iptables -A INPUT -i "$eth" -m state --state NEW -p udp --dport 1194 -j ACCEPT
sudo iptables -A INPUT -i tun+ -j ACCEPT
sudo iptables -A FORWARD -i tun+ -j ACCEPT
sudo iptables -A FORWARD -i tun+ -o "$eth" -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i "$eth" -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$eth" -j MASQUERADE
sudo service netfilter-persistent save

sudo systemctl -f enable openvpn-server@server.service
sudo systemctl start openvpn-server@server.service
