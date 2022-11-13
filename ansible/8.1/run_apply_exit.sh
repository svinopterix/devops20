#!/usr/bin/bash

echo "Starting containers:"
sudo docker start centos7
sudo docker start ubuntu
sudo docker start fedora

sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

echo "Killing containers:"
sudo docker kill centos7
sudo docker kill ubuntu
sudo docker kill fedora
