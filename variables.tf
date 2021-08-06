variable "wafv2_web_acl" {
  type = object({
    name  = string
    scope = string

    rule = list(
      object({
        action = list(
          object({
            allow = list(object({}))
            count = list(object({}))
            block = list(object({}))
          })
        )

        override_action = list(
          object({
            count = list(object({}))
            none  = list(object({}))
          })
        )

        visibility_config = list(
          object(
            {
              metric_name = string
            }
          )
        )
      })
    )

    visibility_config = list(
      object(
        {
          metric_name = string
        }
      )
    )
  })

  description = "Instance of `aws_wafv2_web_acl` for which the CloudWatch Dashboard will be created."
}
