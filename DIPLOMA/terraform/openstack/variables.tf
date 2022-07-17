# Openstack variables
variable "user_name" {
  default = "changeme"
}

variable "tenant_name" {
  default = "changeme"
}

variable "password" {
  default = "changeme"
}

variable "auth_url" {
  default = "http://ip_address:5000/v3"
}


# Instances variables

variable "image_id" { 
  default = "image_id_here"
}

variable "flavor_small" {
  default = "m1.small"
}

variable "flavor_medium" {
  default = "m1.medium"
}

variable "provider_network" {
  default = "network"
}

# nginx
variable "nginx_zone" {
  default = "nova::nodename"
}

variable "nginx_ipv4" {
  default = "ip_here"
}

# db1
variable "db1_zone" {
  default = "nova::nodename"
}

variable "db1_ipv4" {
  default = "ip_here"
}

# db2
variable "db2_zone" {
  default = "nova::nodename"
}

variable "db2_ipv4" {
  default = "ip_here"
}

# wordpress
variable "wordpress_zone" {
  default = "nova::nodename"
}

variable "wordpress_ipv4" {
  default = "ip_here"
}

# gitlab
variable "gitlab_zone" {
  default = "nova::nodename"
}

variable "gitlab_ipv4" {
  default = "ip_here"
}

# runner
variable "runner_zone" {
  default = "nova::nodename"
}

variable "runner_ipv4" {
  default = "ip_here"
}

# monitoring
variable "monitoring_zone" {
  default = "nova::nodename"
}

variable "monitoring_ipv4" {
  default = "ip_here"
}

# SSH pass
variable "pass" {
  default = "changeme"
}

# Keys
variable "root_key_pub" {
  default = "ssh-rsa here"
}

variable "netology_key_pub" {
  default = "ssh-rsa here"
}
