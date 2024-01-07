#!/bin/bash

appstring(){
        # локалка
        sudo iptables -A INPUT -i lo -j ACCEPT
        sudo iptables -A OUTPUT -o lo -j ACCEPT

        # всегда icmp
        sudo iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

        # для установленных соединений
        sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
        sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
       
        # всегда SSH
        sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

        # всегда DNS
        sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
        sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

        # остальное под запретом
        sudo iptables -P INPUT DROP

        sudo service netfilter-persistent save

}


if (whiptail --title "Добавление портов" --yesno "Нужно добавить порты?" 10 60) 
then

                PET=$(whiptail --title "Добавление портов" --inputbox "Добавьте порты через пробел" 10 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ] 
		then
			for i in $PET
			do
				sudo iptables -A INPUT -p tcp --dport "$i" -j ACCEPT
			done
			appstring
			exit 0
		else
			echo Ты выбрал отмену.
			exit 1
		fi

else

appstring
exit 0
fi

