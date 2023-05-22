#!/bin/bash
# shellcheck disable=SC2206

# set a default init command to splat later
terraform_cmd=(init -input=false)

# set $BITOPS_TERRAFORM_CUSTOM_INIT to add params to the default init command
if [[ -n $BITOPS_TERRAFORM_CUSTOM_INIT ]]; then 
  echo "Running custom terraform init"
  terraform_cmd+=( $BITOPS_TERRAFORM_CUSTOM_INIT )
fi

# splat the command to run terraform init with any custom params
terraform "${terraform_cmd[@]}" || /usr/local/bin/terraform-$TERRAFORM_VERSION "${terraform_cmd[@]}"
