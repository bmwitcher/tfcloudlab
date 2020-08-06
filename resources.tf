resource "aws_iam_user" "newemployees" {
  count = length(var.iam_names)
  name          = element(var.iam_names,count.index)
  path          = "/system/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "example" {
  user   = element(var.iam_names,count.index)
  pgp_key = "keybase:some_person_that_exists"
  password_reset_required = true
}


resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

resource "aws_iam_user_policy" "newemployees_policy" {
  user   = element(var.iam_names,count.index)
  name = "testpolicy"


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
