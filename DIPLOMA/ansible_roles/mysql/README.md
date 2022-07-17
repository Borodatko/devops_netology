MySQL
=========

This role installs MySQL and configures DB replication. 
Works only on CentOS 7.

Requirements
------------

 - Ansible community.mysql modules must be installed
 - And also PyMySQL module

Example Playbook
----------------

An example of using role:

```yaml
- hosts: mysql
  roles:
    - mysql
```

License
-------

BSD-3-Clause

Author Information
------------------

Orlov Dmitriy
