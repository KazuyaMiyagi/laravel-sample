variable "domain_name" {
  type = string
}

variable "application" {
  type    = string
  default = "laravel"
}

variable "task_cpu" {
  type    = string
  default = "256"
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "laravel_command" {
  type    = string
  default = "laravel"
}

variable "webserver_command" {
  type    = string
  default = "webserver"
}

variable "scheduler_command" {
  type    = string
  default = "laravel-scheduler"
}

variable "worker_command" {
  type    = string
  default = "laravel-worker"
}

variable "laravel_echo_server_auth_host" {
  type    = string
  default = "http://localhost"
}

variable "laravel_echo_server_debug" {
  type    = string
  default = "false"
}

variable "laravel_echo_server_host" {
  type    = string
  default = ""
}

variable "laravel_echo_server_port" {
  type    = string
  default = "6001"
}

variable "laravel_echo_server_proto" {
  type    = string
  default = "http"
}

variable "laravel_echo_server_redis_host" {
  type    = string
  default = ""
}

variable "laravel_echo_server_redis_password" {
  type    = string
  default = ""
}

variable "laravel_echo_server_redis_port" {
  type    = string
  default = "6379"
}

variable "laravel_echo_server_ssl_cert" {
  type    = string
  default = ""
}

variable "laravel_echo_server_ssl_chain" {
  type    = string
  default = ""
}

variable "laravel_echo_server_ssl_key" {
  type    = string
  default = ""
}

variable "laravel_echo_server_ssl_pass" {
  type    = string
  default = ""
}

variable "repository" {
  type    = string
  default = "KazuyaMiyagi/laravel-sample"
}

variable "docker_build_target" {
  type    = string
  default = "release"
}

variable "enable_approve_action" {
  type    = bool
  default = true
}
