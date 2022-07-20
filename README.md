# Bitops Plugin for Terraform

## Introduction
This plugin will let BitOps to automatically deploy ``terraform`` resources on any cloud provider. ``terraform`` plugin uses session variables while connecting to any cloud provider.

## Installation

This plugin gets installed through ```bitops.config.yaml```.

### Sample Config

```
bitops:
  fail_fast: true 
  run_mode: default
  logging:      
    level: DEBUG
    color:
      enabled: true
    filename: bitops-run
    err: bitops.logs
    path: /var/logs/bitops
  opsrepo_root_default_dir: _default
  plugins:    
    terraform:
      source: https://github.com/bitops-plugins/terraform
...
...
...

```

## Deployment

``terraform`` plugin uses ```bitops.config.yaml``` located in the operations repo when deploying resources using terraform scripts.

### Sample Config
```
terraform:
    cli:
        var-file: my-vars.tfvars
        target: terraform.module.resource
        stack-action: "plan"
        backend-config:
            - KEY1=foo
            - KEY2=bar
    options:
        version: "0.13.2"
        workspace: test
```

``terraform`` will always run `terraform init` and `terraform plan` on every execution.

## CLI and options configuration of Terraform ``bitops.schema.yaml``

### Terraform BitOps Schema

[bitops.schema.yaml](https://github.com/bitops-plugins/terraform/blob/main/bitops.schema.yaml)

-------------------
### var-file
* **BitOps Property:** `var-file`
* **CLI Argument:** `--var-file`
* **Environment Variable:** `BITOPS_TF_VAR_FILE`
* **default:** `""`

-------------------
### target
* **BitOps Property:** `target`
* **CLI Argument:** `--target`
* **Environment Variable:** `BITOPS_TF_TARGET`
* **default:** `""`

-------------------
### backend-config
* **BitOps Property:** `backend-config`
* **CLI Argument:** `--KEY1=foo --KEY2=bar`
* **Environment Variable:** ``
* **default:** `""`

-------------------

### stack-action
* **BitOps Property:** `stack-action`
* **Environment Variable:** `BITOPS_TERRAFORM_COMMAND`
* **default:** `"plan"`

Controls what terraform command to run. e.g. `apply`, `destroy`, etc.


-------------------


## Options Configuration

-------------------
### version
* **BitOps Property:** `version`
* **Environment Variable:** `BITOPS_TERRAFORM_VERSION`
* **default:** `"0.12.29"`

Allows customziation of which version of terraform to run

-------------------
### workspace
* **BitOps Property:** `workspace`
* **Environment Variable:** `BITOPS_TERRAFORM_WORKSPACE`
* **default:** `""`

Will select a terraform workspace using `terraform workspace new $TERRAFORM_WORKSPACE || terraform workspace select $TERRAFORM_WORKSPACE` prior to running other terraform commands.

-------------------

## Additional Environment Variable Configuration
Although not captured in `bitops.config.yml`, the following environment variables can be set to further customize behaviour

-------------------
### SKIP_DEPLOY_TERRAFORM
Will skill all terraform executions. This superseeds all other configuration

-------------------
### TERRAFORM_APPLY
Will force call `terraform apply`

-------------------
### TERRAFORM_DESTROY
Will force call `terraform destroy`

-------------------
### INIT_UPGRADE
Will add `--upgrade` flag to the init command
