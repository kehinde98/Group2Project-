#!/usr/bin/env bash
set -e

RG="group2-project-rg"
LOCATION="eastus"
STORAGE_ACCOUNT="group2p$RANDOM"
CONTAINER="public-files"

echo "Creating resource group..."
az group create --name $RG --location $LOCATION -o table

echo "Creating storage account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RG \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 -o table

echo "Allowing blob public access..."
az storage account update \
  --name $STORAGE_ACCOUNT \
  --resource-group $RG \
  --set allowBlobPublicAccess=true -o table

echo "Creating container..."
KEY=$(az storage account keys list -g $RG -n $STORAGE_ACCOUNT --query '[0].value' -o tsv)

az storage container create \
  --name $CONTAINER \
  --public-access blob \
  --account-name $STORAGE_ACCOUNT \
  --account-key $KEY -o table

echo "✅ Deployment complete!"
echo "STORAGE_ACCOUNT=$STORAGE_ACCOUNT"
echo "CONTAINER=$CONTAINER"
