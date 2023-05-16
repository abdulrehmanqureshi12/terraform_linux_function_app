#!/bin/bash

export ARM_CLIENT_ID=$SP_APP_ID
export ARM_CLIENT_SECRET=$SP_APP_PW
export ARM_SUBSCRIPTION_ID=$AZ_SUB_ID
export ARM_TENANT_ID=$SP_APP_TENANT_ID
export ARM_ACCESS_KEY=$TARGET_RS_STORAGE_ACCESS_KEY

# prepare terraform variables through environment variables
export TF_VAR_tenant_id=$SP_APP_TENANT_ID
export TF_VAR_location=$TARGET_LOCATION
export TF_VAR_environment=$TARGET_ENV
export TF_VAR_cidr_allocation_primary=$CIDR_ALLOCATION
export TF_VAR_target_devops_keyvault=$TARGET_DEVOPS_KEYVAULT
export TF_VAR_cert_key_vault_secret_id=$CERT_KEYVAULT_SECRET
export TF_VAR_azure_subscription_id=$AZ_SUB_ID

# Set RUN_OPTION to 'planonly' if you want to skip Terraform apply command.
RUN_OPTION=$1

# Set DESTROY_ALL to true if you want to remove all resources under TF management. This enables a quick wipe-out of sandbox.
DESTROY_ALL=false

# Set TERRAFORM_COLOR to true or false to enable or disable Terraform color.
TERRAFORM_COLOR=true

# need to call az login for terraform bash program calls to az rest
az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
az account set -s "${ARM_SUBSCRIPTION_ID}"

terraform version

ls -al

if [ "$TERRAFORM_COLOR" = true ]; then
  export TF_CLI_ARGS="-no-color"
fi

echo "Starting Terraform Init..."
terraform init $TF_CLI_ARGS -backend-config=storage_account_name=$TARGET_RS_STORAGE_ACCOUNT -backend-config=container_name=$TARGET_RS_CONTAINER_NAME -backend-config=key=$TARGET_ENV -backend-config=resource_group_name=$TARGET_RS_RG -backend-config=access_key=$TARGET_RS_STORAGE_ACCESS_KEY
echo "Completed Terraform Init."

#######################################################################
update_aks_keyvault_network "add"
#######################################################################

if [ $DESTROY_ALL = true ]; then
  terraform destroy $TF_CLI_ARGS -auto-approve
else
  echo "Creation step:"
  export TF_VAR_execute_step="create"
  echo "Starting Terraform Plan..."
  terraform plan $TF_CLI_ARGS -out=tfplan_create.out
  echo "Completed Terraform Plan."
  
  if [ "$RUN_OPTION" = 'apply' ]; then
    echo "Starting Terraform Apply..."
    terraform apply $TF_CLI_ARGS -auto-approve "tfplan_create.out"
    echo "Completed Terraform Apply."
    
    echo "Remediation step:"
    export TF_VAR_execute_step="remediate"
    
    echo "Starting Terraform Plan for Remediation..."
    # terraform plan $TF_CLI_ARGS -target=azurerm_application_insights.device-get -target=azurerm_application_insights.device-map -target=azurerm_application_insights.entitlements-get -target=azurerm_application_insights.cache-update -out=tfplan_remediate.out
    echo "Completed Terraform Plan for Remediation."
    
    echo "Starting Terraform Apply for Remediation..."
    # terraform apply $TF_CLI_ARGS -auto-approve "tfplan_remediate.out"
    echo "Completed Terraform Apply for Remediation."
  else
    echo "Skipped Terraform Apply."
  fi
fi

#######################################################################
update_aks_keyvault_network "remove"
#######################################################################
