resource "google_compute_instance_template" "vm_instance_template" {
  name         = "terraform-instance-template"
  machine_type = "e2-micro"

  disk {
    source_image = "debian-cloud/debian-11"
  }

  metadata_startup_script =  file("./apache2.sh")

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_instance_group_manager" "vm_instance_manager" {
  name = "terraform-instance-manager"
  base_instance_name = "app"

  version {
    instance_template  = google_compute_instance_template.vm_instance_template.id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 60
  }

  target_size = 2
}