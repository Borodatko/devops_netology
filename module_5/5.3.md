## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


https://hub.docker.com/repository/docker/borodatko/mynginx



## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.


```
Высоконагруженное монолитное java веб-приложение;
Физический сервер, так как приложение высоконагруженное, т.е. доступ должен быть без каких-либо дополнительых прослоек в лице гипервизора.

Nodejs веб-приложение;
Docker, для веб-приложения этого будет достаточно.

Мобильное приложение c версиями для Android и iOS;
Виртуальная машина, т.к. физический сервер будет избыточен, а контейнеризация недостаточна.
Оптимальным как мне кажется будет стэк виртуальных машин с балансировкой нагрузки.

Шина данных на базе Apache Kafka;
Без разницы виртуальная машина или физический сервер. Выбор можно сделать в пользу виртуальной машины как более дешевого решения, в отличие от физического сервера.

Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Виртуальные машины, сборка в кластер для отказоустойчивости.

Мониторинг-стек на базе Prometheus и Grafana;
Docker, быстрое развертывание, высокая масштабируемость.

MongoDB, как основное хранилище данных для java-приложения;
Виртуальная машина, не указано, что приложение высоконагруженное, иначе был бы физический сервер.

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
Виртуальная машина с настройкой автоматического резервного копирования и создания snapshot.
```


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```
root@docker:/# docker pull centos
root@docker:/# docker run -v /data:/data --name centos -dit centos
a57e1012f334e6bf24b20abdc4ae061edfc086c36f2dfe158336595118ceb477
root@docker:/# docker pull debian
root@docker:/# docker run -v /data:/data --name debian -dit debian
71d31cd689b7b52f2956c56a697519be1c3af02f95749ba8d38452efcb986440
root@docker:/# docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
71d31cd689b7   debian    "bash"        4 seconds ago        Up 3 seconds                  debian
a57e1012f334   centos    "/bin/bash"   About a minute ago   Up About a minute             centos
root@docker:/# docker exec -it a57e1012f334 bash
[root@a57e1012f334 /]# ls /
bin  data  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@a57e1012f334 /]# echo "Hello, World!" > /data/netology.txt
[root@a57e1012f334 /]# ls /data/netology.txt
/data/netology.txt
[root@a57e1012f334 /]# cat /data/netology.txt
Hello, World!
[root@a57e1012f334 /]# exit
exit
root@docker:/# echo "Netology" > /data/devops.txt
root@docker:/# ls /data
devops.txt  netology.txt
root@docker:/# cat /data/devops.txt
Netology
root@docker:/# docker exec -it 71d31cd689b7 bash
root@71d31cd689b7:/# cat /etc/debian_version
11.2
root@71d31cd689b7:/# ls -l /data
total 8
-rw-r--r-- 1 root root  9 Jan 31 11:45 devops.txt
-rw-r--r-- 1 root root 14 Jan 31 11:44 netology.txt
root@71d31cd689b7:/# cat /data/devops.txt
Netology
root@71d31cd689b7:/# cat /data/netology.txt
Hello, World!
```


## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


https://hub.docker.com/repository/docker/borodatko/ansible
