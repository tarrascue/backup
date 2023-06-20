#!/bin/bash

# EPEL
yum install -y epel-release

# borgbackup
yum install -y borgbackup mc nano

# Создаем сервис

sudo touch /etc/systemd/system/borg-backup.service

sudo cat <<EOT >> /etc/systemd/system/borg-backup.service
[Unit]
Description=Borg Backup

[Service]
Type=oneshot

# Парольная фраза
Environment=BORG_PASSPHRASE=1

#Repo
Environment=REPO=borg@192.168.56.160:/var/backup/

#  backup dir
Environment=BACKUP_TARGET=/etc

# Bacup create
ExecStart=/bin/borg create \\
--stats \\
\${REPO}::etc-{now:%%Y-%%m-%%d_%%H:%%M:%%S} \${BACKUP_TARGET}

# Backup veryfy
ExecStart=/bin/borg check \${REPO}

# rotate
ExecStart=/bin/borg prune \\
--keep-daily 90 \\
--keep-monthly 12 \\
--keep-yearly 1 \\
\${REPO} 
EOT

# timer

sudo touch /etc/systemd/system/borg-backup.timer

sudo cat <<EOT >> /etc/systemd/system/borg-backup.timer
[Unit]
Description=Borg Backup

[Timer]
OnUnitActiveSec=5min
Unit=borg-backup.service

[Install]
WantedBy=timers.target
EOT
