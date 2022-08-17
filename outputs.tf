/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# output "project_role_bindings" {
#   value = local.project_role_bindings
# }

output "restricted_iam_admin_bindings" {
  value = local.restricted_iam_admin_bindings
}

# output "project_roles_needed_flat" {
#   value = local.project_roles_needed_flat
# }

# output "project_group_to_role" {
#   value = local.project_group_to_role
# }
# # output "job_func_permissions" {
# #   value = local.job_func_permissions
# # }

# output "custom-roles" {
#   value = module.custom-roles
# }

output "project_role_custom_bindings" {
  value = local.project_roles_custom_role_bindings
  depends_on = [module.custom-roles]
}

output "custom_roles" {
  value = module.custom-roles
}
