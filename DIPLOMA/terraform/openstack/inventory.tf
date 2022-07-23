resource "local_file" "inventory" {
  content = <<-DOC
    
    [netology]
    nginx ansible_host=${openstack_compute_instance_v2.nginx.network.0.fixed_ip_v4}
    db1 ansible_host=${openstack_compute_instance_v2.db1.network.0.fixed_ip_v4}
    db2 ansible_host=${openstack_compute_instance_v2.db2.network.0.fixed_ip_v4}
    app ansible_host=${openstack_compute_instance_v2.wordpress.network.0.fixed_ip_v4}
    gitlab ansible_host=${openstack_compute_instance_v2.gitlab.network.0.fixed_ip_v4}
    runner ansible_host=${openstack_compute_instance_v2.runner.network.0.fixed_ip_v4}
    monitoring ansible_host=${openstack_compute_instance_v2.monitoring.network.0.fixed_ip_v4}


    DOC
  filename = "src/ansible/inventory"

  depends_on = [
    openstack_compute_instance_v2.nginx,
    openstack_compute_instance_v2.db1,
    openstack_compute_instance_v2.db2,
    openstack_compute_instance_v2.wordpress,
    openstack_compute_instance_v2.gitlab,
    openstack_compute_instance_v2.runner,
    openstack_compute_instance_v2.monitoring
  ]
}
