### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Будет ошибка: TypeError: unsupported operand type(s) for +: 'int' and 'str'. Происходит сложение целочисленной переменной и строковой. |
| Как получить для переменной `c` значение 12?  | c = str(a) + b |
| Как получить для переменной `c` значение 3?  | c = a + int(b) |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path = "/home/netology/sysadm-homeworks/"
bash_command = ["cd /home/netology/sysadm-homeworks/", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', path)
        print(prepare_result)

```

### Вывод скрипта при запуске при тестировании:
```
netology@docker:~$ ./state.py
/home/netology/sysadm-homeworks/1.sh
/home/netology/sysadm-homeworks/2.sh
/home/netology/sysadm-homeworks/my.lo
/home/netology/sysadm-homeworks/status.py
/home/netology/sysadm-homeworks/zabbix_agentd.log
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

print("Enter path: ")
path = input()
if path[-1] != "/":
    path = path + "/"
bash_command = ["cd" + " " + path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', path)
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
netology@docker:~$ ./state_3.py
Enter path:
/home/netology/sysadm-homeworks
/home/netology/sysadm-homeworks/1.sh
/home/netology/sysadm-homeworks/2.sh
/home/netology/sysadm-homeworks/my.lo
/home/netology/sysadm-homeworks/status.py
/home/netology/sysadm-homeworks/zabbix_agentd.log
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time

services = {"drive.google.com": "0.0.0.0", "mail.google.com": "0.0.0.0", "google.com": "0.0.0.0"}

while 1 == 1:
    for host in services:
        ip = socket.gethostbyname(host)
        if ip != services[host]:
            print("[ERROR]", host, "IP mismatch:", services[host], ip)
        else:
            print(host, "-", ip)
        services[host] = ip
    time.sleep(1)
```

### Вывод скрипта при запуске при тестировании:
```
root@docker:/home/netology# ./check_service.py
[ERROR] drive.google.com IP mismatch: 0.0.0.0 173.194.222.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 64.233.162.19
[ERROR] google.com IP mismatch: 0.0.0.0 64.233.164.101
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 64.233.162.19 64.233.162.83
[ERROR] google.com IP mismatch: 64.233.164.101 64.233.164.139
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 64.233.162.83 64.233.162.18
[ERROR] google.com IP mismatch: 64.233.164.139 64.233.164.113
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 64.233.162.18 64.233.162.17
[ERROR] google.com IP mismatch: 64.233.164.113 64.233.164.138
```
