#!/bin/bash
set -e

ACTION=${1:-plan} 

ENV=${2:-stg}

mapfile -t MODULES < .modules_order.txt # Read modules from file into an array

# If destroy, then iterate reversely
if [[ "$ACTION" == "destroy" ]]; then
  for (( idx=${#MODULES[@]}-1 ; idx>=0 ; idx-- )); do
    module=${ENV}/${MODULES[idx]}
    echo "========== Running terraform $ACTION in $module =========="
    cd "$module"
    terraform init -input=false
    terraform destroy -auto-approve
    cd - > /dev/null
  done
else
  for module in "${MODULES[@]}"; do
    module=${ENV}/$module
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
