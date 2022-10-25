#!/bin/bash
set -e 

if [ -z "$BITOPS_ENVIRONMENT" ]; then
  echo "environment variable (ENVIRONMENT) not set"
  exit 1
fi


