resource "random_string" "db_instance_suffix" {
  length  = 4
  special = false
  upper   = false
}


resource "google_sql_database_instance" "cloudsql" {

  # Instance info
  name             = "${var.db_instance}${random_string.db_instance_suffix.result}"
  region           = var.region
  database_version = var.db_version
  deletion_protection = var.deletion_protection

  settings {

    # Region and zonal availability
    availability_type = var.db_availability_type
    location_preference {
      zone = var.db_location_preference
    }

    # Machine Type
    tier = var.db_machine_type

    # Storage
    disk_size = var.db_default_disk_size

    # Connections
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    # Backups
    backup_configuration {
      enabled            = true
      start_time         = "06:00"
    }
    
    database_flags {
      name  = "max_connections"
      value = var.max_connections
    }
  }
  depends_on = [
    google_service_networking_connection.private-vpc-connection
  ]
}

resource "google_sql_database" "database" {
  for_each = toset(var.db_list)
  name     = each.value
  instance = google_sql_database_instance.cloudsql.name
  
  depends_on = [
    google_sql_database_instance.cloudsql
  ]
}

# resource "google_sql_user" "user" {
#   for_each = toset(var.db_list)
#   name     = var.db_user
#   instance = each.value
#   password = var.db_password
  
# }



#Private Connection Configuration
#We need to configure private services access to allocate an IP address range 
#and create a private service connection. This will allow resources in the Web subnet 
#to connect to the Cloud SQL instance

resource "google_compute_global_address" "private-ip-peering" {
  name          = "${var.vpc_network}-global-address-vpc-peering"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.network_id #TODO: this is the network where the gke cluster will be paired
}

resource "google_service_networking_connection" "private-vpc-connection" {
  network = var.network_id #TODO: this is the network where the gke cluster is deployed
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private-ip-peering.name
  ]
}


