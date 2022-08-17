/**
 * Copyright 2022 Google LLC
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

module "get-iam-bindings" {
  source                     = "github.com/paulinaMorenoA/terraform-google-iam-bindings"
}
  
module "custom-roles" {
  source = "./modules/custom_role_iam"
  for_each = module.get-iam-bindings.project_iam_role_bindings
  target_level         = "org"
  target_id            = var.org_id
  role_id              = each.key
  title                = format("Custom Role %s", each.key)
  description          = "Custom Role Des"
  base_roles           = each.value
  permissions          = []
}

