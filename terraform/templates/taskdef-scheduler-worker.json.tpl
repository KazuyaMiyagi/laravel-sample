[
  {
    "name": "${name}",
    "image": "${image}",
    "command": [
      "${command}"
    ],
    "cpu": 0,
    "portMappings": [],
    "essential": true,
    "secrets": [
      {
        "valueFrom": "${secrets_arn}:APP_DEBUG::",
        "name": "APP_DEBUG"
      },
      {
        "valueFrom": "${secrets_arn}:APP_ENV::",
        "name": "APP_ENV"
      },
      {
        "valueFrom": "${secrets_arn}:APP_KEY::",
        "name": "APP_KEY"
      },
      {
        "valueFrom": "${secrets_arn}:APP_NAME::",
        "name": "APP_NAME"
      },
      {
        "valueFrom": "${secrets_arn}:APP_URL::",
        "name": "APP_URL"
      },
      {
        "valueFrom": "${secrets_arn}:AWS_ACCESS_KEY_ID::",
        "name": "AWS_ACCESS_KEY_ID"
      },
      {
        "valueFrom": "${secrets_arn}:AWS_BUCKET::",
        "name": "AWS_BUCKET"
      },
      {
        "valueFrom": "${secrets_arn}:AWS_DEFAULT_REGION::",
        "name": "AWS_DEFAULT_REGION"
      },
      {
        "valueFrom": "${secrets_arn}:AWS_SECRET_ACCESS_KEY::",
        "name": "AWS_SECRET_ACCESS_KEY"
      },
      {
        "valueFrom": "${secrets_arn}:BROADCAST_DRIVER::",
        "name": "BROADCAST_DRIVER"
      },
      {
        "valueFrom": "${secrets_arn}:CACHE_DRIVER::",
        "name": "CACHE_DRIVER"
      },
      {
        "valueFrom": "${secrets_arn}:DB_CONNECTION::",
        "name": "DB_CONNECTION"
      },
      {
        "valueFrom": "${secrets_arn}:DB_DATABASE::",
        "name": "DB_DATABASE"
      },
      {
        "valueFrom": "${secrets_arn}:DB_HOST::",
        "name": "DB_HOST"
      },
      {
        "valueFrom": "${secrets_arn}:DB_PASSWORD::",
        "name": "DB_PASSWORD"
      },
      {
        "valueFrom": "${secrets_arn}:DB_PORT::",
        "name": "DB_PORT"
      },
      {
        "valueFrom": "${secrets_arn}:DB_USERNAME::",
        "name": "DB_USERNAME"
      },
      {
        "valueFrom": "${secrets_arn}:LOG_CHANNEL::",
        "name": "LOG_CHANNEL"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_DRIVER::",
        "name": "MAIL_DRIVER"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_ENCRYPTION::",
        "name": "MAIL_ENCRYPTION"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_FROM_ADDRESS::",
        "name": "MAIL_FROM_ADDRESS"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_FROM_NAME::",
        "name": "MAIL_FROM_NAME"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_HOST::",
        "name": "MAIL_HOST"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_PASSWORD::",
        "name": "MAIL_PASSWORD"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_PORT::",
        "name": "MAIL_PORT"
      },
      {
        "valueFrom": "${secrets_arn}:MAIL_USERNAME::",
        "name": "MAIL_USERNAME"
      },
      {
        "valueFrom": "${secrets_arn}:MIX_PUSHER_APP_CLUSTER::",
        "name": "MIX_PUSHER_APP_CLUSTER"
      },
      {
        "valueFrom": "${secrets_arn}:MIX_PUSHER_APP_KEY::",
        "name": "MIX_PUSHER_APP_KEY"
      },
      {
        "valueFrom": "${secrets_arn}:PUSHER_APP_CLUSTER::",
        "name": "PUSHER_APP_CLUSTER"
      },
      {
        "valueFrom": "${secrets_arn}:PUSHER_APP_ID::",
        "name": "PUSHER_APP_ID"
      },
      {
        "valueFrom": "${secrets_arn}:PUSHER_APP_KEY::",
        "name": "PUSHER_APP_KEY"
      },
      {
        "valueFrom": "${secrets_arn}:PUSHER_APP_SECRET::",
        "name": "PUSHER_APP_SECRET"
      },
      {
        "valueFrom": "${secrets_arn}:QUEUE_CONNECTION::",
        "name": "QUEUE_CONNECTION"
      },
      {
        "valueFrom": "${secrets_arn}:REDIS_HOST::",
        "name": "REDIS_HOST"
      },
      {
        "valueFrom": "${secrets_arn}:REDIS_PASSWORD::",
        "name": "REDIS_PASSWORD"
      },
      {
        "valueFrom": "${secrets_arn}:REDIS_PORT::",
        "name": "REDIS_PORT"
      },
      {
        "valueFrom": "${secrets_arn}:SESSION_DRIVER::",
        "name": "SESSION_DRIVER"
      },
      {
        "valueFrom": "${secrets_arn}:SESSION_LIFETIME::",
        "name": "SESSION_LIFETIME"
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
