Role Name
=========

Ansible role for Nginx installation & configuration.


Role Variables
--------------

| Name | Description | Type | Default Value|
|------|-------------|------|---------|
| repo_path | path to repositories directory | string | /etc/yum.repos.d |
| conf_path | path to nginx configs | string | /etc/nginx/conf.d |
| wildcard_domain | let's encrypt wildcard cert name | string | changeme |
| email | admin email for let's encrypt notifications| string | changeme |
| dh_path | path to dhparam | string | /etc/ssl/certs |
| arch | architecture  | string | linux-amd64 |
| bin_path | path to binary  | string | /usr/local/bin |
| tmp_path | temporary path  | string | /tmp |
| node_exporter_version | prometheus node exporter version | string | 1.3.1 |
| node_exporter_archive | downloaded archive | string | {{ tmp_path }}/node_exporter-{{ node_exporter_version }}.{{ arch }}.tar.gz |
| node_exporter_path_tmp | temporary path | string | {{ tmp_path }}/node_exporter-{{ node_exporter_version }}.{{ arch }} |
| systemd_path | systemd unit file path | string | /etc/systemd/system |


Example Playbook
----------------

```yaml
- name: Nginx Provisioning
  hosts: nginx
  roles:
    - nginx
```


License
-------

BSD-3-Clause


Author Information
------------------

Borodatko
