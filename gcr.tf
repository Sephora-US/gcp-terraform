resource "google_artifact_registry_repository" "aa-gcr" {
  repository_id = "aa-gcr"
  description   = "aa-hackathon docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}
