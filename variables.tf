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

variable "org_id" {}
variable "pubsub_project_id" {
  type        = string
  description = "Project Id for the project where pubsub topics will be created"
}

variable "members" {
  type        = list
  default     = []
  description = "List of members to allow to edit SCC notification configs. The terraform user should have this."
}

variable "contacts" {
  type = list(object({
    team_prefix = string # Interpolated into topic and notification name
    project_id  = string # Interpolated into topic and notification name
    email       = string # This is just set passed throug to the output
  }))
  description = "There will be a NotificationConfig and PubSub topic created for each contact"
}
