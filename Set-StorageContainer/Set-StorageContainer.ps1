function Set-StorageContainer() {
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $StorageAccountName
    )
    Write-Output "Checking if storage container already exists..."
    $storage_container_exists = Invoke-Azure storage container exists --name $Name --account-name $StorageAccountName

    if ($storage_container_exists -eq $false) {
        Write-Output "Creating storage container..."
        Invoke-Azure storage container create --name $Name --account-name $StorageAccountName# | Out-String | ConvertFrom-Json
    } else {
        Write-Output "Storage container already exists"
        # Invoke-Azure storage container show --name $Name --account-name $StorageAccountName# | Out-String | ConvertFrom-Json
    }
}
