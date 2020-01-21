#!/bin/bash

set -o nounset

fats_dir=`dirname "${BASH_SOURCE[0]}"`/fats

# attempt to cleanup fats
if [ -d "$fats_dir" ]; then
  source $fats_dir/macros/cleanup-user-resources.sh
  kubectl delete namespace $NAMESPACE

  echo "Cleanup riff Core Runtime"
  kapp delete -n apps -a riff-core-runtime -y

  echo "Cleanup riff Knative Runtime"
  kapp delete -n apps -a riff-knative-runtime -y

  echo "Cleanup Knative"
  kapp delete -n apps -a knative -y
  kapp delete -n apps -a istio -y
  kubectl get customresourcedefinitions.apiextensions.k8s.io -oname | grep istio.io | xargs -L1 kubectl delete

  echo "Cleanup riff Build"
  kapp delete -n apps -a riff-build -y
  kapp delete -n apps -a riff-builders -y

  echo "Cleanup kpack"
  kapp delete -n apps -a kpack -y

  echo "Cleanup Cert Manager"
  kapp delete -n apps -a cert-manager -y

  source $fats_dir/cleanup.sh
fi
