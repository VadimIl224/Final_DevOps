#!/bin/bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz

tar -zxf node_exporter-*.linux-amd64.tar.gz

cd node_exporter-*.linux-amd64

sudo cp node_exporter /usr/local/bin/

cd .. && rm -rf node_exporter-*.linux-amd64/ && rm -f node_exporter-*.linux-amd64.tar.gz

sudo useradd --no-create-home --shell /bin/false nodeusr

sudo chown -R nodeusr:nodeusr /usr/local/bin/node_exporter

sudo echo '[Unit]
Description=Node Exporter Service
After=network.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' >> /tmp/node_exporter.service
sudo cp /tmp/node_exporter.service /etc/systemd/system/node_exporter.service
sudo rm /tmp/node_exporter.service

sudo systemctl enable node_exporter

sudo systemctl start node_exporter
