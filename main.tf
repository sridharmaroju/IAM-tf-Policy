locals {
 name_prefix = "sridhar-iam-tf-profile2"
}


resource "aws_iam_role" "role_example" {
 name = "${local.name_prefix}-role-example"


 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Sid    = ""
       Principal = {
         Service = "ec2.amazonaws.com"
       }
     },
   ]
 })
}


data "aws_iam_policy_document" "policy_example" {
 statement {
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }
 statement {
   effect    = "Allow"
   actions   = ["s3:ListBucket"]
   resources = ["*"]
 }
 statement {
   effect    = "Allow"
   actions   = ["s3:ListAllMyBuckets","s3:CreateBucket"]
   resources = ["*"]
}
}

resource "aws_iam_policy" "policy_example" {
 name = "${local.name_prefix}-policy-example"


 ## Option 1: Attach data block policy document
## policy = data.aws_iam_policy_document.policy_example.json

 ## Option 2: Inline using jsonencode
# policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action   = ["ec2:Describe*"]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action   = ["s3:ListBucket","s3:ListAllMyBuckets","s3:CreateBucket"]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#    ]
# })
 ## Option 3: Inline using heredoc
 policy = <<POLICY
   {
       "Statement": [
           {
               "Action": "ec2:Describe*",
               "Effect": "Allow",
               "Resource": "*"
           },
           {
               "Action": "s3:ListBucket",
               "Effect": "Allow",
               "Resource": "*"
           }
       ],
       "Version": "2012-10-17"
   }
   POLICY


}




resource "aws_iam_role_policy_attachment" "attach_example" {
 role       = aws_iam_role.role_example.name
 policy_arn = aws_iam_policy.policy_example.arn
}


resource "aws_iam_instance_profile" "profile_example" {
 name = "${local.name_prefix}-profile-example"
 role = aws_iam_role.role_example.name
}

