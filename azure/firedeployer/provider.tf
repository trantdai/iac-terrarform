############################################################################################
# Author: Dai Tran
# Email: trantdaiau@gmail.com
# Copyright 20202.
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
############################################################################################

############################################################################################
# CONFIGURE THE MICROSOFT AZURE PROVIDER
############################################################################################

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  /*
  skip_provider_registration = false
  version                    = "2.17"
  */
  skip_provider_registration = true
  #version                    = var.terraform_version
  version         = "2.17"
  subscription_id = var.subscription_id
  #	client_id       = "changeme"
  #	client_secret   = "changeme"
  tenant_id = var.tenant_id
  features {}
}
