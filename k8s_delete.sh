#!/bin/bash

kubectl delete -f k8s-resources/ -n app-faceit
aws ecr batch-delete-image --repository-name faceit-homework --image-ids imageTag=latest > /dev/null 2>&1
