// resource "aws_lambda_function" "routing" {
//   filename = "routing-runner.js.zip"
//   function_name = "routing"
//   role = "${data.aws_iam_role.lambda.arn}"
//   handler = "routing-runner.handler"
//   runtime = "nodejs6.10"
//   source_code_hash = "${base64sha256(file("routing-runner.js.zip"))}"

//   environment {
//     variables = {
      
//     }
//   }
// }

resource "aws_lambda_function" "index-page" {
  filename = "index-page-runner.js.zip"
  function_name = "index-page"
  role = "${data.aws_iam_role.iam_for_lambda.arn}"
  handler = "index-page-runner.handler"
  runtime = "nodejs8.10"
  source_code_hash = "${base64sha256(file("index-page-runner.js.zip"))}"
}
