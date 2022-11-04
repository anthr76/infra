resource "b2_bucket" "kopia" {
  bucket_name = "k8s-kopia"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "kopia" {
  key_name  = "k8s-kopia"
  bucket_id = b2_bucket.kopia.id
  capabilities = [
    "deleteFiles",
    "listAllBucketNames",
    "listBuckets",
    "listFiles",
    "readBuckets",
    "readFiles",
    "shareFiles",
    "writeFiles"
  ]
}

resource "google_secret_manager_secret" "b2_kopia_bucket_key" {
  secret_id = "B2_KOPIA_BUCKET_KEY"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "b2_kopia_bucket_key" {
  secret = google_secret_manager_secret.b2_kopia_bucket_key.id

  secret_data = b2_application_key.kopia.application_key
}

resource "google_secret_manager_secret" "b2_kopia_bucket_key_id" {
  secret_id = "B2_KOPIA_BUCKET_KEY_ID"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "b2_kopia_bucket_key_id" {
  secret = google_secret_manager_secret.b2_kopia_bucket_key_id.id

  secret_data = b2_application_key.kopia.application_key_id
}
