#!/bin/bash
set -e

echo ""
echo "When including a plugin in a BitOps install, this script will be called during docker build."
echo "It should be used to install any dependencies required to actually run your plugin."
echo "BitOps uses alpine linux as its base, so you'll want to use apk commands (Alpine Package Keeper)"
echo ""

apk info

# export TERRAFORM_VERSIONS=$(cat build.config.yaml | shyaml get-values terraform.versions)
TERRAFORM_VERSION=1.2.2
echo "USING TERRAFORM VERSION: [$TERRAFORM_VERSION]"


mkdir -p /opt/download
cd /opt/download

echo "CD - DOWNLOAD FOLDER"

# results=$(command -v terraform)
# echo "COMMAND CHECK: [$results]"
# if [[ -n $results ]]; then
#   # Command already exists. Exiting.
#   exit 0 
# fi

echo "INSTALLING TERRAFORM"

TERRAFORM_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
echo ${TERRAFORM_DOWNLOAD_URL}
curl -LO ${TERRAFORM_DOWNLOAD_URL} && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d ./
mv terraform /usr/local/bin/terraform-${TERRAFORM_VERSION}
ln -s /usr/local/bin/terraform-${TERRAFORM_VERSION} /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform-${TERRAFORM_VERSION}


