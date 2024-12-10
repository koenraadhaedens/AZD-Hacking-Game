#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input parameters
LOCATION=$1
RESOURCE_GROUP="rg-cohack2"
MANAGED_IDENTITY_NAME="mi-sentinel1"
VNET_NAME="vnet-cohack1"

echo "Starting post-provision setup..."

# Get the subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Validate required tools
echo "Validating Azure CLI..."
if ! command -v az &> /dev/null; then
    echo "Azure CLI not found. Please install it before running this script."
    exit 1
fi

# Retrieve managed identity ID
MANAGED_IDENTITY_ID=$(az identity show --name "$MANAGED_IDENTITY_NAME" --resource-group "$RESOURCE_GROUP" --query id -o tsv)

if [[ -z "$MANAGED_IDENTITY_ID" ]]; then
    echo "Error: Managed Identity '$MANAGED_IDENTITY_NAME' not found in resource group '$RESOURCE_GROUP'."
    exit 1
fi
echo "Managed Identity ID: $MANAGED_IDENTITY_ID"

# Assign the Reader role to the managed identity at the subscription level
echo "Assigning Reader role to Managed Identity..."
az role assignment create --assignee "$MANAGED_IDENTITY_ID" --role "Reader" --scope "/subscriptions/$SUBSCRIPTION_ID"

# Display information about the created resources
echo "Retrieving public IP of virtual machine..."
VM_PUBLIC_IP=$(az network public-ip show --resource-group "$RESOURCE_GROUP" --name "vm-win11-ip1" --query ipAddress -o tsv)

echo "Setup completed successfully!"
echo "Virtual Machine Public IP: $VM_PUBLIC_IP"
