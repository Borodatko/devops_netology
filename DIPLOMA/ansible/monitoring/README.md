Role Name
=========

Ansible role for Prometheus, Alert Manager, Grafana installation & configuration.


Role Variables
--------------

| Name | Description | Type | Default Value|
|------|-------------|------|---------|
| arch | architecture  | string | linux-amd64 |
| bin_path | path to binary  | string | /usr/local/bin |
| tmp_path | temporary path  | string | /tmp |
| prometheus_version | prometheus version | string | 2.37.0-rc.0 |
| prometheus_archive | prometheus downloaded archive | string | {{ tmp_path }}/prometheus-{{ prometheus_version }}.{{ arch }}.tar.gz |
| prometheus_path_tmp | prometheus temporary path | string | {{ tmp_path }}/prometheus-{{ prometheus_version }}.{{ arch }} |
| prometheus_path_conf | prometheus config file path | string | /etc/prometheus |
| prometheus_path_db | prometheus database path | string | /var/lib/prometheus |
| alertmanager_version | alertmanager version | string | 0.24.0 |
| alertmanager_archive | alertmanager downloaded archive | string | {{ tmp_path }}/alertmanager-{{ alertmanager_version }}.{{ arch }}.tar.gz |
| alertmanager_path_tmp | alertmanager temporary path | string | {{ tmp_path }}/alertmanager-{{ alertmanager_version }}.{{ arch }} |
| alertmanager_path_conf | alertmanager config file path | string | /etc/alertmanager |
| node_exporter_version | prometheus node exporter version | string | 1.3.1 |
| node_exporter_archive | downloaded archive | string | {{ tmp_path }}/node_exporter-{{ node_exporter_version }}.{{ arch }}.tar.gz |
| node_exporter_path_tmp | temporary path | string | {{ tmp_path }}/node_exporter-{{ node_exporter_version }}.{{ arch }} |
| systemd_path | systemd unit file path | string | /etc/systemd/system |
| repo_path | path to repositories directory | string | /etc/yum.repos.d |
| grafuser | grafana user | string | admin |
| grafpassword | grafana password | string | admin |
| host_nginx | server ip address (nginx) | string | changeme |
| host_db1 | server ip address (mysql_master) | string | changeme |
| host_db2 | server ip address (mysql_slave) | string | changeme |
| host_app | server ip address (wordpress) | string | changeme |
| host_gitlab | server ip address (gitlab-ce) | string | changeme |
| host_runner | server ip address (gitlab-runner) | string | changeme |
| host_database | server ip address (mysql_master) | string | changeme |
| email_recepient | recepient's address | string | changeme |
| email_sender | sender's address | string | changeme |
| email_smtp_server | smtp server address | string | changeme |
| email_auth_username | smtp auth username | string | changeme |
| email_auth_identity | smtp auth identity | string | changeme |
| email_auth_password | smtp auth password | string | changeme |


Example Playbook
----------------

```yaml
- name: Monitoring Provisioning
  hosts: monitoring
  roles:
    - monitoring
```

License
-------

BSD-3-Clause


Author Information
------------------

Borodatko
