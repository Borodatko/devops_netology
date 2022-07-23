resource "openstack_blockstorage_volume_v2" "runner" {
  name = "runner"
  size = "30"
  image_id = "${var.image_id}"
}

resource "openstack_compute_instance_v2" "runner" {
  name = "runner"
  image_name = "MyCentOS7"
  image_id = "${var.image_id}"
  flavor_name = "${var.flavor_medium}"
  security_groups = ["gitlab"]
  availability_zone = "${var.runner_zone}"

  network {
    name = "${var.provider_network}"
    fixed_ip_v4 = "${var.runner_ipv4}"
  }

  block_device {
    uuid = "${openstack_blockstorage_volume_v2.runner.id}"
    boot_index = 0
    source_type = "volume"
    destination_type = "volume"
    delete_on_termination = "true"
  }

  connection {
    type = "ssh"
    user = "root"
    password = "${var.pass}"
    host = "${openstack_compute_instance_v2.runner.network.0.fixed_ip_v4}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /root/.ssh",
      "chmod 700 /root/.ssh",
      "echo '${var.root_key_pub}' > /root/.ssh/authorized_keys",
      "chmod 600 /root/.ssh/authorized_keys",
      "useradd -m -p saC4TkM5d8Dd2 netology",
      "mkdir /home/netology/.ssh",
      "chmod 700 /home/netology/.ssh",
      "echo '${var.netology_key_pub}' > /home/netology/.ssh/authorized_keys",
      "chmod 600 /home/netology/.ssh/authorized_keys",
      "chown -R netology:netology /home/netology/.ssh",
      "usermod -aG wheel netology"
    ]
  }
}
