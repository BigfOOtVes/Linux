#!/bin/bash
if [[ "$1" ]]	# проверяем введен ли список адресов для проверки, если нет, то используются адреса CHK
	then
		IPLIST=$(nmap -sn $1 | grep 'report' | cut -f 5 -d ' ')		# получаем список IP адресов по указанной сети в аргументе
	else
		IPLIST=$(nmap -sn 10.65.76.0/24 | grep 'report' | cut -f 5 -d ' ')	# получеем список IP адресов ЧК
fi

ERR=0	# счетчик неудачых подключений

for HOST in $IPLIST	# проходим по каждому адресу
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

echo $ERR неудавшихся подключений
