# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MIT

terraform {
  required_version = "~> 1.10.0"
  required_providers {
    googleworkspace = {
      source = "hashicorp/googleworkspace"
      version = "0.4.0"
    }
  }
}
