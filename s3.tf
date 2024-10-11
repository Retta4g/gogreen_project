# Variable for bucket name prefix
variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name"
  default     = "fusion-gogreen1234858"
}

# Generate a random suffix for the S3 bucket name
resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create an S3 bucket with a dynamically generated name
resource "aws_s3_bucket" "gogreen1020_bucket" {
  bucket = "${var.bucket_name_prefix}-${random_string.bucket_suffix.result}"
}

# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "bucket_config" {
  bucket = aws_s3_bucket.gogreen1020_bucket.id

  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      date = "2025-02-13T00:00:00Z"
    }

    status = "Enabled"
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_gogreen" {
  bucket = aws_s3_bucket.gogreen1020_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
