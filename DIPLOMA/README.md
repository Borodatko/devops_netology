Дипломное задание по курсу «DevOps-инженер»
===========================================

Регистрация доменного имени
---------------------------

**В роли регистратора был выбран reg.ru, имя домена tst2022.ru:**

[reg.ru личный кабинет](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/domain/reg_ru.png)


Создание инфраструктуры
-----------------------

**В качестве backend выбран terraform cloud, настроен workspace stage:**

```
boroda@K40IJ:~/WORK/yandex-terraform$ cat provider.tf 
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  cloud {
    organization = "netology_learn"
    hostname = "app.terraform.io"
    workspaces {
      name = "stage"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
}
```

**Настроен VPC с подсетями в разных зонах доступности:**

***provider.tf:***

```
boroda@K40IJ:~/WORK/yandex-terraform$ cat network.tf 
resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_route_table" "nat" {
  network_id = "${yandex_vpc_network.net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.1.254"
  }
}

resource "yandex_vpc_subnet" "internal" {
  name = "internal"
  zone = "ru-central1-a"
  network_id = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["10.20.100.0/24"]
  route_table_id = "${yandex_vpc_route_table.nat.id}"
}

resource "yandex_vpc_subnet" "external" {
  name = "external"
  zone = "ru-central1-b"
  network_id = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.1.0/24"]
}
```

***вывод terraform plan:***

```
  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }
  # yandex_vpc_subnet.external will be created
  + resource "yandex_vpc_subnet" "external" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "external"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.internal will be created
  + resource "yandex_vpc_subnet" "internal" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "internal"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.20.100.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }
```

**Выполнение terraform destroy terraform plan и terraform apply:**

***terraform destroy***

```
orlov@it-14-14 centos]$ terraform destroy
Running apply in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://app.terraform.io/app/netology_learn/stage/runs/run-s64jYdUviM25W3Nq

Waiting for the plan to start...

Terraform v1.2.5
on linux_amd64
Initializing plugins and modules...

Changes to Outputs:
  - internal_ip_address_app_yandex_cloud        = "10.20.100.153" -> null
  - internal_ip_address_db01_yandex_cloud       = "10.20.100.151" -> null
  - internal_ip_address_db02_yandex_cloud       = "10.20.100.152" -> null
  - internal_ip_address_gitlab_yandex_cloud     = "10.20.100.154" -> null
  - internal_ip_address_monitoring_yandex_cloud = "10.20.100.156" -> null
  - internal_ip_address_nginx_yandex_cloud      = "10.20.100.150" -> null
  - internal_ip_address_runner_yandex_cloud     = "10.20.100.155" -> null

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Do you really want to destroy all resources in workspace "stage"?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

***terraform plan***

```
[orlov@it-14-14 centos]$ terraform plan
Running plan in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will stop streaming the logs, but will not stop the plan running remotely.

Preparing the remote plan...

To view this run in a browser, visit:
https://app.terraform.io/app/netology_learn/stage/runs/run-LGs6oYYjNtHGsst5

Waiting for the plan to start...

Terraform v1.2.5
on linux_amd64
Initializing plugins and modules...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.app will be created
  + resource "yandex_compute_instance" "app" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "app.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "app"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-app"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.153"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.db01 will be created
  + resource "yandex_compute_instance" "db01" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "db01.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "db01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-db01"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.151"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.db02 will be created
  + resource "yandex_compute_instance" "db02" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "db02.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "db02"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-db02"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.152"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.gitlab will be created
  + resource "yandex_compute_instance" "gitlab" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "gitlab.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "gitlab"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-gitlab"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.154"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.monitoring will be created
  + resource "yandex_compute_instance" "monitoring" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "monitoring.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "monitoring"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-monitoring"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.156"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.nat will be created
  + resource "yandex_compute_instance" "nat" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "nat"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "nat"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8481jglvcs2ogmnfeh"
              + name        = "root-nat"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.1.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.nginx will be created
  + resource "yandex_compute_instance" "nginx" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "nginx"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-nginx"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.150"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.runner will be created
  + resource "yandex_compute_instance" "runner" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "runner.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "runner"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-runner"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.155"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.nat will be created
  + resource "yandex_vpc_route_table" "nat" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = "192.168.1.254"
        }
    }

  # yandex_vpc_subnet.external will be created
  + resource "yandex_vpc_subnet" "external" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "external"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.internal will be created
  + resource "yandex_vpc_subnet" "internal" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "internal"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.20.100.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 12 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nat_yandex_cloud        = (known after apply)
  + external_ip_address_nginx_yandex_cloud      = (known after apply)
  + internal_ip_address_app_yandex_cloud        = "10.20.100.153"
  + internal_ip_address_db01_yandex_cloud       = "10.20.100.151"
  + internal_ip_address_db02_yandex_cloud       = "10.20.100.152"
  + internal_ip_address_gitlab_yandex_cloud     = "10.20.100.154"
  + internal_ip_address_monitoring_yandex_cloud = "10.20.100.156"
  + internal_ip_address_nginx_yandex_cloud      = "10.20.100.150"
  + internal_ip_address_runner_yandex_cloud     = "10.20.100.155"
```

***terraform apply***

```
[orlov@it-14-14 centos]$ terraform apply
Running apply in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://app.terraform.io/app/netology_learn/stage/runs/run-SPpA1rWFXEP1DMyk

Waiting for the plan to start...

Terraform v1.2.5
on linux_amd64
Initializing plugins and modules...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.app will be created
  + resource "yandex_compute_instance" "app" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "app.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "app"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-app"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.153"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.db01 will be created
  + resource "yandex_compute_instance" "db01" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "db01.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "db01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-db01"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.151"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.db02 will be created
  + resource "yandex_compute_instance" "db02" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "db02.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "db02"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-db02"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.152"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.gitlab will be created
  + resource "yandex_compute_instance" "gitlab" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "gitlab.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "gitlab"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-gitlab"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.154"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.monitoring will be created
  + resource "yandex_compute_instance" "monitoring" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "monitoring.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "monitoring"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-monitoring"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.156"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.nat will be created
  + resource "yandex_compute_instance" "nat" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "nat"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "nat"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8481jglvcs2ogmnfeh"
              + name        = "root-nat"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.1.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.nginx will be created
  + resource "yandex_compute_instance" "nginx" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "nginx"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-nginx"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.150"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.runner will be created
  + resource "yandex_compute_instance" "runner" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "runner.tst2022.ru"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD4DDBe/Xx1Uaa1mNTQNlTPyXQnjI1ZUf9HKP8+b79b3Z4dJB2UmPTGKsrRXCeT5adrxI8FBuoOWAL7FHR3JGOnTAuE5a1amUPn/7u2+kp7d6pln6vLI3s+OgmDjiDcmwSjFGAvhMlkdt791jLhmcVsMJUs7b/PyNyRPTeaDDfBmpS117FbCcdB4+8wGMvzNwSh6mzp5AJvRU2mJQe76O32yAsKNrOqu6Hk9sXNq/abswFc53t17i3CtD9azwLfKML+PrwIsMJNFpQQ23YaWZLnXBSBKUWXsSUdrcLUOIFudfhWGQu5DJIQNEZNzy8ZpYDGKGGxuO+KYyWFJxx0UdisUE0qLJsztI6Sg+T21F8qPtugJt6P7XwVBYgj8B4R0hqiMqcO3mYNN/h2gmhRs5zDrHtF8o60KrcKONhnYAKp3RKJ7mAA/64WC+Gte1OxGcFVFMO11QkHjgjAM6KU3xlNBgDHio7TvpgJgfZ6AWhg5KhhP2ahQWhkBzv6g3c6U6c= orlov@it-14-14
            EOT
        }
      + name                      = "runner"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd873jjicm6v42n5j8ae"
              + name        = "root-runner"
              + size        = 15
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.20.100.155"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.nat will be created
  + resource "yandex_vpc_route_table" "nat" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = "192.168.1.254"
        }
    }

  # yandex_vpc_subnet.external will be created
  + resource "yandex_vpc_subnet" "external" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "external"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.internal will be created
  + resource "yandex_vpc_subnet" "internal" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "internal"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.20.100.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 12 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nat_yandex_cloud        = (known after apply)
  + external_ip_address_nginx_yandex_cloud      = (known after apply)
  + internal_ip_address_app_yandex_cloud        = "10.20.100.153"
  + internal_ip_address_db01_yandex_cloud       = "10.20.100.151"
  + internal_ip_address_db02_yandex_cloud       = "10.20.100.152"
  + internal_ip_address_gitlab_yandex_cloud     = "10.20.100.154"
  + internal_ip_address_monitoring_yandex_cloud = "10.20.100.156"
  + internal_ip_address_nginx_yandex_cloud      = "10.20.100.150"
  + internal_ip_address_runner_yandex_cloud     = "10.20.100.155"

Do you want to perform these actions in workspace "stage"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.net: Creation complete after 3s [id=enp78j5p7d9h5enj0b4q]
yandex_vpc_subnet.external: Creating...
yandex_vpc_route_table.nat: Creating...
yandex_vpc_subnet.external: Creation complete after 1s [id=e2lfdf8gped9bdm49aqh]
yandex_compute_instance.nat: Creating...
yandex_vpc_route_table.nat: Creation complete after 2s [id=enpg3m3p64vai8edoh7q]
yandex_vpc_subnet.internal: Creating...
yandex_vpc_subnet.internal: Creation complete after 2s [id=e9bur7i6001seq5ausjt]
yandex_compute_instance.gitlab: Creating...
yandex_compute_instance.db02: Creating...
yandex_compute_instance.runner: Creating...
yandex_compute_instance.app: Creating...
yandex_compute_instance.db01: Creating...
yandex_compute_instance.monitoring: Creating...
yandex_compute_instance.nginx: Creating...
yandex_compute_instance.nat: Still creating... [10s elapsed]
yandex_compute_instance.gitlab: Still creating... [10s elapsed]
yandex_compute_instance.db02: Still creating... [10s elapsed]
yandex_compute_instance.runner: Still creating... [10s elapsed]
yandex_compute_instance.monitoring: Still creating... [10s elapsed]
yandex_compute_instance.nginx: Still creating... [10s elapsed]
yandex_compute_instance.db01: Still creating... [10s elapsed]
yandex_compute_instance.app: Still creating... [10s elapsed]
yandex_compute_instance.nat: Still creating... [20s elapsed]
yandex_compute_instance.gitlab: Still creating... [20s elapsed]
yandex_compute_instance.db02: Still creating... [20s elapsed]
yandex_compute_instance.runner: Still creating... [20s elapsed]
yandex_compute_instance.monitoring: Still creating... [20s elapsed]
yandex_compute_instance.db01: Still creating... [20s elapsed]
yandex_compute_instance.nginx: Still creating... [20s elapsed]
yandex_compute_instance.app: Still creating... [20s elapsed]
yandex_compute_instance.nat: Still creating... [30s elapsed]
yandex_compute_instance.gitlab: Still creating... [30s elapsed]
yandex_compute_instance.app: Still creating... [30s elapsed]
yandex_compute_instance.db01: Still creating... [30s elapsed]
yandex_compute_instance.monitoring: Still creating... [30s elapsed]
yandex_compute_instance.runner: Still creating... [30s elapsed]
yandex_compute_instance.nginx: Still creating... [30s elapsed]
yandex_compute_instance.db02: Still creating... [30s elapsed]
yandex_compute_instance.nat: Still creating... [40s elapsed]
yandex_compute_instance.gitlab: Still creating... [40s elapsed]
yandex_compute_instance.db02: Still creating... [40s elapsed]
yandex_compute_instance.app: Still creating... [40s elapsed]
yandex_compute_instance.runner: Still creating... [40s elapsed]
yandex_compute_instance.db01: Still creating... [40s elapsed]
yandex_compute_instance.monitoring: Still creating... [40s elapsed]
yandex_compute_instance.nginx: Still creating... [40s elapsed]
yandex_compute_instance.db01: Creation complete after 42s [id=fhmvf2rdfpoomi7o27ep]
yandex_compute_instance.app: Creation complete after 42s [id=fhmlinv0iilhnjvn03qu]
yandex_compute_instance.monitoring: Creation complete after 43s [id=fhm1hqthi0rk7nfc7trb]
yandex_compute_instance.nat: Creation complete after 46s [id=epddo4i9cmdfk2nf3n2s]
yandex_compute_instance.runner: Creation complete after 44s [id=fhmskscapt78feff81ou]
yandex_compute_instance.gitlab: Creation complete after 44s [id=fhmmm2j148vatb7at04c]
yandex_compute_instance.db02: Creation complete after 45s [id=fhm12csf19epo40unlij]
yandex_compute_instance.nginx: Creation complete after 47s [id=fhml02e3raisdej771dd]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat_yandex_cloud = "158.160.8.127"
external_ip_address_nginx_yandex_cloud = "84.201.159.80"
internal_ip_address_app_yandex_cloud = "10.20.100.153"
internal_ip_address_db01_yandex_cloud = "10.20.100.151"
internal_ip_address_db02_yandex_cloud = "10.20.100.152"
internal_ip_address_gitlab_yandex_cloud = "10.20.100.154"
internal_ip_address_monitoring_yandex_cloud = "10.20.100.156"
internal_ip_address_nginx_yandex_cloud = "10.20.100.150"
internal_ip_address_runner_yandex_cloud = "10.20.100.155"
[orlov@it-14-14 centos]$ 
```

**Скриншот веб-интерфейса Terraform Cloud:**

[terraform_run](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/terraform/terraform_run.png)

[terraform_plan](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/terraform/terraform_plan.png)

[terraform_apply](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/terraform/terraform_apply.png)


Установка Nginx и LetsEncrypt
-----------------------------

В доменной зоне tst2022.ru настроены A-записи на внешний адрес.

[dns_a_records](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/domain/reg_ru_records.png)

**Конфиги upstream:**

***alertmanager.conf***

```
centos@tst2022 playbook]$ cat /etc/nginx/conf.d/alertmanager.conf 
server {
    server_name alertmanager.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/alertmanager.error.log;
    access_log /var/log/nginx/alertmanager.access.log;

    location / {
        proxy_pass http://alertmanager.upstream;
        proxy_set_header X-Real-IP $proxy_protocol_addr;
        proxy_set_header X-Forwarded-For $proxy_protocol_addr;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = alertmanager.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name alertmanager.tst2022.ru;
    return 404; # managed by Certbot
}
```

***gitlab.conf***

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/gitlab.conf 
server {
    server_name gitlab.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/gitlab.error.log;
    access_log /var/log/nginx/gitlab.access.log;

    location / {
        proxy_set_header Host $http_host;
        proxy_pass http://gitlab.upstream;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = gitlab.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name gitlab.tst2022.ru;
    return 404; # managed by Certbot


}
```

***grafana.conf***

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/grafana.conf 
server {
    server_name grafana.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/grafana.error.log;
    access_log /var/log/nginx/grafana.access.log;

    location / {
        proxy_set_header Host $http_host;
        proxy_pass http://grafana.upstream;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = grafana.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name grafana.tst2022.ru;
    return 404; # managed by Certbot


}
```

***prometheus.conf***

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/prometheus.conf 
server {
    server_name prometheus.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/prometheus.error.log;
    access_log /var/log/nginx/prometheus.access.log;

    location / {
        proxy_pass http://prometheus.upstream;
        proxy_set_header   X-Real-IP $proxy_protocol_addr;
        proxy_set_header   X-Forwarded-For $proxy_protocol_addr;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = prometheus.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name prometheus.tst2022.ru;
    return 404; # managed by Certbot


}
```

***www.conf***

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/www.conf 
server {
    server_name www.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/www.error.log;
    access_log /var/log/nginx/www.access.log;

    location / {
        proxy_pass http://www.upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = www.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name www.tst2022.ru;
    return 404; # managed by Certbot


}
```

***upstream.conf***

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/upstream.conf 
upstream www.upstream {
        server 10.20.100.153:80;
}

upstream gitlab.upstream {
        server 10.20.100.154:80;
}

upstream prometheus.upstream {
        server 10.20.100.156:9090;
}

upstream alertmanager.upstream {
        server 10.20.100.156:9093;
}

upstream grafana.upstream {
        server 10.20.100.156:3000;
}
```

**Скриншоты с 502 ошибкой:**

[Alertmanager](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/proxy/web_alertmanager.png)

[GitLab](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/proxy/web_gitlab.png)

[Grafana](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/proxy/web_grafana.png)

[Prometheus](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/proxy/web_prometheus.png)

[WWW](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/proxy/web_www.png)


Установка кластера MySQL
------------------------

**Проверка работы режима репликации master/slave MySQL кластера.**

Проверка осуществляется на slave ноде кластера:

```
[centos@tst2022 playbook]$ ssh 10.20.100.152
[centos@db02 ~]$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 8.0.30 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: 10.20.100.151
                  Master_User: replman
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 2805
               Relay_Log_File: db02-relay-bin.000002
                Relay_Log_Pos: 2974
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 2805
              Relay_Log_Space: 3183
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: 50c3942e-1eea-11ed-973c-d00d1f78b6d7
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
       Master_public_key_path: 
        Get_master_public_key: 0
            Network_Namespace: 
1 row in set, 1 warning (0,00 sec)

mysql> 
```

В кластере автоматически создаётся база данных c именем wordpress.

**Вывод на slave ноде:**

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| wordpress          |
+--------------------+
5 rows in set (0,00 sec)
```

**Task в ansible, создающая БД:**

```
- name: Wordpress - Create Database wordpress
  community.mysql.mysql_db:
    login_user: root
    login_password: "{{ root_password }}"
    login_host: localhost
    name: "{{ db_name }}"
    state: present
  tags: mysql
```

В кластере автоматически создаётся пользователь wordpress с полными правами на базу wordpress и паролем wordpress.

**Вывод на slave ноде:**

```
mysql> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select host,user from user;
+---------------+------------------+
| host          | user             |
+---------------+------------------+
| 10.20.100.153 | wordpress        |
| 10.20.100.152 | replman          |
| 10.20.100.156 | grafana          |
| localhost     | mysql.infoschema |
| localhost     | mysql.session    |
| localhost     | mysql.sys        |
| localhost     | mysqld_exporter  |
| localhost     | root             |
+---------------+------------------+
8 rows in set (0,00 sec)
```

**Task в ansible, создающая пользователя с правами:**

```
- name: Wordpress - Create User wordpress
  community.mysql.mysql_user:
    login_user: root
    login_password: "{{ root_password }}"
    login_host: localhost
    name: "{{ db_username }}"
    password: "{{ db_password }}"
    host: "{{ db_host }}"
    priv:
      'wordpress.*': 'ALL,GRANT'
    state: present
  tags: mysql
```


Установка WordPress
-------------------

**В роли веб-сервера nginx:**

```
[root@app ~]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-08-18 14:53:50 MSK; 2min 49s ago
     Docs: http://nginx.org/en/docs/
 Main PID: 3119 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3119 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           ├─3120 nginx: worker process
           ├─3121 nginx: worker process
           ├─3122 nginx: worker process
           └─3123 nginx: worker process

Aug 18 14:53:50 app systemd[1]: Starting nginx - high performance web server...
Aug 18 14:53:50 app systemd[1]: Started nginx - high performance web server.
[root@app ~]# nginx -v
nginx version: nginx/1.22.0
```

**В доменной зоне tst2022.ru настроена A-запись на внешний адрес reverse-proxy:**

[dns_a_records](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/domain/reg_ru_records.png)

**Конфиг upstream для www.tst2022.ru:**

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/www.conf 
server {
    server_name www.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/www.error.log;
    access_log /var/log/nginx/www.access.log;

    location / {
        proxy_pass http://www.upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = www.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name www.tst2022.ru;
    return 404; # managed by Certbot


}
```

**По самой URL пока отображается выбор языка с последующей установкой WP. В дальшнейшем, при работе с GitLab, будет выполнена установка Wordpress с изменением темы и добавлением плагина wp-statistics.**

[wordpress_install](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/app/site.png)


Установка Gitlab CE и Gitlab Runner
-----------------------------------

**Интерфейс Gitlab:**

[gitlab_login](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/gitlab/gitlab1.png)

[gitlab_interface](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/gitlab/gitlab2.png)

**В доменной зоне tst2022.ru настроена A-запись на внешний адрес reverse-proxy:**

[dns_a_records](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/domain/reg_ru_records.png)

**Конфиг upstream для gitlab.tst2022.ru:**

```
[centos@tst2022 playbook]$ cat /etc/nginx/conf.d/gitlab.conf 
server {
    server_name gitlab.tst2022.ru;
    server_tokens off;

    error_log  /var/log/nginx/gitlab.error.log;
    access_log /var/log/nginx/gitlab.access.log;

    location / {
        proxy_set_header Host $http_host;
        proxy_pass http://gitlab.upstream;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.tst2022.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tst2022.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = gitlab.tst2022.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name gitlab.tst2022.ru;
    return 404; # managed by Certbot


}
```

**При любом коммите в репозиторий с WordPress и создании тега (например, v1.0.0) происходит деплой на виртуальную машину.**

В ansible роли есть следующая task:

- name: GitLab CE - Create GitLab Project Wordpress
  community.general.gitlab_project:
    api_url: "{{ gitlab_api_url }}"
    api_token: "{{ gitlab_api_token_user }}"
    name: "{{ gitlab_project_name }}"
    import_url: "{{ github_url }}"
  vars:
    ansible_python_interpreter: /usr/bin/python3.6
  tags: gitlab

Она создает проект и импортирует внешний репозиторий. Далее, через интерфейс гитлаба я отредактировал в репозитории переменные и создал тэг, после чего запустился деплой с:
 - Установкой wordpress;
 - Скачиванием и установкой плагина wp-statistics для дальнейшего мониторинга;
 - Скачиванием и установкой темы astra.

Скриншот работы pipeline:

[pipeline](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/gitlab/gitlab_pipeline.png)

Скриншот тэга:

[tag](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/gitlab/gitlab_tag.png)

**URL Wordpress после установки и настройки:**

[app](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/app/site_done.png)


Установка Prometheus, Alert Manager, Node Exporter и Grafana
------------------------------------------------------------

**Интерфейсы Prometheus, Alert Manager и Grafana доступены по https:**

[alertmanager](https://github.com/Borodatko/devops_netology/blob/master/DIPLOMA/attach/proxy/web_alertmanager_done.png)

[grafana](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana.png)

[prometheus](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/proxy/web_prometheus_done.png)

**В доменной зоне tst2022.ru настроена A-запись на внешний адрес reverse-proxy:**

[dns_a_records](https://github.com/Borodatko/devops_netology/blob/c09ee8d259b6c01cd99a69efaeefefde74886171/DIPLOMA/attach/domain/reg_ru_records.png)

**Конфиги upstream:**



**На всех серверах установлен Node Exporter и его метрики доступны Prometheus:**

```
[centos@monitoring ~]$ cat /etc/prometheus/prometheus.yml 
global:
  scrape_interval: 10s

rule_files:
  - rules.yml

alerting:
  alertmanagers:
    - static_configs:
      - targets:
        # Alertmanager's default port is 9093
        - localhost:9093

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'monitoring'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'nginx'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.150:9100']

  - job_name: 'db1'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.151:9100']

  - job_name: 'db2'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.152:9100']

  - job_name: 'app'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.153:9100']

  - job_name: 'gitlab'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.154:9101']

  - job_name: 'runner'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.155:9101']

  - job_name: 'database'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.20.100.151:9104']
```

**У Alert Manager есть необходимый набор правил для создания алертов:**

```
[centos@monitoring ~]$ cat /etc/prometheus/rules.yml 
groups:
- name: Instances
  rules:
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      severity: critical
    # Prometheus templates apply here in the annotation and label fields of the alert.
    annotations:
      description: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
      summary: 'Instance {{ $labels.instance }} down'
  - alert: PrometheusJobMissing
    expr: absent(up{job="prometheus"})
    for: 0m
    labels:
      severity: warning
    annotations:
      summary: Prometheus job missing (instance {{ $labels.instance }})
      description: "A Prometheus job has disappeared\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
```

**В Grafana есть дашборд отображающий метрики из Node Exporter по всем серверам:**

[nginx_proxy](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_nginx_proxy.png)

[db01](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_db01.png)

[db02](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_db02.png)

[app](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_app.png)

[gitlab](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_gitlab.png)

[runner](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_runner.png)

[monitoring](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_node_exporter_monitoring.png)

**В Grafana есть дашборд отображающий метрики из MySQL:**

[mysql](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_mysql_dashboard.png)

**В Grafana есть дашборд отображающий метрики из WordPress:**

[wordpress](https://github.com/Borodatko/devops_netology/blob/718919c455389bc207de7836fb3290808a11a706/DIPLOMA/attach/grafana/grafana_wordpress_dashboard.png)
