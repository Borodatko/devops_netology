terraform {
  required_providers {
    openstack = {
      source = "path/to/local/provider/openstack"
      version = "version"
    }
    local = {
      source = "path/to/local/provider/local"
      version = "version"
    }
    null = {
      source = "path/to/local/provider/null"
      version = "version"
    }
  }
}


provider "openstack" {
  user_name = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password = "${var.password}"
  auth_url = "${var.auth_url}"
  region = "RegionOne"
}
