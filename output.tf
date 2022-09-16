output "lambda_arn" {
  value       = aws_lambda_function.lambdaFunc.arn
  description = "value of the lambda function arn"
}

output "lambda_name" {
  value       = aws_lambda_function.lambdaFunc.function_name
  description = "value of the lambda function arn"
}

output "lambda_invoke_arn" {
  value       = aws_lambda_function.lambdaFunc.invoke_arn
  description = "value of the lambda function invoke name"
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec.arn
  description = "value of the lambda function role arn"
}

output "lambda_role_name" {
  value = aws_iam_role.lambda_exec.arn
  description = "value of the lambda function role name"
}

output "provisioned_concurrent_executions" {
  value       = aws_lambda_provisioned_concurrency_config.config.provisioned_concurrent_executions
  description = "value of the lambda function provisioned concurrent executions"
}

output "concurrent_executions" {
  value       = aws_lambda_function.lambdaFunc.reserved_concurrent_executions
  description = "value of the lambda function concurrent executions"
}