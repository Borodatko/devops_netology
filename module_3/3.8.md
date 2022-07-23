**1.**\
***route-views>sh ip route 84.23.32.0 255.255.240.0***\
_Routing entry for 84.23.32.0/20\
  Known via "bgp 6447", distance 20, metric 0\
  Tag 6939, type external\
  Last update from 64.71.137.241 4d00h ago\
  Routing Descriptor Blocks:_\
  _* 64.71.137.241, from 64.71.137.241, 4d00h ago\
      Route metric is 0, traffic share count is 1\
      AS Hops 2\
      Route tag 6939\
      MPLS label: none_


***route-views>sh bgp 84.23.32.0 255.255.240.0***\
_BGP routing table entry for 84.23.32.0/20, version 1391857163\
Paths: (24 available, best #24, table default)\
  Not advertised to any peer\
  Refresh Epoch 3\
  3303 6939 29319\
    217.192.89.50 from 217.192.89.50 (138.187.128.158)\
      Origin IGP, localpref 100, valid, external\
      Community: 3303:1006 3303:1021 3303:1030 3303:3067 6939:7154 6939:8233 6939:9002\
      path 7FE0428BB780 RPKI State not found\
      rx pathid: 0, tx pathid: 0\
  Refresh Epoch 1\
  4901 6079 31133 8641 29319\
    162.250.137.254 from 162.250.137.254 (162.250.137.254)\
      Origin IGP, localpref 100, valid, external\
      Community: 65000:10100 65000:10300 65000:10400\
      path 7FE0CF781FB0 RPKI State not found\
      rx pathid: 0, tx pathid: 0\
  Refresh Epoch 1\
  701 1273 12389 8641 29319\
    137.39.3.55 from 137.39.3.55 (137.39.3.55)\
      Origin IGP, localpref 100, valid, external\
      path 7FE0E37AD948 RPKI State not found\
      rx pathid: 0, tx pathid: 0_


\
**2.**\
***ip link add dummy0 type dummy\
ip addr add 3.3.3.3/32 dev dummy0***

***либо на постоянку в /etc/network/interfaces***

_auto dummy0\
iface dummy0 inet static\
    address 3.3.3.3\
    netmask 255.255.255.255\
    pre-up ip link add dummy0 type dummy\
    post-down ip link del dummy0_


***root@docker:~# ip -o -4 a***\
_1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever\
2: enp0s3    inet 192.168.43.28/27 brd 192.168.43.31 scope global dynamic enp0s3\       valid_lft 86070sec preferred_lft 86070sec\
***3: dummy0    inet 3.3.3.3/32 brd 3.3.3.3 scope global dummy0\       valid_lft forever preferred_lft forever***\
4: docker0    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0\       valid_lft forever preferred_lft forever_


\
**3.**\
***root@docker:~# netstat -talpen | grep -v tcp6***\
_Active Internet connections (servers and established)\
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name\
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      0          12415      679/nginx: master p\
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          12101      620/sshd: /usr/sbin\
tcp        0      0 192.168.43.28:22        192.168.43.8:7332       ESTABLISHED 0          12827      851/sshd: user [p_


***HTTP nginx 80 port\
SSH 22 port***


\
**4.**\
***root@docker:~# netstat -ualpen***\
_Active Internet connections (servers and established)\
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name\
udp        0      0 0.0.0.0:68              0.0.0.0:*                           0          11249      449/dhclient_

***dhclient 68 port***


\
**5.**\
***[Diag](https://github.com/Borodatko/devops_netology/blob/3c1a60c697b999734323d661aa5b33be8484b2a3/diag.png)***


