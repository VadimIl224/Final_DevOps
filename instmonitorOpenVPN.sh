#!/bin/bash
wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
rm -f go1.15.2.linux-amd42.tar.gz 

echo 'PATH=$PATH:$HOME/bin:/usr/local/go/bin' >> ~/.bashrc

source ~/.bashrc

wget https://github.com/kumina/openvpn_exporter/archive/v0.3.0.tar.gz
tar xzf v0.3.0.tar.gz
rm -f v0.3.0.tar.gz
cd openvpn_exporter-0.3.0/

sed -i 's#openvpnStatusPaths = flag.String("openvpn.status_paths", "examples/client.status,examples/server2.status,examples/server3.status", "Paths at which OpenVPN places its status files.")#openvpnStatusPaths = flag.String("openvpn.status_paths", "/etc/openvpn/server/openvpn-status.log", "Paths at which OpenVPN places its status files.")#' ./main.go

/usr/local/go/bin/go build -o openvpn_exporter main.go
sudo cp openvpn_exporter /usr/local/bin


echo '[Unit]
Description=Prometheus OpenVPN Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/openvpn_exporter

[Install]
WantedBy=multi-user.target' >> /tmp/openvpn_exporter.service
sudo cp /tmp/openvpn_exporter.service /etc/systemd/system/openvpn_exporter.service
sudo rm /tmp/openvpn_exporter.service

sudo systemctl enable openvpn_exporter

sudo systemctl start openvpn_exporter
