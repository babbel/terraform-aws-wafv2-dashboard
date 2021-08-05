# CloudWatch Dashboard for a WAFv2

This modules creates a CloudWatch Dashboard for a WAFv2 showing the overall `AllowedRequests`, as well as `AllowedRequests`, `CountedRequests`, and `BlockedRequests` for each WAFv2 rule.

## Usage

```tf
module "wafv2-dashboard" {
  source = "babbel/wafv2-dashboard/aws"

  wafv2_web_acl = aws_wafv2_web_acl.example
}
```

Please note: If you want to create a dashbaord for a WAFv2 of a CloudFront distribution and if `us-east-1` is not the region of your default AWS provider, you must specify a `providers` map as well:

```tf
module "wafv2-dashboard-example" {
  source = "babbel/wafv2-dashboard/aws"

  providers = {
    aws = aws.us-east-1
  }

  wafv2_web_acl = aws_wafv2_web_acl.example
}
```
