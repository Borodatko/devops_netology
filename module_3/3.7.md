**1.**\
***root@docker:~# ip -o -4 a***
_1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever\
2: enp0s3    inet 192.168.43.28/27 brd 192.168.43.31 scope global dynamic enp0s3\       valid_lft 86283sec preferred_lft 86283sec\
3: docker0    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0\       valid_lft forever preferred_lft forever_

***на винде ipconfig /all***


\
**2.**\
***Протокол - lldp\
Пакет - lldpd***


\
**3.**\
***Для разделения широковещательного домена на поддомены используется технология vlan.\
Пакет - vlan***

***Настраивается в сетевых настройках в зависимости от дистрибутива Linux:***

***В дебе через /etc/network/interfaces:***\
_auto eth0.192\
iface eth0.192 inet static\
    address 192.168.1.1\
	netmask 255.255.255.0\
	vlan_raw_device eth0_

***В rhel-подобных через /etc/sysconfig/network-scripts/ifcfg-device_name:***\
_DEVICE=enp1s0.192 #где 192 - vlan ID\
BOOTPROTO=none\
ONBOOT=yes\
IPADDR=192.168.1.1\
PREFIX=24\
NETWORK=192.168.1.0\
VLAN=yes_

***Возможно потребуется подключить к ядру модуль 8021q, отвечающий за 802.1q инкапсуляцию.***


\
**4.**\
***Типы:\
bonding\
teaming***

***Опции:\
Вручную\
LACP***

***Деб:***\
_auto eno1\
iface eno1 inet dhcp_

_auto eno2\
iface eno2 inet dhcp_

_auto bond0\
iface bond0 inet static\
address 192.168.1.1/24\
gateway 192.168.1.254\
dns-nameservers 8.8.8.8 1.1.1.1\
slaves eno1 eno2\
bond-mode 802.3ad\
bond-lacp-rate slow_


\
**5.**\
***10.10.10.0/29\
10.10.10.1 - 10.10.10.6 - ip pool\
10.10.10.7 - broadcast***

***Из /24 можно нарезать 32 /29 подсети.***

_10.10.10.0/29\
10.10.10.8/29\
10.10.10.16/29\
10.10.10.128/29\
10.10.10.240/29\
10.10.10.248/29_


\
**6.**\
***Берем из подсети 100.64.0.0/10\
100.64.0.0/26 (на 64 хоста) первая организация\
100.64.1.0/26 (на 64 хоста) вторая организация\
100.64.64.0/30 (на 2 хоста) для бордеров между организациями***


\
**7.**\
Просмотр arp кэша:\
***root@docker:~# arp -a #BSD вариант***\
? (192.168.43.8) at 00:0e:04:03:09:77 [ether] on enp0s3\
tst2018.ddns.net (192.168.43.1) at 88:d7:f6:6d:3a:48 [ether] on enp0s3

***root@docker:~# arp -e #Linux вариант***\
Address                  HWtype  HWaddress           Flags Mask            Iface\
192.168.43.8             ether   00:0e:04:03:09:77   C                     enp0s3\
tst2018.ddns.net         ether   88:d7:f6:6d:3a:48   C                     enp0s3

***root@docker:~# arp -n #Без резолва, указываются только ip адреса***\
Address                  HWtype  HWaddress           Flags Mask            Iface\
192.168.43.8             ether   00:0e:04:03:09:77   C                     enp0s3\
192.168.43.1             ether   88:d7:f6:6d:3a:48   C                     enp0s3

Чистка всего кэша:\
***ip -s -s neigh flush all***

Удаление одного адреса:\
***arp -d x.x.x.x***


На винде:

Просмотр:\
***arp -a***

Чистка всего кэша:\
***netsh interface ip delete arpcache***

Удаление одного адреса:\
***arp -d x.x.x.x***
