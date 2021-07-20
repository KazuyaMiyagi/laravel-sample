locals {
  vpc_endpoint_service_names = {
    # ECS/EC2 type endpoints
    ecs_agent     = "com.amazonaws.${data.aws_region.current.name}.ecs-agent"
    ecs_telemetry = "com.amazonaws.${data.aws_region.current.name}.ecs-telemetry"
    ecs           = "com.amazonaws.${data.aws_region.current.name}.ecs"

    # ECS/FARGATE type endpoints
    ecr_dkr = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
    ecr_api = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
    s3      = "com.amazonaws.${data.aws_region.current.name}.s3"
    logs    = "com.amazonaws.${data.aws_region.current.name}.logs"

    # other endpoints
    ssmmessages    = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
    secretsmanager = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
    kms            = "com.amazonaws.${data.aws_region.current.name}.kms"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name = local.vpc_endpoint_service_names.ecr_dkr
  vpc_id       = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  service_name = local.vpc_endpoint_service_names.ecr_api
  vpc_id       = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  service_name    = local.vpc_endpoint_service_names.s3
  vpc_id          = aws_vpc.main.id
  route_table_ids = [aws_route_table.public.id]
}

resource "aws_vpc_endpoint" "logs" {
  service_name = local.vpc_endpoint_service_names.logs
  vpc_id       = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  service_name = local.vpc_endpoint_service_names.ssmmessages
  vpc_id       = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "secretsmanager" {
  service_name = local.vpc_endpoint_service_names.secretsmanager
  vpc_id       = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id,
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}
