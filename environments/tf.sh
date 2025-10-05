#!/bin/bash
set -e

ACTION=${1:-plan} 

MODULES=( # sort by dependency order
  "network/vpc"
  "network/subnet"
  "network/sg"
  "app/ec2"
  "db"
  "app/alb"
  "app/asg"
)

# If destroy, then iterate reversely
if [[ "$ACTION" == "destroy" ]]; then
  for (( idx=${#MODULES[@]}-1 ; idx>=0 ; idx-- )); do
    module=${MODULES[idx]}
    echo "========== Running terraform $ACTION in $module =========="
    cd "$module"
    terraform init -input=false
    terraform destroy -auto-approve
    cd - > /dev/null
  done
else
  for module in "${MODULES[@]}"; do
    echo "========== Running terraform $ACTION in $module =========="
    cd "$module"
    terraform init -input=false
    if [[ "$ACTION" == "apply" ]]; then
      terraform apply -auto-approve
    else
      terraform $ACTION
    fi
    cd - > /dev/null
  done
fi
