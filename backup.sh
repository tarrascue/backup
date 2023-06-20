#!/bin/bash

# EPEL
yum install -y epel-release

# borgbackup
yum install -y borgbackup mc nano

# Cоздаем пользователя
useradd -m borg

# backups dir
sudo mkdir /var/backup

sudo chown -R borg:borg /var/backup/

# Создаем каталог .ssh в каталоге /home/borg
sudo mkdir /home/borg/.ssh

# Создаем файл
sudo touch /home/borg/.ssh/authorized_keys

# Назначем права и владельца на каталог и файл
sudo chmod 700 /home/borg/.ssh
sudo chmod 600 /home/borg/.ssh/authorized_keys
sudo chown -R borg:borg  /home/borg/.ssh
