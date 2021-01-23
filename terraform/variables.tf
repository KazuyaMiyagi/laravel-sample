variable "domain_name" {
  type = string
}

variable "application" {
  type    = string
  default = "laravel"
}

variable "ecs_cpu" {
  type    = string
  default = "256"
}

variable "ecs_memory" {
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
