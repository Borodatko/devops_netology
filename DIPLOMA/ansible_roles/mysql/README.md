MySQL
=========

Ansible role for MySQL cluster installation & configuration.


Requirements
------------

 - Ansible community.mysql module
 - PyMySQL module


Role Variables
--------------

| Name | Description | Type | Default Value|
|------|-------------|------|---------|
| arch | architecture  | string | linux-amd64 |
| cnf_path | path to config files | string | /etc |
| tmp_path | temporary path  | string | /tmp |
| bin_path | path to binary  | string | /usr/local/bin |
| script | script gets temporary root password | string | {{ tmp_path }}/script.sh |
| root_password | mysql root password | string | changeme |
| node_exporter_version | prometheus node exporter version | string | 1.3.1 |
| node_exporter_archive | downloaded archive | string | {{ tmp_path }}/node_exporter-{{ node_exporter_version }}.{{ arch }}.tar.gz |
| node_exporter_path_tmp | temporary path | string | {{ tmp_path }}/node_exporter-{{ node_exporter_version }}.{{ arch }} |
| systemd_path | systemd unit file path | string | /etc/systemd/system |
| md5 | md5 check sum string | string | changeme |
| repo_url | mysql repository url | string | https://dev.mysql.com/get/mysql80-community-release-el7-6.noarch.rpm |
| rpm_path | path to repositories directory | string | /tmp/mysql80-community-release-el7-6.noarch.rpm |
| gpg_url | gpg key url | string | https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 |
| log_path | mysql log path | string | /var/log/mysql |
| user | mysql user | string | mysql |
| replica_user | mysql replication user | string | changeme |
| replica_pass | mysql replication user password | string | changeme |
| replica_host | mysql ip address slave host | string | changeme |
| primary_host | mysql ip address master host| string | changeme |
| db_name | database name | string | changeme |
| db_username | database username | string | changeme |
| db_password | database password | string | changeme |
| db_host | remote ip address | string | changeme |
| mysqld_exporter_version | mysqld exporter version | string | 0.14.0 |
| mysqld_exporter_archive | downloaded archive | string |
| mysqld_exporter_path_tmp | temporary path | string |
| mysql_user | mysql user for mysqld exporter | string | changeme |
| mysql_pass | mysql password for mysqld exporter user | string | changeme |


Example Playbook
----------------

An example of using role:

```yaml
- name: MySQL Provisioning
  hosts: mysql
  roles:
    - mysql
```


License
-------

BSD-3-Clause


Author Information
------------------

Borodatko
