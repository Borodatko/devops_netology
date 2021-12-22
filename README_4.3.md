# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
  
***"ip: 71.78.22.43 <- не хватает кавычек***

```
 { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"  <-
            }
        ]
    }
```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import json
import yaml


services = {"drive.google.com": "0.0.0.0", "mail.google.com": "0.0.0.0", "google.com": "0.0.0.0"}

while 1 == 1:
    for host in services:
        ip = socket.gethostbyname(host)
        if ip != services[host]:
            print("[ERROR]", host, "IP mismatch:", services[host], ip)
        else:
            print(host, "-", ip)
        ### YAML
        yfile = open('/var/log/ip.yml', 'a')
        ydata = yaml.dump([{host: ip}])
        yfile.write(ydata)
        yfile.close()
        ### JSON
        jfile = open('/var/log/ip.json', 'a')
        jdata = json.dumps({host: ip})
        jfile.write(jdata)
        jfile.close()
        services[host] = ip
    time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
root@docker:~# ./check_service.py
[ERROR] drive.google.com IP mismatch: 0.0.0.0 173.194.222.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 64.233.162.18
[ERROR] google.com IP mismatch: 0.0.0.0 64.233.164.100
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 64.233.162.18 64.233.162.83
[ERROR] google.com IP mismatch: 64.233.164.100 64.233.164.102
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 64.233.162.83 64.233.162.19
[ERROR] google.com IP mismatch: 64.233.164.102 64.233.164.101
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.19"}{"google.com": "64.233.164.100"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.17"}{"google.com": "64.233.164.102"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.18"}{"google.com": "64.233.164.101"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.83"}{"google.com": "64.233.164.139"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.19"}{"google.com": "64.233.164.113"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.18"}{"google.com": "64.233.164.100"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.83"}{"google.com": "64.233.164.102"}{"drive.google.com": "173.194.222.194"}{"mail.google.com": "64.233.162.19"}{"google.com": "64.233.164.101"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.19
- google.com: 64.233.164.100
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.17
- google.com: 64.233.164.102
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.18
- google.com: 64.233.164.101
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.83
- google.com: 64.233.164.139
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.19
- google.com: 64.233.164.113
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.18
- google.com: 64.233.164.100
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.83
- google.com: 64.233.164.102
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.162.19
- google.com: 64.233.164.101
```
