#!/bin/bash

wget https://github.com/prometheus/prometheus/releases/download/v2.45.2/prometheus-2.45.2.linux-amd64.tar.gz

sudo mkdir /etc/prometheus /var/lib/prometheus

tar -zxf prometheus-*.linux-amd64.tar.gz

cd prometheus-*.linux-amd64

sudo cp prometheus promtool /usr/local/bin/
sudo cp -r console_libraries consoles prometheus.yml /etc/prometheus

cd .. && rm -rf prometheus-*.linux-amd64/ && rm -f prometheus-*.linux-amd64.tar.gz

sudo useradd --no-create-home --shell /bin/false prometheus

sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}

echo '[Unit]
Description=Prometheus Service
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
 --config.file /etc/prometheus/prometheus.yml \
 --storage.tsdb.path /var/lib/prometheus/ \
 --web.console.templates=/etc/prometheus/consoles \
 --web.console.libraries=/etc/prometheus/console_libraries
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' >> /tmp/prometheus.service
sudo cp /tmp/prometheus.service /etc/systemd/system/prometheus.service
sudo rm /tmp/prometheus.service


sudo systemctl enable prometheus

sudo chown -R prometheus:prometheus /var/lib/prometheus

sudo systemctl start prometheus

# alertmanager

wget https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-amd64.tar.gz

sudo mkdir -p /etc/alertmanager /var/lib/prometheus/alertmanager

tar -zxf alertmanager-*.linux-amd64.tar.gz

cd alertmanager-*.linux-amd64

sudo cp alertmanager amtool /usr/local/bin/
sudo cp alertmanager.yml /etc/alertmanager

cd .. && rm -rf alertmanager-*.linux-amd64/

sudo useradd --no-create-home --shell /bin/false alertmanager

sudo chown -R alertmanager:alertmanager /etc/alertmanager /var/lib/prometheus/alertmanager

sudo chown alertmanager:alertmanager /usr/local/bin/{alertmanager,amtool}

sudo echo '[Unit]
Description=Alertmanager Service
After=network.target

[Service]
EnvironmentFile=-/etc/default/alertmanager
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
          --config.file=/etc/alertmanager/alertmanager.yml \
          --storage.path=/var/lib/prometheus/alertmanager \
          --cluster.advertise-address=0.0.0.0:9093 \
          $ALERTMANAGER_OPTS
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target' >> /tmp/alertmanager.service
sudo cp /tmp/alertmanager.service /etc/systemd/system/alertmanager.service
sudo rm /tmp/alertmanager.service


sudo systemctl enable alertmanager

sudo systemctl start alertmanager

