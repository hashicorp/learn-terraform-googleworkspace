data "googleworkspace_privileges" "privileges" {}

locals {
    billing_admin_privileges = [
    for priv in data.googleworkspace_privileges.privileges.items : priv
    if length(regexall("BILLING", priv.privilege_name)) > 0
  ]
}

resource "googleworkspace_role" "billing-admin" {
  name = "billing-admin"

  dynamic "privileges" {
    for_each = local.billing_admin_privileges
    content {
      service_id     = privileges.value["service_id"]
      privilege_name = privileges.value["privilege_name"]
    }
  }
}


resource "googleworkspace_role_assignment" "billing-admin" {
    for_each = {for u in googleworkspace_user.users: u.id => u if element(u.organizations[*].title, 0) == "manager"}
    role_id     = googleworkspace_role.billing-admin.id
    assigned_to = each.key
}

