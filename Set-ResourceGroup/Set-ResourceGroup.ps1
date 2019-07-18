Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. ".\Invoke-Azure\Invoke-Azure.ps1"

function Set-ResourceGroup() {
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Name
    )
    Write-Output "Checking if resource group already exists..."
    $resource_grp_exists = Invoke-Azure group exists --name $Name

    if ($resource_grp_exists -ne $true) {
        Write-Output "Creating resource group..."
        Invoke-Azure group create --location uksouth --name $Name # | Out-String | ConvertFrom-Json
    } else {
        Write-Output "Resource group already exists"
    }
}
