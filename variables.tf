variable "function_name" {
  type    = string
  default = "test-function"
}

variable "src_path" {
  type = string
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "target_path" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "nodejs12.x"
}

variable "handler" {
  type    = string
  default = "index.handler"
}

variable "concurrent_executions" {
  type    = string
  default = "1"
}

variable "provisioned_concurrent_executions" {
  type    = string
  default = "1"
}

variable "function_version" {
  type    = string
  default = "1"
}

variable "prefix" {
  type    = string
  default = "test"
}