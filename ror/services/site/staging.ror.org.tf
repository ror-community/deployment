resource "aws_s3_bucket" "staging-ror-org-s3" {
  # Unique name of the bucket in all of AWS
  bucket = "staging.ror.org"

  # You want the files to be readable by anyone, since it's a website :)
  acl = "public-read"

  # A valid AWS region
  region = "eu-west-1"

  # We'll talk about this file in a moment
  policy = "${file("staging.ror.org.s3.policy.json")}"

  # This tells AWS you want this S3 bucket to serve up a website
  website {
    # This tells AWS to use the file index.html if someone requests 
    # a directory like http://www.«your site».com/about/
    index_document = "index.html"
  }

  # This is the name of the S3 bucket where access logs will be
  # written.  We'll create this bucket in a moment
  # logging {
  #   target_bucket = "${aws_s3_bucket.logs-ror-org-s3.id}"
  #   target_prefix = "root/"
  # }

  # You can omit this if you like—tags can be helpful for managing
  # lots of stuff in AWS if you have to poke around the console
  tags {
    site        = "ror"
    environment = "staging"
  }
}
