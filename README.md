# Backup

```
vagrant up
```

При запуске стенда в Vagrant файле создаётся дополнительный диск на 3 Гб и выполняются скрипты backup.sh и client.sh

После запуска стенда заходим на сервер backup
```
vagrant ssh backup
```

Смотрим диски и настраиваем sdb

<img width="336" alt="image" src="https://github.com/tarrascue/backup/assets/117171128/eb7fe5f2-ac76-408f-bab7-faf9bf597111">

Отформатируем в xfs и монтируем
```
mkfs -t xfs /dev/sdb1
mount -w /dev/sdb1 /var/backup/
chown -R borg:borg /var/backup/
```

подкючаемся на client 

```
vagrant ssh client
```

генерируем ssh ключ и добавляем его на bacup в /home/borg/.ssh/authorized_keys

Инициализируем репозиторий borg на backup сервере с client сервера
```
borg upgrade --disable-tam ssh://borg@192.168.56.160/var/backup
borg init --encryption=repokey borg@192.168.56.160:/var/backup/
```

Запускаем для проверки создания бэкапа
```
borg create --stats --list borg@192.168.56.160:/var/backup/::etc-{now:%Y-%m-%d_%H:%M:%S} /etc
```
<img width="380" alt="image" src="https://github.com/tarrascue/backup/assets/117171128/b3794086-fd76-4a36-8755-3929d5b32b65">

сомтрим список бекапов и достаем файл 

<img width="589" alt="image" src="https://github.com/tarrascue/backup/assets/117171128/df999358-cad3-4515-a076-773b5bcbe026">

Включаем и запускаем службу таймера
```
sudo systemctl enable borg-backup.timer
sudo systemctl start borg-backup.timer
```

Проверяем статус
```
sudo systemctl status borg-backup.timer

	● borg-backup.timer - Borg Backup
	   Loaded: loaded (/etc/systemd/system/borg-backup.timer; enabled; vendor preset: disabled)
	   Active: active (waiting) since Mon 2023-06-20 16:24:15 UTC; 20s ago
```
проверяем список бекапов

<img width="596" alt="image" src="https://github.com/tarrascue/backup/assets/117171128/ecada1cb-bb6c-4f85-b696-e78ab7af6ca2">
