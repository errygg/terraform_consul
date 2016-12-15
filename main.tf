provider "docker" {
  host = "${var.docker_host}"
}

data "docker_registry_image" "consul" {
  name = "${var.docker_image}"
}

resource "docker_image" "consul" {
  name = "${data.docker_registry_image.consul.name}"
  pull_trigger = "${data.docker_registry_image.consul.sha256_digest}"
  keep_locally = true
}

resource "docker_container" "consul_client_1" {
  image = "${data.docker_registry_image.consul.name}"
  name = "consul_client_1"
  ports {
    internal = 22
    external = 2222
  }

  ports {
    internal = 8500
    external = 8500
  }
  ports {
    internal = 53
    external = 53
  }
  ports {
    internal = 8300
    external = 8300
  }
  ports {
    internal = 8301
    external = 8301
  }
  ports {
    internal = 8600
    external = 8600
  }
  ports {
    internal = 8400
    external = 8400
  }
  network_mode = "bridge"
  env = ["CONSUL_LOCAL_CONFIG={\"skip_leave_on_interrupt\": true}", "CONSUL_ALLOW_PRIVILEGED_PORTS="]
  command = ["agent", "-server", "-ui", "-bind=127.0.0.1", "-dns-port=53"]
  must_run = true
}

#resource "docker_container" "consul_client_2" {
#  image = "${data.docker_registry_image.consul.name}"
#  name = "consul_client_2"
#  ports {
#    internal = 22
#    external = 2223
#  }
#}
