resource "aws_s3_bucket" "www-ror-org-s3" {
  bucket = "www.ror.org"
  region = "eu-west-1"

  website {
    redirect_all_requests_to = "${aws_s3_bucket.ror-org-s3.website_endpoint}"
  }

  tags {
    site        = "ror"
    environment = "production"
  }
}
