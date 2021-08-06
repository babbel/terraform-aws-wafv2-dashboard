data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "wafv2-web-acl-${var.wafv2_web_acl.name}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 12

        properties = {
          title = "WAFv2 ${var.wafv2_web_acl.name}"

          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          stat    = "Sum"
          period  = 900 # 15 minutes

          metrics = concat(
            [
              concat(
                [
                  "AWS/WAFV2",
                  "AllowedRequests",
                  "WebACL", var.wafv2_web_acl.name,
                  "Rule", var.wafv2_web_acl.visibility_config[0].metric_name,
                ],
                var.wafv2_web_acl.scope == "REGIONAL" ? ["Region", data.aws_region.current.name] : [],
                [
                  {
                    color = "#1f77b4" # blue
                  }
                ]
              ),
            ],
            [
              for rule in var.wafv2_web_acl.rule :
              length(rule.action) == 1 ?
              (
                length(rule.action[0].allow) == 1 ?
                concat(
                  [
                    "AWS/WAFV2",
                    "AllowedRequests",
                    "WebACL", var.wafv2_web_acl.name,
                    "Rule", rule.visibility_config[0].metric_name,
                  ],
                  var.wafv2_web_acl.scope == "REGIONAL" ? ["Region", data.aws_region.current.name] : [],
                  [
                    {
                      color = "#2ca02c" # green
                    }
                  ]
                ) :
                (
                  length(rule.action[0].count) == 1 ?
                  concat(
                    [
                      "AWS/WAFV2",
                      "CountedRequests",
                      "WebACL", var.wafv2_web_acl.name,
                      "Rule", rule.visibility_config[0].metric_name,
                    ],
                    var.wafv2_web_acl.scope == "REGIONAL" ? ["Region", data.aws_region.current.name] : [],
                    [
                      {
                        color = "#ff7f0e" # orange
                      }
                    ]
                  ) :
                  (
                    length(rule.action[0].block) == 1 ?
                    concat(
                      [
                        "AWS/WAFV2",
                        "BlockedRequests",
                        "WebACL", var.wafv2_web_acl.name,
                        "Rule", rule.visibility_config[0].metric_name,
                      ],
                      var.wafv2_web_acl.scope == "REGIONAL" ? ["Region", data.aws_region.current.name] : [],
                      [
                        {
                          color = "#d62728" # red
                        }
                      ]
                    ) :
                    concat(
                      [
                        "Unexpected structure for `wafv2_web_acl` resource",
                        "The `action` block must have subblock with `allow`, `count`, or `block`.",
                        "", "",
                        "", "",
                      ],
                      var.wafv2_web_acl.scope == "REGIONAL" ? ["", ""] : [],
                      [
                        {
                          color = ""
                        }
                      ]
                    )
                  )
                )
              ) :
              (
                length(rule.override_action) == 1 ?
                (
                  length(rule.override_action[0].count) == 1 ?
                  concat(
                    [
                      "AWS/WAFV2",
                      "CountedRequests",
                      "WebACL", var.wafv2_web_acl.name,
                      "Rule", rule.visibility_config[0].metric_name,
                    ],
                    var.wafv2_web_acl.scope == "REGIONAL" ? ["Region", data.aws_region.current.name] : [],
                    [
                      {
                        color = "#ff7f0e" # orange
                      }
                    ]
                  ) :
                  (
                    length(rule.override_action[0].none) == 1 ?
                    concat(
                      [
                        # assuming that managed rules are blocking
                        "AWS/WAFV2",
                        "BlockedRequests",
                        "WebACL", var.wafv2_web_acl.name,
                        "Rule", rule.visibility_config[0].metric_name,
                      ],
                      var.wafv2_web_acl.scope == "REGIONAL" ? ["Region", data.aws_region.current.name] : [],
                      [
                        {
                          color = "#d62728" # red
                        }
                      ]
                    ) :
                    concat(
                      [
                        "Unexpected structure for `wafv2_web_acl` resource",
                        "The `override_action` block must have a subblock with `count` or `none`.",
                        "", "",
                        "", "",
                      ],
                      var.wafv2_web_acl.scope == "REGIONAL" ? ["", ""] : [],
                      [
                        {
                          color = ""
                        }
                      ]
                    )
                  )
                ) :
                concat(
                  [
                    "Unexpected structure for `wafv2_web_acl` resource",
                    "The `rule` block must have a subblock with `action` or `override_action`.",
                    "", "",
                    "", "",
                  ],
                  var.wafv2_web_acl.scope == "REGIONAL" ? ["", ""] : [],
                  [
                    {
                      color = ""
                    }
                  ]
                )
              )
            ]
          )

          yAxis = {
            left = {
              min = 0
            }
          }
        }
      }
    ]
  })
}
