resource "google_service_account" "aa-gcr-sa" {
  account_id   = "aa-gcr-sa"
  display_name = "service account"
}

resource "google_service_account_key" "aa-gcr-sa-key" {
  service_account_id = google_service_account.aa-gcr-sa.name
}

resource "local_file" "aa-gcr-sa-json" {
  content  = base64decode(google_service_account_key.aa-gcr-sa-key.private_key)
  filename = "aa-gcr-sa-key.json"
}

resource "google_project_iam_member" "aa-gcr-sa-binding" {
  project = "sep-poc-aa-hackathon-prj"
  role    = "roles/artifactregistry.createOnPushRepoAdmin"
  member  = "serviceAccount:${google_service_account.aa-gcr-sa.email}"
}

resource "google_project_iam_member" "aa-gcr-sa-binding-admin" {
  project = "sep-poc-aa-hackathon-prj"
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.aa-gcr-sa.email}"
}

resource "google_project_iam_member" "aa-gcr-sa-binding-reader" {
  project = "sep-poc-aa-hackathon-prj"
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.aa-gcr-sa.email}"
}
resource "google_project_iam_member" "aa-gcr-sa-binding-objectViewer" {
  project = "sep-poc-aa-hackathon-prj"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.aa-gcr-sa.email}"
}



resource "google_project_iam_member" "aa-gcr-sa-binding-storage-admin" {
  project = "sep-poc-aa-hackathon-prj"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.aa-gcr-sa.email}"
}
