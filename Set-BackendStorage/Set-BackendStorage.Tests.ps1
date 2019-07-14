$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Set-BackendStorage.ps1"

Describe "Set-BackendStorage" {

    New-Variable -Name RESOURCE_GRP_NAME -Value "MOCK_RESOURCE_GROUP_NAME" -Option Constant
    New-Variable -Name STORAGE_ACCOUNT_NAME -Value "MOCK_STORAGE_ACCOUNT_NAME" -Option Constant
    New-Variable -Name STORAGE_CONTAINER_NAME -Value "MOCK_STORAGE_CONTAINER_NAME" -Option Constant

    BeforeEach {
        Mock "Set-ResourceGroup" {}
        Mock "Set-StorageAccount" {}
        Mock "Set-StorageContainer" {}
    }

    It "should set the resource group" {
        $arguments = @{
            ResourceGroupName = $RESOURCE_GRP_NAME
            StorageAccountName = $STORAGE_ACCOUNT_NAME
            StorageContainerName = $STORAGE_CONTAINER_NAME
        }
        Set-BackendStorage @arguments

        Assert-MockCalled Set-ResourceGroup -Times 1 -Scope It -ParameterFilter {
            $Name -eq $RESOURCE_GRP_NAME
        }
    }

    It "should set the storage account" {
        $arguments = @{
            ResourceGroupName = $RESOURCE_GRP_NAME
            StorageAccountName = $STORAGE_ACCOUNT_NAME
            StorageContainerName = $STORAGE_CONTAINER_NAME
        }
        Set-BackendStorage @arguments

        Assert-MockCalled Set-StorageAccount -Times 1 -Scope It -ParameterFilter {
            $Name -eq $STORAGE_ACCOUNT_NAME -and
            $ResourceGroupName -eq $RESOURCE_GRP_NAME
        }
    }

    It "should set the storage container" {
        $arguments = @{
            ResourceGroupName = $RESOURCE_GRP_NAME
            StorageAccountName = $STORAGE_ACCOUNT_NAME
            StorageContainerName = $STORAGE_CONTAINER_NAME
        }
        Set-BackendStorage @arguments

        Assert-MockCalled Set-StorageContainer -Times 1 -Scope It -ParameterFilter {
            $Name -eq $STORAGE_CONTAINER_NAME -and
            $StorageAccountName -eq $STORAGE_ACCOUNT_NAME
        }
    }
}
