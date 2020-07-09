# Copyright 2020 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

locals {
  contacts = {
    for c in var.contacts : "scc-${c.team_prefix}-${c.project_id}" => {
      team_prefix = c.team_prefix
      project_id  = c.project_id
      email       = c.email
    }
  }
}

resource "google_organization_iam_member" "runner_iam" {
  for_each = toset(var.members)
  org_id   = var.org_id
  role     = "roles/securitycenter.notificationConfigEditor"
  member   = each.value
}

resource "google_pubsub_topic" "scc_topic" {
  for_each = local.contacts
  project  = var.pubsub_project_id
  name     = each.key
  labels = {
    team    = each.value.team_prefix
    project = each.value.project_id
  }
}

resource "null_resource" "contacts" {
  for_each = local.contacts

  provisioner "local-exec" {
    command = "./scripts/create-notification.sh"
    environment = {
      ORG_ID            = var.org_id
      NOTIFICATION_NAME = each.key
      TEAM_NAME         = each.value.team_prefix
      PROJECT           = each.value.project_id
      PUBSUB_TOPIC      = google_pubsub_topic.scc_topic[each.key].id
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/delete-notification.sh"
    environment = {
      # NOTE: See https://github.com/hashicorp/terraform/issues/23679
      ORG_ID            = self.triggers.org_id
      NOTIFICATION_NAME = each.key
    }
  }

  triggers = {
    org_id       = var.org_id
    notification = each.key
    team         = each.value.team_prefix
    project      = each.value.project_id
    topic        = google_pubsub_topic.scc_topic[each.key].id
  }
}
