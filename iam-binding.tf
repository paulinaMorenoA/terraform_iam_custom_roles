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

locals {

  project_iam_role_bindings = {
    "TenantAdmin" = [
      "roles/iam.serviceAccountAdmin",
      "roles/cloudsupport.techSupportViewer",
    ]
    "PowerUser" = [
      "roles/dataflow.admin",
      "roles/dataproc.admin",
      "roles/composer.admin",
      "roles/storage.objectViewer",
      "roles/bigquery.user",
      "roles/bigquery.dataViewer",
      "roles/logging.viewer",
      "roles/monitoring.viewer",
      "roles/cloudscheduler.admin",
      "roles/run.admin",
      "roles/bigtable.admin",
      "roles/cloudbuild.builds.approver",
      "roles/cloudbuild.builds.builder",
      "roles/aiplatform.admin",
      "roles/iam.workloadIdentityPoolAdmin",
      "roles/datapipelines.admin",
      "roles/pubsub.admin",
      "roles/healthcare.annotationStoreAdmin",
      "roles/healthcare.consentArtifactAdmin",
      "roles/healthcare.consentStoreAdmin",
      "roles/healthcare.fhirStoreAdmin",
      "roles/healthcare.datasetAdmin",
      "roles/healthcare.dicomStoreAdmin",
      "roles/healthcare.hl7V2StoreAdmin",
      "roles/container.admin",
      "roles/cloudsupport.techSupportEditor",
   ]
    "Developer" = [
      "roles/dataflow.developer",
      "roles/dataproc.editor",
      "roles/composer.user"
      # "roles/storage.objectViewer",
      # "roles/bigquery.user",
      # "roles/bigquery.dataViewer",
      # "roles/logging.viewer",
      # "roles/monitoring.viewer",
      # "roles/cloudscheduler.jobRunner",
      # "roles/run.developer",
      # "roles/run.invoker",
      # "roles/bigtable.user",
      # "roles/cloudbuild.builds.editor",
      # "roles/aiplatform.featurestoreDataWriter",
      # "roles/aiplatform.user",
      # "roles/iam.workloadIdentityPoolAdmin",
      # "roles/pubsub.editor",
      # "roles/healthcare.annotationEditor",
      # "roles/healthcare.consentArtifactEditor",
      # "roles/healthcare.consentEditor",
      # "roles/healthcare.fhirResourceEditor",
      # "roles/healthcare.datasetViewer",
      # "roles/healthcare.dicomEditor",
      # "roles/container.developer",
      # "roles/cloudsupport.techSupportEditor"
    ]
    "Viewer" = [
      "roles/dataflow.viewer",
      "roles/dataproc.viewer",
      "roles/composer.user",
      "roles/storage.objectViewer",
      "roles/bigquery.user",
      "roles/bigquery.dataViewer",
      "roles/logging.viewer",
      "roles/monitoring.viewer",
      "roles/cloudscheduler.viewer",
      "roles/run.viewer",
      "roles/bigtable.reader",
      "roles/cloudbuild.builds.viewer",
      "roles/aiplatform.viewer",
      "roles/iam.workloadIdentityPoolViewer",
      "roles/pubsub.viewer",
      "roles/healthcare.annotationReader",
      "roles/healthcare.consentArtifactReader",
      "roles/healthcare.consentStoreViewer",
      "roles/healthcare.fhirStoreViewer",
      "roles/healthcare.datasetViewer",
      "roles/healthcare.dicomStoreViewer",
      "roles/healthcare.hl7V2StoreViewer",
      "roles/container.clusterViewer",
      "roles/cloudsupport.techSupportViewer",
    ]
    # "sandbox" = [
    #   "roles/editor",
    #   "roles/iap.tunnelResourceAccessor",
    #   "roles/source.admin",
    #   "roles/monitoring.admin",
    #   "roles/artifactregistry.admin",
    #   "roles/automl.admin",
    #   "roles/bigquery.admin",
    #   "roles/cloudfunctions.admin",
    #   "roles/cloudsql.admin",
    #   "roles/dataflow.admin",
    #   "roles/container.admin",
    #   "roles/notebooks.admin",
    #   "roles/iam.serviceAccountUser",
    #   "roles/compute.instanceAdmin",
    #   "roles/compute.networkViewer",
    #   "roles/compute.loadBalancerAdmin",
    #   "roles/iam.serviceAccountAdmin"
    # ]
  }
  
  project_group_to_crole_transpose = transpose(var.users_roles_needed == null ? {} : var.users_roles_needed)
  
  project_roles_custom_role_bindings = {for principal, job_functions in local.project_group_to_crole_transpose :
    format("roles/%s",principal) => toset([for job_function in job_functions: format("roles/%s",job_function)])
  }

  restricted_iam_admin_expression = "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['roles/dataflow.worker']) || api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['roles/composer.worker', 'roles/bigquery.jobUser', 'roles/logging.admin'])"

  # restricted_iam_admin_expression = "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['organizations/269666726474/roles/EdpDataprocWorker', 'roles/dataflow.worker']) || api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['roles/composer.worker', 'roles/bigquery.jobUser', 'roles/logging.admin'])"
  restricted_iam_admin_bindings = [
    {
      role        = "roles/resourcemanager.projectIamAdmin"
      title       = "restricted_iam_admin_role"
      description = "Restricted Project IAM admin"
      expression  = local.restricted_iam_admin_expression
      members     = var.restricted_iam_admin_users
    },
  ]

}

module "custom-roles" {
  source = "./modules/custom_role_iam"
  for_each = local.project_iam_role_bindings
  target_level         = "org"
  target_id            = var.org_id
  role_id              = each.key
  title                = format("Custom Role %s", each.key)
  description          = "Custom Role Des"
  base_roles           = each.value
  permissions          = []
}

