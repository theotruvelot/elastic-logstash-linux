#!/bin/bash
echo "Installing gnupg"
sudo apt-get install gnupg

echo "Installing java"
sudo apt-get install default-jre

echo "Adding deb elasticsearch repo"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
cat /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update

echo "Start install of logstash"
sudo apt-get install logstash

sudo systemctl enable logstash
sudo systemctl start logstash

sudo usermod -a -G adm logstash
echo "logstash installed"

echo "Copy logstash config"
cp -R ./conf.d /etc/logstash/
cp -R ./patterns.d /etc/logstash/
cp -R ./ext /etc/logstash/

read -p "Enter the IP of the elasticsearch server: " elasticsearch_ip
sed -i "s/%ELASTICSEARCH_IP%/$elasticsearch_ip/g" /etc/logstash/conf.d/90-output.conf

read -p "Enter the hostname of the server: " hostname
sed -i "s/%HOSTNAME%/$hostname/g" /etc/logstash/conf.d/90-output.conf

read -p "Enter the elastic search username: " elastic_username
sed -i "s/%ELASTIC_USERNAME%/$elastic_username/g" /etc/logstash/conf.d/90-output.conf

read -p "Enter the elastic search password: " elastic_password
sed -i "s/%ELASTIC_PASSWORD%/$elastic_password/g" /etc/logstash/conf.d/90-output.conf

chown -R logstash /etc/logstash

echo "Restart logstash"
sudo systemctl restart logstash

echo "Logstash initial setup complete"