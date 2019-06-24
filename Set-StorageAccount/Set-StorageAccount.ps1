. ".\Invoke-Azure\Invoke-Azure.ps1"

function Set-StorageAccount() {
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $ResourceGroupName
    )
    Write-Output "Checking if storage account already exists..."
    $storage_account_namecheck = Invoke-Azure storage account check-name --name $Name | Out-String | ConvertFrom-Json

    if ($storage_account_namecheck.nameAvailable -eq $true) {
        Write-Output "Creating storage account..."
        Invoke-Azure storage account create --name $Name --resource-group $ResourceGroupName --location uksouth --sku STANDARD_LRS | Out-String | ConvertFrom-Json
    } else {
        if ($storage_account_namecheck.reason -eq "AlreadyExists") {
            Write-Output "Storage account already exists"
            # Invoke-Azure storage account show --name $Name | Out-String | ConvertFrom-Json
        } else {
            throw "Could not create storage account because: $storage_account_namecheck"
        }
    }
}
