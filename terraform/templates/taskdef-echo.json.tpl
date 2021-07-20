[
  {
    "name": "${name}",
    "image": "${image}",
    "command": [],
    "cpu": 0,
    "portMappings": [
      {
        "containerPort": 6001,
        "hostPort": 6001,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "environment": [
      {
        "name": "LARAVEL_ECHO_SERVER_AUTH_HOST",
        "value": "${laravel_echo_server_auth_host}"
      },
%{ if laravel_echo_server_host != ""}
      {
        "name": "LARAVEL_ECHO_SERVER_HOST",
        "value": "${laravel_echo_server_host}"
      },
%{ endif }
      {
        "name": "LARAVEL_ECHO_SERVER_PORT",
        "value": "${laravel_echo_server_port}"
      },
      {
        "name": "LARAVEL_ECHO_SERVER_PROTO",
        "value": "${laravel_echo_server_proto}"
      },
      {
        "name": "LARAVEL_ECHO_SERVER_REDIS_HOST",
        "value": "${laravel_echo_server_redis_host}"
      },
      {
        "name": "LARAVEL_ECHO_SERVER_REDIS_PORT",
        "value": "${laravel_echo_server_redis_port}"
      },
%{ if laravel_echo_server_redis_password != ""}
      {
        "name": "LARAVEL_ECHO_SERVER_REDIS_PASSWORD",
        "value": "${laravel_echo_server_redis_password}"
      },
%{ endif }
%{ if laravel_echo_server_ssl_cert != ""}
      {
        "name": "LARAVEL_ECHO_SERVER_SSL_CERT",
        "value": "${laravel_echo_server_ssl_cert}"
      },
%{ endif }
%{ if laravel_echo_server_ssl_chain != ""}
      {
        "name": "LARAVEL_ECHO_SERVER_SSL_CHAIN",
        "value": "${laravel_echo_server_ssl_chain}"
      },
%{ endif }
%{ if laravel_echo_server_ssl_key != ""}
      {
        "name": "LARAVEL_ECHO_SERVER_SSL_KEY",
        "value": "${laravel_echo_server_ssl_key}"
      },
%{ endif }
%{ if laravel_echo_server_ssl_pass != ""}
      {
        "name": "LARAVEL_ECHO_SERVER_SSL_PASS",
        "value": "${laravel_echo_server_ssl_pass}"
      },
%{ endif }
      {
        "name": "LARAVEL_ECHO_SERVER_DEBUG",
        "value": "${laravel_echo_server_debug}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${awslogs_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "linuxParameters": {
      "initProcessEnabled": true
    }
  }
]
