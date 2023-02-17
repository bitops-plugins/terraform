# Bitops Plugin for Terraform

## Table of contents

1. [Introduction](#Introduction)
2. [Installation](https://github.com/bitops-plugins/terraform/blob/main/INSTALL.md)
3. [Deployment](#Deployment)


---

## Introduction
This plugin will let BitOps to automatically deploy ``terraform`` resources on any cloud provider. ``terraform`` plugin uses session variables while connecting to any cloud provider.

## Deployment

``terraform`` plugin uses ```bitops.config.yaml``` located in the operations repo when deploying resources using terraform scripts.

### Example `bitops.config.yaml`, minimum required
```
terraform: {}
```

### Example 2 `bitops.config.yaml`
```
terraform:
    cli:
        var-file: my-vars.tfvars
        targets: 
            - resource_identifier.foo
            - resource_identifier.bar
        backend-config:
            - KEY1=foo
            - KEY2=bar
        stack-action: "plan"
    options:
        workspace: test
```

``terraform`` will always run `terraform init` and `terraform plan` on every execution.

Run BitOps with the environmental variable `TERRAFORM_APPLY` set to `true` or set `stack-action` in the `bitops.config.yaml` file to apply to run `terraform apply`.

## CLI and options configuration of Terraform ``bitops.schema.yaml``

### Terraform BitOps Schema

[bitops.schema.yaml](https://github.com/bitops-plugins/terraform/blob/main/bitops.schema.yaml)

-------------------
## CLI Configurations

-------------------
### var-file
* **BitOps Property:** `var-file`
* **CLI Argument:** `--var-file`
* **Environment Variable:** `BITOPS_TF_VAR_FILE`
* **default:** `""`
* **Required:** `false`
* **Description:** Terraform Varaible file

-------------------
### target
* **BitOps Property:** `targets`
* **CLI Argument:** `-target <target1> -target <target2> ...`
* **Usage:**

    ```
    targets:
        - resource.id1
        - resource.id2
    ```
* **Environment Variable:** `BITOPS_TF_TARGETS`
* **default:** `""`
* **Required:** `false`
* **Description:** `A yaml list of terraform resources that will be created prior to the full stack creation.`

-------------------
### backend-config
* **BitOps Property:** `backend-config`
* **CLI Argument:** `--KEY1=foo --KEY2=bar`
* **Environment Variable:** ``
* **default:** `""`
* **Required:** `false`
* **Description:**

-------------------
### stack-action
* **BitOps Property:** `stack-action`
* **Environment Variable:** `BITOPS_TERRAFORM_COMMAND`
* **default:** `"plan"`
* **Required:** `false`
* **Description:** Controls what terraform command to run. e.g. `apply`, `destroy`, etc. 
-------------------


## Options Configuration
-------------------
### skip-deploy
* **BitOps Property:** `skip-deploy`
* **Environment Variable:** `TERRAFORM_SKIP_DEPLOY`
* **default:** `none`
* **Required:** `""`
* **Description:** If set to true, regardless of the stack-action, deployment actions will be skipped.


-------------------
<!-- ### version
* **BitOps Property:** `version`
* **Environment Variable:** `BITOPS_TERRAFORM_VERSION`
* **default:** `"1.2.2"`
* **Required:** `false`
* **Description:** Allows customziation of which version of terraform to run

* **NOTE:** `This feature currently not supported.`  -->

-------------------
### workspace
* **BitOps Property:** `workspace`
* **Environment Variable:** `BITOPS_TERRAFORM_WORKSPACE`
* **default:** `""`
* **Required:** `false`
* **Description:** Will select a terraform workspace using `terraform workspace new $TERRAFORM_WORKSPACE || terraform workspace select $TERRAFORM_WORKSPACE` prior to running other terraform commands.

-------------------

## Additional Environment Variable Configuration
Although not captured in `bitops.config.yml`, the following environment variables can be set to further customize behaviour.  Set the value of the environental variable to `true` to use


-------------------
### TERRAFORM_APPLY
Will force call `terraform apply`

-------------------
### TERRAFORM_DESTROY
Will force call `terraform destroy`

-------------------
### INIT_UPGRADE
Will add `--upgrade` flag to the init command
