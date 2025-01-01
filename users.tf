# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MIT

provider "googleworkspace" {}

locals {
  users = csvdecode(file("${path.module}/users.csv"))
}

resource "googleworkspace_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  #primary_email = each.value.email
  #password      = each.value.password
  #hash_function = each.value.password_hash_function
  
  primary_email = format(
    "%s%s@%s",
    substr(lower(each.value.first_name), 0, 1),
    lower(each.value.last_name),
  var.domain)

  password = md5(format(
    "%s%s%s!",
    lower(each.value.last_name),
    substr(lower(each.value.first_name), 0, 1),
    length(each.value.first_name)
  ))

  hash_function = "MD5"

  change_password_at_next_login = true

  name {
    family_name = each.value.last_name
    given_name  = each.value.first_name
  }

  organizations {
    department = each.value.dept
    primary    = true
    title      = each.value.title
    type       = "work"
  }
  recovery_email = each.value.recovery_email
}
