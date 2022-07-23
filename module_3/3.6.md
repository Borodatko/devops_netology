**1.**\
***root@docker:~# telnet stackoverflow.com 80***\
_Trying 151.101.65.69...\
Connected to stackoverflow.com.\
Escape character is '^]'.\
GET /questions HTTP/1.0\
HOST: stackoverflow.com_

_HTTP/1.1 301 Moved Permanently\
cache-control: no-cache, no-store, must-revalidate\
location: https://stackoverflow.com/questions\
x-request-guid: 85d48776-584e-4bb2-8619-cd68a8bd8de8\
feature-policy: microphone 'none'; speaker 'none'\
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com\
Accept-Ranges: bytes\
Date: Tue, 30 Nov 2021 15:16:27 GMT\
Via: 1.1 varnish\
Connection: close\
X-Served-By: cache-hhn4058-HHN\
X-Cache: MISS\
X-Cache-Hits: 0\
X-Timer: S1638285387.986591,VS0,VE85\
Vary: Fastly-SSL\
X-DNS-Prefetch-Control: off\
Set-Cookie: prov=3b0dd920-c529-e442-292b-d72a48974a3c; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly_

_Connection closed by foreign host.\
root@docker:~#_

***301 - постоянный редирект***


\
**2.**\
***[Screen_1](https://github.com/Borodatko/devops_netology/blob/19a26912738c5483f0dfdd488ba46b574c77c807/stackoverflow.jpg)***

_Состояние\
301\
Moved Permanently\
ВерсияHTTP/1.1\
Передано52,98 КБ (размер 175,88 КБ)_

***[Screen_2](https://github.com/Borodatko/devops_netology/blob/19a26912738c5483f0dfdd488ba46b574c77c807/stackoverflow2.jpg)***

***Ожидание - 131мс, все стальное по 0мс.***_


\
**3.**\
***84.23.37.85***


\
**4.**\
***root@docker:~# whois 84.23.37.85 | grep 'descr\|origin'***\
_descr:          Informational-measuring systems Ltd.\
descr:          Informational-measuring systems\
origin:         AS29319_


\
**5.**\
***root@docker:~# traceroute -An 8.8.8.8***\
_traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets\
 1  192.168.43.1 [*]  0.721 ms  0.442 ms  0.548 ms\
 2  84.23.37.81 [AS29319]  174.476 ms  198.202 ms  198.938 ms\
 3  10.40.0.1 [*]  197.791 ms  197.645 ms  197.307 ms\
 4  * * *\
 5  195.208.208.250 [AS5480]  197.680 ms  197.570 ms  197.589 ms\
 6  108.170.250.66 [AS15169]  197.432 ms 108.170.250.99 [AS15169]  64.010 ms *\
 7  * * *\
 8  108.170.235.204 [AS15169]  168.269 ms 172.253.65.159 [AS15169]  235.907 ms 74.125.253.109 [AS15169]  168.163 ms\
 9  142.250.56.217 [AS15169]  168.740 ms 172.253.51.241 [AS15169]  168.080 ms 216.239.47.173 [AS15169]  168.039 ms\
10  * * *\
11  * * *\
12  * * *\
13  * * *\
14  * * *\
15  * * *\
16  * * *\
17  * * *\
18  * * *\
19  8.8.8.8 [AS15169]  84.719 ms  70.060 ms  32.211 ms_


\
**6.**\
***[Screen](https://github.com/Borodatko/devops_netology/blob/19a26912738c5483f0dfdd488ba46b574c77c807/mtr.jpg)***

***209.85.255.136  64.9%    38   19.5  24.6  19.5  52.4   9.8***


\
**7.**\
***8.8.4.4\
8.8.8.8***

***root@docker:~# dig dns.google***

_; <<>> DiG 9.16.22-Debian <<>> dns.google\
;; global options: +cmd\
;; Got answer:\
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53613\
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1_

_;; OPT PSEUDOSECTION:\
; EDNS: version: 0, flags:; udp: 1280\
;; QUESTION SECTION:\
;dns.google.                    IN      A_

_;; ANSWER SECTION:\
dns.google.             3874    IN      A       8.8.4.4\
dns.google.             3874    IN      A       8.8.8.8_

_;; Query time: 4 msec\
;; SERVER: 192.168.43.1#53(192.168.43.1)\
;; WHEN: Tue Nov 30 18:35:43 MSK 2021\
;; MSG SIZE  rcvd: 71_


\
**8.**\
***root@docker:~# dig -x 8.8.4.4***

_; <<>> DiG 9.16.22-Debian <<>> -x 8.8.4.4\
;; global options: +cmd\
;; Got answer:\
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60546\
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1_

_;; OPT PSEUDOSECTION:\
; EDNS: version: 0, flags:; udp: 1280\
;; QUESTION SECTION:\
;4.4.8.8.in-addr.arpa.          IN      PTR_

_;; ANSWER SECTION:\
4.4.8.8.in-addr.arpa.   79968   IN      PTR     dns.google._

_;; Query time: 24 msec\
;; SERVER: 192.168.43.1#53(192.168.43.1)\
;; WHEN: Tue Nov 30 18:38:26 MSK 2021\
;; MSG SIZE  rcvd: 73_

***root@docker:~# dig -x 8.8.8.8***

_; <<>> DiG 9.16.22-Debian <<>> -x 8.8.8.8\
;; global options: +cmd\
;; Got answer:\
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7948\
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1_

_;; OPT PSEUDOSECTION:\
; EDNS: version: 0, flags:; udp: 1280\
;; QUESTION SECTION:\
;8.8.8.8.in-addr.arpa.          IN      PTR_

_;; ANSWER SECTION:\
8.8.8.8.in-addr.arpa.   84081   IN      PTR     dns.google._

_;; Query time: 4 msec\
;; SERVER: 192.168.43.1#53(192.168.43.1)\
;; WHEN: Tue Nov 30 18:38:31 MSK 2021\
;; MSG SIZE  rcvd: 73_
