#!/bin/bash

# Update package repositories and install prerequisites
sudo apt update -y
sudo apt install -y curl gnupg

# Import Salt GPG key and add SaltStack repository
curl -fsSL https://repo.saltproject.io/py3/debian/10/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo gpg --dearmor -o /usr/share/keyrings/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/debian/10/amd64/latest buster main" | sudo tee /etc/apt/sources.list.d/saltstack.list
sudo apt update -y

# Install Salt Master and Salt Minion
sudo apt install -y salt-master salt-minion

# Create directories and set permissions
sudo mkdir -p /tmp/salt/
sudo chown -R root:root /tmp/salt/
sudo chmod -R 777 /tmp/salt

sudo mkdir -p /srv/salt
sudo chown -R root:root /srv/salt
sudo chmod -R 777 /srv/salt

# Configure Salt Master network interface and ports
echo "===>network.conf"
sudo tee /etc/salt/master.d/network.conf <<EOF
# The network interface to bind to
interface: 0.0.0.0
# The Request/Reply port
ret_port: 4506
# The port minions bind to for commands, aka the publish port
publish_port: 4505
EOF

# Configure Salt Master worker threads
echo "===>thread_options.conf"
sudo tee /etc/salt/master.d/thread_options.conf <<EOF
# Set the number of worker threads for salt-master
worker_threads: 5
EOF

# Restart and enable Salt Master service
sudo systemctl restart salt-master
sudo systemctl enable salt-master 
sudo systemctl start salt-master
sudo systemctl status salt-master

# Install iptables and configure rules
echo "=====> installing iptables"
# sudo apt install -y iptables
sudo apt update
sudo apt install -y iptables
sudo iptables -A INPUT -p tcp --dport 4505 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 4506 -j ACCEPT
sudo apt update
# Preconfigure iptables-persistent
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt install -y iptables-persistent #asking 2 times yes
sudo netfilter-persistent save
sudo iptables-save | sudo tee /etc/iptables/rules.v4
# sudo systemctl restart iptables
sudo systemctl enable netfilter-persistent
sudo systemctl start netfilter-persistent

# Accept Salt minion keys and test Salt installation
sudo salt-key -L
sudo salt-key
sudo salt-key -A --yes
sudo salt '*' test.version
