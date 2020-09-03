#!/usr/bin/env bash

# Initialize environment
SCRIPT_NAME=$0
ACTION=$1
ENV=$2

function readEnvironmentFile() {
  if [ -f "$1.env" ]; then
    source $1.env
  else
    echo -e "No file named $1.env\n"
    listCommands
    exit 1
  fi
}

function applyConfiguration() {
  echo "Copy the domain name into variables"
  sed -i "s/value: .*/value: ${DOMAIN_HOST}/g" ./ingress_patch.yml

  echo "Copy the storage class for kubernetes PVC"
  sed -i "s/storageClassName: .*/storageClassName: ${KUBERNETES_STORAGE_CLASSE}/g" ./mssql/pvc.yml
}

function listCommands() {
cat << EOT
Available commands:

init environment
install environment
apply environment
delete environment
help

Exemple :
  Create a prod.env file based on .env
    >$ cp .env prod.env

  Initialize the configuration based on your prod.env file
    >$ $SCRIPT_NAME init prod

  Create namespace and install bitwarden
    >$ $SCRIPT_NAME install prod

  Apply any modification from your prod.env file
    >$ $SCRIPT_NAME install prod

  Delete bitwarden and the namespace
    >$ $SCRIPT_NAME delete prod
EOT
}

# Commands

readEnvironmentFile $ENV
if [ "$ACTION" == "install" ]; then
  kubectl create ns $KUBERNETES_NAMESPACE
  applyConfiguration
  kubectl apply -n $KUBERNETES_NAMESPACE -k .
elif [ "$ACTION" == "apply" ]; then
  applyConfiguration
  kubectl apply -n $KUBERNETES_NAMESPACE -k .
elif [ "$ACTION" == "delete" ]; then
  kubectl delete -n $KUBERNETES_NAMESPACE -k .
  kubectl delete ns $KUBERNETES_NAMESPACE
elif [ "$ACTION" == "init" ]; then
  applyConfiguration
elif [ "$ACTION" == "help" ]; then
    listCommands
else
    echo "No command found."
    echo
    listCommands
fi
