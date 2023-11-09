resource "google_compute_global_address" "aa-staticcontent-global-compute-address" {
  name = "aa-staticcontent-global-compute-address"
}


resource "google_storage_bucket" "aa-staticcontent-gcs" {
  name          = "aa-staticcontent-gcs"
  location      = "us"
  force_destroy = "false"
  project       = var.project
  storage_class = "STANDARD"
}

resource "google_storage_bucket_iam_member" "aa-staticcontent-legacyObjectReader" {
  bucket = google_storage_bucket.aa-staticcontent-gcs.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}

resource "google_compute_backend_bucket" "aa-staticcontent-backend-bucket" {
  name        = "aa-staticcontent-gcs"
  bucket_name = "aa-staticcontent-gcs"
  enable_cdn  = false
}



resource "google_compute_url_map" "aa-staticcontent-url-map" {
  name = "aa-staticcontent-http-lb"

  default_service = google_compute_backend_bucket.aa-staticcontent-backend-bucket.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.aa-staticcontent-backend-bucket.self_link
  }
}


resource "google_compute_target_http_proxy" "aa-staticcontent-http-proxy" {
  name    = "aa-staticcontent-http-proxy"
  url_map = google_compute_url_map.aa-staticcontent-url-map.self_link
}

resource "google_compute_global_forwarding_rule" "aa-staticcontent-prod-forwarding-rule" {
  name        = "aa-staticcontent-prod-forwarding-rule"
  ip_address  = google_compute_global_address.aa-staticcontent-global-compute-address.address
  target      = google_compute_target_http_proxy.aa-staticcontent-http-proxy.self_link
  ip_protocol = "TCP"
  port_range  = "80"
}
