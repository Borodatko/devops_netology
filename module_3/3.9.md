**1.**\
***[Bitwarden](https://github.com/Borodatko/devops_netology/blob/699819da7e75cd4a5776ee097b8d33d90fabacb2/Bitwarden.jpg)***


\
**3.**\
***root@docker:~/testssl.sh# dpkg -l | grep apache2***\
_ii  apache2                             2.4.51-1\~deb11u1               amd64        Apache HTTP Server\
ii  apache2-bin                         2.4.51-1\~deb11u1               amd64        Apache HTTP Server (modules and other binary files)\
ii  apache2-data                        2.4.51-1\~deb11u1               all          Apache HTTP Server (common files)\
ii  apache2-utils                       2.4.51-1\~deb11u1               amd64        Apache HTTP Server (utility programs for web servers)_

***root@docker:~/testssl.sh# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/httpd-self.key -out /etc/ssl/certs/httpd.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=Test/OU=Org/CN=www.test.org"***

_Generating a RSA private key\
..+++++\
.....................................+++++\
writing new private key to '/etc/ssl/private/httpd-self.key'_


***root@docker:~/testssl.sh# cat /etc/apache2/sites-available/test.conf***\
_<Virtualhost *:443>\
    ServerName 192.168.43.28\
    DocumentRoot /var/www/test_
    _SSLEngine on\
    SSLCertificateFile /etc/ssl/certs/httpd-self.crt\
    SSLCertificateKeyFile /etc/ssl/private/httpd-self.key\
</VirtualHost>_

***root@docker:\~/testssl.sh# mkdir /var/www/test\
root@docker:\~/testssl.sh# cat /var/www/test/index.html***\
_\<h1>it worked!\</h1>_

***root@docker:\~/testssl.sh# a2ensite test.conf\
root@docker:\~/testssl.sh# apache2ctl configtest***\
_Syntax OK_\
***root@docker:~/testssl.sh# systemctl reload apache2***

Screen


\
**4.**\
***root@docker:~# git clone --depth 1 https://github.com/drwetter/testssl.sh.git***
_Cloning into 'testssl.sh'...\
remote: Enumerating objects: 100, done.\
remote: Counting objects: 100% (100/100), done.\
remote: Compressing objects: 100% (93/93), done.\
remote: Total 100 (delta 14), reused 39 (delta 6), pack-reused 0\
Receiving objects: 100% (100/100), 8.55 MiB | 7.75 MiB/s, done.\
Resolving deltas: 100% (14/14), done._\
***root@docker:\~# cd testssl.sh/\
root@docker:\~# ./testssl.sh -U --sneaky https://www.netology.ru/***

_Testing all IPv4 addresses (port 443): 104.22.40.171 172.67.21.207 104.22.41.171_

 _Start 2021-12-09 21:40:23        -->> 104.22.40.171:443 (netology.ru) <<--_

 _Further IP addresses:   172.67.21.207 104.22.41.171 2606:4700:10::6816:29ab 2606:4700:10::ac43:15cf 2606:4700:10::6816:28ab\
 rDNS (104.22.40.171):   --\
 Service detected:       HTTP_


 _Testing vulnerabilities_

 _Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension\
 CCS (CVE-2014-0224)                       not vulnerable (OK)\
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets\
 ROBOT                                     not vulnerable (OK)\
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed\
 Secure Client-Initiated Renegotiation     not vulnerable (OK)\
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)\
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested\
                                           Can be ignored for static pages or if no secrets in the page\
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)\
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)\
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers\
 FREAK (CVE-2015-0204)                     not vulnerable (OK)\
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)\
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services\
                                           https://censys.io/ipv4?q=0E745E5E77A60345EB6E6B33B99A36286C2203D687F3377FBC685B2434518C53 could help you to find out\
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2\
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA AES128-SHA ECDHE-RSA-AES256-SHA AES256-SHA DES-CBC3-SHA\
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)\
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches\
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)\
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)_


 _Done 2021-12-09 21:40:59 [  38s] -->> 104.22.40.171:443 (netology.ru) <<--_

_---------------------------------------------------------------------------------------------------------\
 Start 2021-12-09 21:40:59        -->> 172.67.21.207:443 (netology.ru) <<--_

 _Further IP addresses:   104.22.41.171 104.22.40.171 2606:4700:10::6816:29ab 2606:4700:10::ac43:15cf 2606:4700:10::6816:28ab\
 rDNS (172.67.21.207):   --\
 Service detected:       HTTP_


\
**5.**\
***root@docker:~/testssl.sh# dpkg -l | grep openssh-server***\
_ii  openssh-server                      1:8.4p1-5                      amd64        secure shell (SSH) server, for secure access from remote machines_

***dorlov@docker:~$ ssh-keygen***
_Generating public/private rsa key pair.\
Enter file in which to save the key (/home/dorlov/.ssh/id_rsa):\
Created directory '/home/dorlov/.ssh'.\
Enter passphrase (empty for no passphrase):\
Enter same passphrase again:\
Your identification has been saved in /home/dorlov/.ssh/id_rsa\
Your public key has been saved in /home/dorlov/.ssh/id_rsa.pub\
The key fingerprint is:\
SHA256:sWdxna0nqt/dA2SfZYdLle8JvfjZJslE79CZImqh5i4 dorlov@docker\
The key's randomart image is:\
+---[RSA 3072]----+\
|                .|\
|             . +.|\
|        . . . +oo|\
|         o o ++o=|\
|        S o oo**X|\
|         + . =+X+|\
|        . o oo++o|\
|     E o o . .+==|\
|      =o. ... .o+|\
+----[SHA256]-----+_\
***dorlov@docker:~$ ssh-copy-id root@192.168.43.11***\
_/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/dorlov/.ssh/id_rsa.pub"\
The authenticity of host '192.168.43.11 (192.168.43.11)' can't be established.\
ECDSA key fingerprint is SHA256:U7qHN03lkq4Jdzd881Jn7+/q9ao+GP3pAQ3Cw/CbVF8.\
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes\
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed\
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys\
root@192.168.43.11's password:_

_Number of key(s) added: 1_

_Now try logging into the machine, with:   "ssh 'root@192.168.43.11'"\
and check to make sure that only the key(s) you wanted were added._

***dorlov@docker:~$ ssh root@192.168.43.11***
_Last login: Fri Dec 10 21:59:05 2021\
[root@centos-srv ~]#_


\
**6.**\
***dorlov@docker:\~/.ssh$ mv id_rsa id_new_rsa\
dorlov@docker:\~/.ssh$ mv id_rsa.pub id_new_rsa.pub\
dorlov@docker:\~/.ssh$ ssh -i ~/.ssh/id_new_rsa root@192.168.43.11\
dorlov@docker:\~/.ssh$ cat config***\
_Host centos-srv\
        Hostname 192.168.43.11\
        User dorlov_\
***dorlov@docker:\~/.ssh$ sudo systemctl restart sshd\
dorlov@docker:\~/.ssh$ ssh -i ~/.ssh/id_new_rsa root@centos-srv***\
_Last login: Fri Dec 10 22:08:39 2021 from docker.ddns.net\
[root@centos-srv ~]# exit\
logout_


\
**7.**\
***root@docker:~# tcpdump -w enp0s3.pcap -c 100 -i enp0s3***
_tcpdump: listening on enp0s3, link-type EN10MB (Ethernet), snapshot length 262144 bytes\
100 packets captured\
125 packets received by filter\
0 packets dropped by kernel_

***[Wireshark](https://github.com/Borodatko/devops_netology/blob/699819da7e75cd4a5776ee097b8d33d90fabacb2/Wireshark.jpg)***


\
**8.**\
***root@docker:/home/dorlov# nmap scanme.nmap.org***
_Starting Nmap 7.80 ( https://nmap.org ) at 2021-12-10 22:36 MSK\
Nmap scan report for scanme.nmap.org (45.33.32.156)\
Host is up (0.81s latency).\
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f\
Not shown: 949 filtered ports, 48 closed ports\
PORT      STATE SERVICE\
22/tcp    open  ssh\
80/tcp    open  http\
31337/tcp open  Elite_

_Nmap done: 1 IP address (1 host up) scanned in 1965.33 seconds_

***Services: SSH, HTTP, ELITE***


\
**9.**\
***root@docker:/home/dorlov# ufw status verbose***\
_Status: inactive_\
***root@docker:/home/dorlov# ufw allow ssh/tcp***\
_Rules updated
Rules updated (v6)_\
***root@docker:/home/dorlov# ufw allow http/tcp***\
_Rules updated
Rules updated (v6)_\
***root@docker:/home/dorlov# ufw allow https/tcp***\
_Rules updated
Rules updated (v6)_\
***root@docker:/home/dorlov# ufw logging on***\
_Logging enabled_\
***root@docker:/home/dorlov# ufw enable***\
_Command may disrupt existing ssh connections. Proceed with operation (y|n)? y\
Firewall is active and enabled on system startup_\
***root@docker:/home/dorlov# ufw status verbose***\
_Status: active\
Logging: on (low)\
Default: deny (incoming), allow (outgoing), deny (routed)\
New profiles: skip_

_To                         Action      From\
--                         ------      ----\
22/tcp                     ALLOW IN    Anywhere\
80/tcp                     ALLOW IN    Anywhere\
443/tcp                    ALLOW IN    Anywhere\
22/tcp (v6)                ALLOW IN    Anywhere (v6)\
80/tcp (v6)                ALLOW IN    Anywhere (v6)\
443/tcp (v6)               ALLOW IN    Anywhere (v6)_

