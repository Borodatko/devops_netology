
## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

```
Continuous Integration:
 - Наличие текущей стабильной версии;
 - Ранее обнаружение и устранение дефектов;
 - Сокращение стоимости исправления дефекта за счет его раннего выявления.

 Continuous Delivery:
 - Возможность подстраивания под изменение бизнес-стратегии;
 - Низкое количество потенциальных ошибок;
 - Оперативный запуск новых версий.

Continuous Deployment:
 - Не требуется ручное вмешательство;
 - Автоматическое развертывание всех изменений.
```

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

```
Не требуется дополнительная расстановка каких-либо агентов, ansible использует в своей работе ssh, поэтому достаточно пользователя с правами администратора.
Push, в этом случае у нас есть единая точка входа, но она должна быть защищена, насколько это возможно.
```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

```
[orlov@it-14-14 ~]$ VBoxManage --version
6.1.22r144080

[orlov@it-14-14 ~]$ VBoxManage --version
6.1.22r144080

[orlov@it-14-14 ~]$ ansible --version
ansible 2.10.7
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/orlov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.7/dist-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.7.3 (default, Jan 22 2021, 20:04:44) [GCC 8.3.0]
```
