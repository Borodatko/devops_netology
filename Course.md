**Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.**

```
#### UFW INSTALL
root@debian:~# apt install ufw
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  ufw
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 164 kB of archives.
After this operation, 852 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian buster/main amd64 ufw all 0.36-1 [164 kB]
Fetched 164 kB in 0s (664 kB/s)
Preconfiguring packages ...
Selecting previously unselected package ufw.
(Reading database ... 32298 files and directories currently installed.)
Preparing to unpack .../archives/ufw_0.36-1_all.deb ...
Unpacking ufw (0.36-1) ...
Setting up ufw (0.36-1) ...

Creating config file /etc/ufw/before.rules with new version

Creating config file /etc/ufw/before6.rules with new version

Creating config file /etc/ufw/after.rules with new version

Creating config file /etc/ufw/after6.rules with new version
Created symlink /etc/systemd/system/multi-user.target.wants/ufw.service > /lib/systemd/system/ufw.service.
Processing triggers for man-db (2.8.5-2) ...
Processing triggers for rsyslog (8.1901.0-1) ...
Processing triggers for systemd (241-7~deb10u8) ...


#### UFW CONFIG
root@debian:~# ufw status verbose
Status: inactive
root@debian:~# ufw allow ssh/tcp
Rules updated
Rules updated (v6)
root@debian:~# ufw allow https/tcp
Rules updated
Rules updated (v6)
root@debian:~# ufw allow from 127.0.0.1 to any
Rules updated
root@debian:~# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
root@debian:~# ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
Anywhere                   ALLOW       127.0.0.1
22/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
```



**Установите hashicorp vault.**

```
#### INSTALL VAULT
root@debian:~# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
root@debian:~# echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" >> /etc/apt/sources.list
root@debian:~# apt update
Hit:1 http://security.debian.org/debian-security buster/updates InRelease
Hit:2 http://deb.debian.org/debian buster InRelease
Hit:3 http://deb.debian.org/debian buster-updates InRelease
Get:4 https://apt.releases.hashicorp.com buster InRelease [9,497 B]
Get:5 https://apt.releases.hashicorp.com buster/main amd64 Packages [41.2 kB]
Fetched 50.7 kB in 1s (76.7 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
All packages are up to date.
root@debian:~# apt install vault
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  vault
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 69.4 MB of archives.
After this operation, 188 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com buster/main amd64 vault amd64 1.9.2 [69.4 MB]
Fetched 69.4 MB in 5s (14.8 MB/s)
Selecting previously unselected package vault.
(Reading database ... 32725 files and directories currently installed.)
Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...
Unpacking vault (1.9.2) ...
Setting up vault (1.9.2) ...
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
...........................................................................................++++
........................................++++
writing new private key to 'tls.key'
-----
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.


netology@debian:~$ vault server -dev -dev-root-token-id=root &
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.2
             Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf

==> Vault server started! Log data will stream in below:
[output ommited]

netology@debian:~$ export VAULT_ADDR=http://127.0.0.1:8200
netology@debian:~$ export VAULT_TOKEN=root
netology@debian:~$ nano admin-policy.hcl
Добавить в admin-policy.hcl:
# Enable secrets engine
path "sys/mounts/*" {
    capabilities = [ "create", "read", "update", "delete", "list" ]
}


# List enabled secrets engine
path "sys/mounts" {
    capabilities = [ "read", "list" ]
}


# Work with pki secrets engine
path "pki*" {
    capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
netology@debian:~$ vault policy write admin admin-policy.hcl
Success! Uploaded policy: admin
```



**Cоздайте центр сертификации и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).**

```
#### GENERATE CA
netology@debian:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
netology@debian:~$ vault secrets tune -max-lease-ttl=262800h pki
Success! Tuned the secrets engine at: pki/
netology@debian:~$ vault write -field=certificate pki/root/generate/internal common_name="Root CA" country="Russian Federation" locality="Moscow" ttl=262800h > CA_cert.crt
netology@debian:~$ vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls

#### GENERATE INTERMEDIATE CA
netology@debian:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
netology@debian:~$ vault write -format=json pki_int/intermediate/generate/internal common_name="Intermediate CA" country="Russian Federation" locality="Moscow" ttl=175200h | jq -r '.data.csr' > pki_intermediate.csr
netology@debian:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr country="Russian Federation" locality="Moscow" format=pem_bundle ttl=175200h | jq -r '.data.certificate' > intermediate.cert.pem
netology@debian:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed

#### CREATE ROLE
netology@debian:~$ vault write pki_int/roles/example-dot-com allowed_domains="example.com" allow_subdomains=true max_ttl=87600h
Success! Data written to: pki_int/roles/example-dot-com

#### REQUEST CERT
netology@debian:~$ vault write -format=json pki_int/issue/example-dot-com common_name="web.example.com" ttl="730h" > web.example.com.crt
netology@debian:~$ cat web.example.com.crt | jq -r .data.certificate > web.example.com.crt.pem
netology@debian:~$ cat web.example.com.crt | jq -r .data.issuing_ca >> web.example.com.crt.pem
netology@debian:~$ cat web.example.com.crt | jq -r .data.private_key > web.example.com.crt.key
```



**Установите nginx.**

```#### INSTALL NGINX
root@debian:~# apt install nginx
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg62-turbo libnginx-mod-http-auth-pam libnginx-mod-http-dav-ext
  libnginx-mod-http-echo libnginx-mod-http-geoip libnginx-mod-http-image-filter libnginx-mod-http-subs-filter libnginx-mod-http-upstream-fair
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5 libwebp6 libxpm4 libxslt1.1 nginx-common nginx-full
Suggested packages:
  libgd-tools fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg62-turbo libnginx-mod-http-auth-pam libnginx-mod-http-dav-ext
  libnginx-mod-http-echo libnginx-mod-http-geoip libnginx-mod-http-image-filter libnginx-mod-http-subs-filter libnginx-mod-http-upstream-fair
  libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5 libwebp6 libxpm4 libxslt1.1 nginx nginx-common nginx-full
0 upgraded, 23 newly installed, 0 to remove and 0 not upgraded.
Need to get 4,573 kB of archives.
After this operation, 10.1 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://security.debian.org/debian-security buster/updates/main amd64 libtiff5 amd64 4.1.0+git191117-2~deb10u3 [271 kB]
Get:2 http://deb.debian.org/debian buster/main amd64 fonts-dejavu-core all 2.37-1 [1,068 kB]
Get:3 http://deb.debian.org/debian buster/main amd64 fontconfig-config all 2.13.1-2 [280 kB]
Get:4 http://deb.debian.org/debian buster/main amd64 libfontconfig1 amd64 2.13.1-2 [346 kB]
Get:5 http://deb.debian.org/debian buster/main amd64 libjpeg62-turbo amd64 1:1.5.2-2+deb10u1 [133 kB]
Get:6 http://deb.debian.org/debian buster/main amd64 libjbig0 amd64 2.1-3.1+b2 [31.0 kB]
Get:7 http://deb.debian.org/debian buster/main amd64 libwebp6 amd64 0.6.1-2+deb10u1 [261 kB]
Get:8 http://deb.debian.org/debian buster/main amd64 libxpm4 amd64 1:3.5.12-1 [49.1 kB]
Get:9 http://deb.debian.org/debian buster/main amd64 libgd3 amd64 2.2.5-5.2 [136 kB]
Get:10 http://deb.debian.org/debian buster/main amd64 nginx-common all 1.14.2-2+deb10u4 [121 kB]
Get:11 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-auth-pam amd64 1.14.2-2+deb10u4 [92.8 kB]
Get:12 http://deb.debian.org/debian buster/main amd64 libxslt1.1 amd64 1.1.32-2.2~deb10u1 [237 kB]
Get:13 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-dav-ext amd64 1.14.2-2+deb10u4 [100 kB]
Get:14 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-echo amd64 1.14.2-2+deb10u4 [104 kB]
Get:15 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-geoip amd64 1.14.2-2+deb10u4 [94.1 kB]
Get:16 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-image-filter amd64 1.14.2-2+deb10u4 [97.6 kB]
Get:17 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-subs-filter amd64 1.14.2-2+deb10u4 [95.9 kB]
Get:18 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-upstream-fair amd64 1.14.2-2+deb10u4 [96.0 kB]
Get:19 http://deb.debian.org/debian buster/main amd64 libnginx-mod-http-xslt-filter amd64 1.14.2-2+deb10u4 [95.9 kB]
Get:20 http://deb.debian.org/debian buster/main amd64 libnginx-mod-mail amd64 1.14.2-2+deb10u4 [126 kB]
Get:21 http://deb.debian.org/debian buster/main amd64 libnginx-mod-stream amd64 1.14.2-2+deb10u4 [147 kB]
Get:22 http://deb.debian.org/debian buster/main amd64 nginx-full amd64 1.14.2-2+deb10u4 [501 kB]
Get:23 http://deb.debian.org/debian buster/main amd64 nginx all 1.14.2-2+deb10u4 [88.5 kB]
Fetched 4,573 kB in 1s (7,200 kB/s)
Preconfiguring packages ...
Selecting previously unselected package fonts-dejavu-core.
(Reading database ... 32731 files and directories currently installed.)
Preparing to unpack .../00-fonts-dejavu-core_2.37-1_all.deb ...
Unpacking fonts-dejavu-core (2.37-1) ...
Selecting previously unselected package fontconfig-config.
Preparing to unpack .../01-fontconfig-config_2.13.1-2_all.deb ...
Unpacking fontconfig-config (2.13.1-2) ...
Selecting previously unselected package libfontconfig1:amd64.
Preparing to unpack .../02-libfontconfig1_2.13.1-2_amd64.deb ...
Unpacking libfontconfig1:amd64 (2.13.1-2) ...
Selecting previously unselected package libjpeg62-turbo:amd64.
Preparing to unpack .../03-libjpeg62-turbo_1%3a1.5.2-2+deb10u1_amd64.deb ...
Unpacking libjpeg62-turbo:amd64 (1:1.5.2-2+deb10u1) ...
Selecting previously unselected package libjbig0:amd64.
Preparing to unpack .../04-libjbig0_2.1-3.1+b2_amd64.deb ...
Unpacking libjbig0:amd64 (2.1-3.1+b2) ...
Selecting previously unselected package libwebp6:amd64.
Preparing to unpack .../05-libwebp6_0.6.1-2+deb10u1_amd64.deb ...
Unpacking libwebp6:amd64 (0.6.1-2+deb10u1) ...
Selecting previously unselected package libtiff5:amd64.
Preparing to unpack .../06-libtiff5_4.1.0+git191117-2~deb10u3_amd64.deb ...
Unpacking libtiff5:amd64 (4.1.0+git191117-2~deb10u3) ...
Selecting previously unselected package libxpm4:amd64.
Preparing to unpack .../07-libxpm4_1%3a3.5.12-1_amd64.deb ...
Unpacking libxpm4:amd64 (1:3.5.12-1) ...
Selecting previously unselected package libgd3:amd64.
Preparing to unpack .../08-libgd3_2.2.5-5.2_amd64.deb ...
Unpacking libgd3:amd64 (2.2.5-5.2) ...
Selecting previously unselected package nginx-common.
Preparing to unpack .../09-nginx-common_1.14.2-2+deb10u4_all.deb ...
Unpacking nginx-common (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-auth-pam.
Preparing to unpack .../10-libnginx-mod-http-auth-pam_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-auth-pam (1.14.2-2+deb10u4) ...
Selecting previously unselected package libxslt1.1:amd64.
Preparing to unpack .../11-libxslt1.1_1.1.32-2.2~deb10u1_amd64.deb ...
Unpacking libxslt1.1:amd64 (1.1.32-2.2~deb10u1) ...
Selecting previously unselected package libnginx-mod-http-dav-ext.
Preparing to unpack .../12-libnginx-mod-http-dav-ext_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-dav-ext (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-echo.
Preparing to unpack .../13-libnginx-mod-http-echo_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-echo (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-geoip.
Preparing to unpack .../14-libnginx-mod-http-geoip_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-geoip (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-image-filter.
Preparing to unpack .../15-libnginx-mod-http-image-filter_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-image-filter (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-subs-filter.
Preparing to unpack .../16-libnginx-mod-http-subs-filter_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-subs-filter (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-upstream-fair.
Preparing to unpack .../17-libnginx-mod-http-upstream-fair_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-upstream-fair (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-http-xslt-filter.
Preparing to unpack .../18-libnginx-mod-http-xslt-filter_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-http-xslt-filter (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-mail.
Preparing to unpack .../19-libnginx-mod-mail_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-mail (1.14.2-2+deb10u4) ...
Selecting previously unselected package libnginx-mod-stream.
Preparing to unpack .../20-libnginx-mod-stream_1.14.2-2+deb10u4_amd64.deb ...
Unpacking libnginx-mod-stream (1.14.2-2+deb10u4) ...
Selecting previously unselected package nginx-full.
Preparing to unpack .../21-nginx-full_1.14.2-2+deb10u4_amd64.deb ...
Unpacking nginx-full (1.14.2-2+deb10u4) ...
Selecting previously unselected package nginx.
Preparing to unpack .../22-nginx_1.14.2-2+deb10u4_all.deb ...
Unpacking nginx (1.14.2-2+deb10u4) ...
Setting up libxpm4:amd64 (1:3.5.12-1) ...
Setting up nginx-common (1.14.2-2+deb10u4) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service > /lib/systemd/system/nginx.service.
Setting up libjbig0:amd64 (2.1-3.1+b2) ...
Setting up libjpeg62-turbo:amd64 (1:1.5.2-2+deb10u1) ...
Setting up libnginx-mod-http-auth-pam (1.14.2-2+deb10u4) ...
Setting up libnginx-mod-http-geoip (1.14.2-2+deb10u4) ...
Setting up libwebp6:amd64 (0.6.1-2+deb10u1) ...
Setting up fonts-dejavu-core (2.37-1) ...
Setting up libnginx-mod-http-echo (1.14.2-2+deb10u4) ...
Setting up libnginx-mod-http-subs-filter (1.14.2-2+deb10u4) ...
Setting up libxslt1.1:amd64 (1.1.32-2.2~deb10u1) ...
Setting up libtiff5:amd64 (4.1.0+git191117-2~deb10u3) ...
Setting up libnginx-mod-http-dav-ext (1.14.2-2+deb10u4) ...
Setting up libnginx-mod-mail (1.14.2-2+deb10u4) ...
Setting up fontconfig-config (2.13.1-2) ...
Setting up libnginx-mod-stream (1.14.2-2+deb10u4) ...
Setting up libnginx-mod-http-upstream-fair (1.14.2-2+deb10u4) ...
Setting up libnginx-mod-http-xslt-filter (1.14.2-2+deb10u4) ...
Setting up libfontconfig1:amd64 (2.13.1-2) ...
Setting up libgd3:amd64 (2.2.5-5.2) ...
Setting up libnginx-mod-http-image-filter (1.14.2-2+deb10u4) ...
Setting up nginx-full (1.14.2-2+deb10u4) ...
Setting up nginx (1.14.2-2+deb10u4) ...
Processing triggers for ufw (0.36-1) ...
Processing triggers for systemd (241-7~deb10u8) ...
Processing triggers for man-db (2.8.5-2) ...
Processing triggers for libc-bin (2.28-10) ...
```



**Настройте nginx на https, используя ранее подготовленный сертификат.**

Закомментировать в /etc/nginx/sites-available/default строки:
```
#       listen 80 default_server;
#       listen [::]:80 default_server;
```

И добавить:
```
listen              443 ssl;
server_name         web.example.com;
ssl_certificate     /home/netology/web.example.com.crt.pem;
ssl_certificate_key /home/netology/web.example.com.crt.key;
ssl_protocols       TLSv1.2 TLSv1.3;
ssl_ciphers         HIGH:!aNULL:!MD5;
```

```
root@debian:/home/netology# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@debian:/home/netology# systemctl enable nginx
Synchronizing state of nginx.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable nginx
root@debian:/home/netology# systemctl start nginx
root@debian:/home/netology# systemctl status nginx
  nginx.service - A high performance web server and a reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2022-01-02 21:43:50 MSK; 1h 20min ago
     Docs: man:nginx(8)
 Main PID: 1220 (nginx)
    Tasks: 3 (limit: 4915)
   Memory: 8.9M
   CGroup: /system.slice/nginx.service
           +-1220 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
           +-1221 nginx: worker process
           L-1222 nginx: worker process
```



**Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.**

***[Screen_1](https://github.com/Borodatko/devops_netology/blob/efdfdbc6b3fb985860d224a7148467883388219d/web.jpg)***



**Создайте скрипт, который будет генерировать новый сертификат в vault.**

```
netology@debian:~$ cat /home/netology/cert.sh
#!/usr/bin/env bash

export dir=/home/netology
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

/usr/bin/vault policy write admin $dir/admin-policy.hcl

# Rewoke certificate
serial=$(grep serial_number $dir/web.example.com.crt | sed -e 's/[[:blank:]]//g; s/"serial_number"://; s/^"//; s/"$//')
vault write pki_int/revoke serial_number=$serial

# Remove expired certificates
vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true

# Request certificate
vault write -format=json pki_int/issue/example-dot-com common_name="web.example.com" ttl="730h" > $dir/web.example.com.crt
cat /dev/null > $dir/web.example.com.crt.pem
cat $dir/web.example.com.crt | jq -r .data.certificate > $dir/web.example.com.crt.pem
cat $dir/web.example.com.crt | jq -r .data.issuing_ca >> $dir/web.example.com.crt.pem
cat $dir/web.example.com.crt | jq -r .data.private_key > $dir/web.example.com.crt.key

# Reload nginx config
sudo /etc/init.d/nginx reload
```
Для reload онфига nginx в sudoers добавить:
```
netology        ALL = NOPASSWD: /etc/init.d/nginx
```



**Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.**

```
netology@debian:~$ crontab -l
# m h  dom mon dow   command
0 0 1 * *     /home/netology/cert.sh
```


**Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо).**

```
netology@debian:~$ date
Mon Jan  3 16:25:50 MSK 2022
netology@debian:~$ crontab -l
# m h  dom mon dow   command
27 16 * * *     /home/netology/cert.sh
netology@debian:~$ date
Mon Jan  3 16:27:05 MSK 2022
```
Скриншот в указанием срока действия сертификата:\
***[Screen_2](https://github.com/Borodatko/devops_netology/blob/efdfdbc6b3fb985860d224a7148467883388219d/web_update_cert.jpg)***
