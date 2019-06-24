# Azure DevOps terraform scripts

Each of these scripts are idempotent.

## Set-BackendStorage

This was created to execute in an Azure CLI context within an Azure DevOps release pipeline. It prepares the pre-requisite blob storage for a Terraform [azurem backend](https://www.terraform.io/docs/backends/types/azurerm.html).
