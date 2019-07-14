Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

. ".\Set-ResourceGroup\Set-ResourceGroup.ps1"
. ".\Set-StorageAccount\Set-StorageAccount.ps1"
. ".\Set-StorageContainer\Set-StorageContainer.ps1"

function Set-BackendStorage {
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $ResourceGroupName,
        # This storage account name should be as unique as possible since there is no 'exists' cmd to check
        # your own storage accounts, only a 'check-name' cmd which will check against ALL resource on Azure
        [Parameter(Mandatory=$true, Position=1)]
        [string] $StorageAccountName,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $StorageContainerName
    )
    # New-Variable -Name RESOURCE_GRP_NAME -Value "terraform_storage_rsgrp" -Option Constant
    # New-Variable -Name STORAGE_ACCOUNT_NAME -Value "demoterraformstorageacc" -Option Constant
    # New-Variable -Name STORAGE_CONTAINER_NAME -Value "terraformstoragecontainer" -Option Constant

    # https://docs.microsoft.com/en-us/cli/azure/storage/account/keys?view=azure-cli-latest
    # Write-Output "Fetching storage account key"
    # $storage_account_keys = Invoke-Azure storage account keys list --account-name $storage_account.name | Out-String | ConvertFrom-Json
    # $storage_account_key = $storage_account_keys[0]

    Set-ResourceGroup -Name $ResourceGroupName
    Set-StorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName
    Set-StorageContainer -Name $StorageContainerName -StorageAccountName $StorageAccountName
}
