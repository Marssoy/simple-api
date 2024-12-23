resource "aws_iam_role" "ecs-task-execution-role" {
    name = "ecs-task-execution-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = [
                        "ecs.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "ecs-task-policy" {
    name = "ecs-task-policy"
    path = "/"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage"
                ]
                Resource = "*"
            },
            {
                Effect = "Allow"
                Action = [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:CreateLogGroup"
                ]
                Resource = "*"
            },
            {
                Effect = "Allow"
                Action = [
                    "ssm:GetParameters",
                    "kms:Decrypt"
                ]
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs-task-policy-attachment" {
    role = aws_iam_role.ecs-task-execution-role.name
    policy_arn = aws_iam_policy.ecs-task-policy.arn
}