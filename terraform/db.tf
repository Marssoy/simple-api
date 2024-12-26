resource "aws_db_instance" "kxc-postgres" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "postgres"
    engine_version = "16"
    identifier = "postgres"
    instance_class = "db.t3.micro"
    db_name = "postgres"
    username = "kxcadmin"
    password = "adminpassword"
    port = 5432
    backup_retention_period = 0
    skip_final_snapshot = true
    publicly_accessible = false
    db_subnet_group_name = aws_db_subnet_group.db_group_private.name
    vpc_security_group_ids = [aws_security_group.kxc-db-sg.id]
    tags = {
        Name = "kxc-postgres"
    }
}

output "db_endpoint" {
  value = aws_db_instance.kxc-postgres.endpoint
}
