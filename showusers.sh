#!/bin/bash

# нужно установить nmap sshpass
# скрипт выводит список активных хостов и пользователей на них в сети

if [[ "$1" ]]	# проверяем введен ли список адресов для проверки
	then
		nmap -p 22 -oG .tmp --version-light $1 > /tmp/tt 2>&1		# записывем IP адреса с открытым 22 портом в временный файл
	else
		echo Введите сеть; exit		# выходим, если не введен аргумент
fi

ERR=0	# счетчик неудачых подключений

for HOST in $(cat .tmp | grep 'open' | cut -f 2 -d ' ')         # проходим по каждому адресу
do
	DATA=$(sshpass -p "M3gaTek$" ssh -o StrictHostKeychecking=no adminmt@$HOST 'hostname;users' 2>/tmp/tt)	# получаем username hostname с удаленки
	if [[ "$DATA" ]]	# если hostname username получены
	then
		HOSTNAME=$(echo $DATA | cut -f 1 -d ' ')	# присваеваем hostname
		USERNAME=$(echo $DATA | cut -f 2 -d ' ')	# присваеваем username
		echo $HOST \| host: $HOSTNAME \| user: $USERNAME	# выводим в консоль
	else
		ERR=$(($ERR + 1))
	fi
done
rm .tmp		# удаляем временный файл
echo $ERR неудавшихся подключений
