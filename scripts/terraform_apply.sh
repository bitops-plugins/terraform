#!/bin/bash
set -e

echo "Running terraform apply..."

BITOPS_CONFIG="$TERRAFORM_BITOPS_CONFIG" 
TF_ARGS=$1
SOURCE_TARGET=$2

TF_LOG=""
if [ "${DEBUG}" == 'true' ]; then
    echo "Setting Terraform logging to debug mode..."
    TF_LOG="DEBUG"
fi

if [ "${TERRAFORM_APPLY_ALTERNATE_COMMAND}" == "true" ]; then
  printf "${WARN}Running Alternate Terraform command.${NC}"

  TERRAFORM_COMMAND=$(shyaml get-value terraform_options.terraform_apply.command < "$BITOPS_CONFIG" || true)
  bash $SCRIPTS_DIR/util/run-text-as-script.sh "$TERRAFORM_ROOT" "$TERRAFORM_COMMAND"
else
  terraform apply $SOURCE_TARGET -auto-approve $TF_ARGS
fi

printf "${SUCCESS} Terraform deployment was successful...${NC}"


