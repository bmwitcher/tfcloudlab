resource "aws_iam_user" "newemployees" {
count = length(var.iam_names)
name          = element(var.iam_names,count.index)
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "newemp" {
  count = length(var.iam_names)
  user = element(var.iam_names,count.index)
}


/*
resource "aws_iam_user_login_profile" "example" {
  count = length(var.iam_names)
  user   = element(var.iam_names,count.index)
  pgp_key = "keybase:some_person_that-exists" #receiving an error attached to this attribute (Error: error retrieving GPG Key during IAM User Login Profile)
  password_reset_required = true
}
*/

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}


resource "aws_iam_user_policy" "newemp_policy" {
  count = length(var.iam_names)
  name = "new"
  user = element(var.iam_names,count.index)

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
