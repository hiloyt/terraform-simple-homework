#!/bin/bash

REPO_URL=$(terraform output -raw --state terraform/terraform.tfstate repository_url)
DB_URL=$(terraform output -raw --state terraform/terraform.tfstate db_instance_address)
sed -Ei "s|CM_IMAGE_LOC|$REPO_URL|g" k8s-resources/deployment.yaml
sed -Ei "s|CM_RDS_LOC|$DB_URL|g" k8s-resources/deployment.yaml
kubectl create ns app-faceit
kubectl apply -f k8s-resources/ -n app-faceit