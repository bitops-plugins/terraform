## Installation

This plugin gets installed through ```bitops.config.yaml```.

? Where is this file located?

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
