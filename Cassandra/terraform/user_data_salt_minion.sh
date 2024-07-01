#!/bin/bash

# Update package repositories and install prerequisites
sudo apt update -y
sudo apt install -y curl gnupg awscli

# Import Salt GPG key and add SaltStack repository
curl -fsSL https://repo.saltproject.io/py3/debian/10/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo gpg --dearmor -o /usr/share/keyrings/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/debian/10/amd64/latest buster main" | sudo tee /etc/apt/sources.list.d/saltstack.list
sudo apt update -y

# Install Salt Minion
sudo apt install -y salt-minion

# Configure AWS CLI with hard-coded credentials
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_DEFAULT_REGION=""

mkdir -p ~/.aws
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

cat <<EOF > ~/.aws/config
[default]
region = $AWS_DEFAULT_REGION
EOF

# Fetch the Salt master private IP dynamically (adjust the AWS CLI command as per your setup)
MASTER_PRIVATE_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Cassandra_Salt_Master" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)
echo "Master Private IP: $MASTER_PRIVATE_IP"

# Write the master IP address to the minion configuration file
sudo tee /etc/salt/minion.d/master.conf <<EOF
# Override the default Salt master setting
master: $MASTER_PRIVATE_IP
EOF

# Declare the minion ID
sudo tee /etc/salt/minion.d/id.conf <<EOF
id: key_1
EOF

# Configure mine_functions
sudo tee -a /etc/salt/minion <<EOF
mine_functions:
  network.ip_addrs: []
EOF

# Restart Salt minion to apply changes (adjust for your init system if not using systemd)
sudo systemctl restart salt-minion

# Uncomment and update the master configuration in /etc/salt/minion
sudo sed -i 's/^#\(.*master: salt.*\)/\1/' /etc/salt/minion
sudo sed -i "s/master: salt/master: $MASTER_PRIVATE_IP/" /etc/salt/minion

# Add a new line to the /etc/hosts file
echo "$MASTER_PRIVATE_IP salt" | sudo tee -a /etc/hosts

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
# Enable and start Salt Minion service
sudo systemctl enable salt-minion
sudo systemctl start salt-minion
