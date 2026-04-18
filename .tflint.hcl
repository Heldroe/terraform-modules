plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

plugin "terraform_style" {
  enabled = true
  version = "0.2.2"
  source  = "github.com/Heldroe/tflint-ruleset-terraform-style"
}

rule "terraform_style_terraform_file" {
  enabled  = true
  filename = "01-providers"
}

rule "terraform_style_resource_file" {
  enabled = true
  exempt_blocks = {
    data = ["aws_iam_policy_document"]
  }
}

rule "terraform_style_no_provider_argument" {
  enabled = true
}
