output "nginx" {
  value = "${openstack_compute_instance_v2.nginx.network.0.fixed_ip_v4}"
}

output "db1" {
  value = "${openstack_compute_instance_v2.db1.network.0.fixed_ip_v4}"
}

output "db2" {
  value = "${openstack_compute_instance_v2.db2.network.0.fixed_ip_v4}"
}

output "wordpress" {
  value = "${openstack_compute_instance_v2.wordpress.network.0.fixed_ip_v4}"
}

output "gitlab" {
  value = "${openstack_compute_instance_v2.gitlab.network.0.fixed_ip_v4}"
}

output "runner" {
  value = "${openstack_compute_instance_v2.runner.network.0.fixed_ip_v4}"
}

output "monitoring" {
  value = "${openstack_compute_instance_v2.monitoring.network.0.fixed_ip_v4}"
}

