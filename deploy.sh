#!/bin/bash
# shellcheck disable=SC2086,1090,2206

# No set -e here because we want to get a non-zero exit code from terraform_plan.sh
set -e

echo "Running Terraform Plugin deployment script..."

echo "Updating environment variables..."
readEnvVars

# terraform vars
export TERRAFORM_ROOT_SCRIPTS="$BITOPS_INSTALLED_PLUGIN_DIR"
export TERRAFORM_ROOT_OPERATIONS="$BITOPS_OPSREPO_ENVIRONMENT_DIR"
export BITOPS_SCHEMA_ENV_FILE="$TERRAFORM_ROOT_OPERATIONS/ENV_FILE"
export SCRIPTS_DIR="$TERRAFORM_ROOT_SCRIPTS/scripts"

if [ "$TERRAFORM_SKIP_DEPLOY" == "true" ] ; then
  echo "TERRAFORM_SKIP_DEPLOY is set.  Skipping."
  exit 0
fi

if [ ! -d "$TERRAFORM_ROOT_OPERATIONS" ]; then
  echo "No terraform directory.  Skipping."
  exit 0
fi

printf "Deploying terraform..."

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
bash $SCRIPTS_DIR/terraform_init.sh # uses $BITOPS_TERRAFORM_CUSTOM_INIT

if [ -n "$BITOPS_TERRAFORM_WORKSPACE" ]; then
  echo "Running Terraform Workspace"
  bash $SCRIPTS_DIR/terraform_workspace.sh $BITOPS_TERRAFORM_WORKSPACE
fi

# Source Target
## the commented line breaks shellcheck 1035 and 2235 and is less efficient than the new line.
# if [ -n "$BITOPS_TF_TARGETS" ] && !([ "${BITOPS_TERRAFORM_COMMAND}" == "destroy" ] || [ "${TERRAFORM_DESTROY}" == "true" ]); then
if [ -n "$BITOPS_TF_TARGETS" ] && ! { [ "${BITOPS_TERRAFORM_COMMAND}" == "destroy" ] || [ "${TERRAFORM_DESTROY}" == "true" ]; }; then
  targets=( $BITOPS_TF_TARGETS )
  for target in "${targets[@]}"
  do
    TF_TARGET="-target $target"
    
    echo "Running Terraform Plan, Targetting: [$target]"
    bash $SCRIPTS_DIR/terraform_plan.sh "$BITOPS_CONFIG_COMMAND" "$TF_TARGET"
    
    if [ "${BITOPS_TERRAFORM_COMMAND}" != "plan" ]; then
      echo "Runnng Terraform Apply, Targetting: [$target]"
      bash $SCRIPTS_DIR/terraform_apply.sh "$BITOPS_CONFIG_COMMAND" "$TF_TARGET"
    fi
  done
fi

if [ "${BITOPS_TERRAFORM_COMMAND}" == "plan" ]; then
  echo "Running Terraform Plan"
  bash $SCRIPTS_DIR/terraform_plan.sh "$BITOPS_CONFIG_COMMAND"
fi

if [ "${BITOPS_TERRAFORM_COMMAND}" == "apply" ] || [ "${TERRAFORM_APPLY}" == "true" ]; then
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
