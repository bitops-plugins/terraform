#!/bin/bash
# No set -e here because we want to get a non-zero exit code from terraform_plan.sh
set -ex

echo "Running Terraform Plugin deployment script..."

# terraform vars
export TERRAFORM_ROOT_SCRIPTS="$BITOPS_PLUGIN_DIR"
export TERRAFORM_ROOT_OPERATIONS="$BITOPS_OPSREPO_ENVIRONMENT_DIR"

export TERRAFORM_BITOPS_CONFIG="$TERRAFORM_ROOT_OPERATIONS/bitops.config.yaml" 
export BITOPS_SCHEMA_ENV_FILE="$TERRAFORM_ROOT_OPERATIONS/ENV_FILE"
export BITOPS_CONFIG_SCHEMA="$TERRAFORM_ROOT_SCRIPTS/plugin.schema.yaml"

export SCRIPTS_DIR="$TERRAFORM_ROOT_SCRIPTS/scripts"

if [ ! -d "$TERRAFORM_ROOT_OPERATIONS" ]; then
  echo "No terraform directory.  Skipping."
  exit 0
else
  printf "Deploying terraform..."
fi

# Check for Before Deploy Scripts
# bash $SCRIPTS_DIR/deploy/before-deploy.sh "$TERRAFORM_ROOT"

find $SCRIPTS_DIR -name "*.sh" -exec chmod +x {} +

if [ ! -f "$BITOPS_SCHEMA_ENV_FILE" ]; then 
  echo "No terraform ENV file found"
else
  source "$BITOPS_SCHEMA_ENV_FILE"
fi

echo "DEBUGGING: [$SCRIPTS_DIR]"

bash $SCRIPTS_DIR/validate_env.sh

# Copy Default Terraform values
echo "Copying defaults"
$SCRIPTS_DIR/copy_defaults.sh "$TERRAFORM_ROOT"

echo "DEBUGGING: [$SCRIPTS_DIR]"

echo "cd Terraform Root: $TERRAFORM_ROOT_OPERATIONS"
cd $TERRAFORM_ROOT_OPERATIONS

echo "Listing contents of Terraform Root: $TERRAFORM_ROOT_OPERATIONS"
ls -al .

# Set terraform version
echo "Using terraform version $TERRAFORM_VERSION"
#ln -s /usr/local/bin/terraform-$TERRAFORM_VERSION /usr/local/bin/terraform

# always init first
echo "Running terraform init"
terraform init -input=false || /usr/local/bin/terraform-$TERRAFORM_VERSION init -input=false


if [ -n "$BITOPS_TERRAFORM_WORKSPACE" ]; then
  echo "Running Terraform Workspace"
  bash $SCRIPTS_DIR/terraform_workspace.sh $TERRAFORM_WORKSPACE
fi

if [ "${BITOPS_TERRAFORM_COMMAND}" == "plan" ]; then
  echo "Running Terraform Plan"
  bash $SCRIPTS_DIR/terraform_plan.sh "$BITOPS_CONFIG_COMMAND"
fi

if [ "${BITOPS_TERRAFORM_COMMAND}" == "apply" ] || [ "${TERRAFORM_APPLY}" == "true" ]; then
  # always plan first
  echo "DEBUGGING: [$SCRIPTS_DIR]"
  echo "Running Terraform Plan"
  bash $SCRIPTS_DIR/terraform_plan.sh "$BITOPS_CONFIG_COMMAND"

  echo "Running Terraform Apply"
  bash $SCRIPTS_DIR/terraform_apply.sh "$BITOPS_CONFIG_COMMAND"
fi

if [ "${BITOPS_TERRAFORM_COMMAND}" == "destroy" ] || [ "${TERRAFORM_DESTROY}" == "true" ]; then
  # always plan first
  echo "Running Terraform Plan"
  bash $SCRIPTS_DIR/terraform_plan.sh "-destroy $BITOPS_CONFIG_COMMAND"
  
  echo "Running Terraform Destroy"
  bash $SCRIPTS_DIR/terraform_destroy.sh "$BITOPS_CONFIG_COMMAND"
fi

# Check for After Deploy Scripts
# bash $PLUGIN_DIR/deploy/after-deploy.sh "$TERRAFORM_ROOT"

#echo "PLUGIN_DIR=${PLUGIN_DIR}"