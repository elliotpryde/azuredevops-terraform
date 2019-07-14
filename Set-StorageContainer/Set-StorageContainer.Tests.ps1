. ".\Invoke-Azure\Invoke-Azure.ps1"
. ".\Set-StorageContainer\Set-StorageContainer.ps1"

Describe "Set-StorageContainer" {

    It "should create a new storage account if one does not already exist" {
        Mock "Invoke-Azure" {
            if (
                $args -and
                $args[0] -eq "storage" -and
                $args[1] -eq "container" -and
                $args[2] -eq "exists"
            ) {
                return $false
            }
        }

        Set-StorageContainer -Name "storage_container" -StorageAccountName "storage_acc_name"

        Assert-MockCalled Invoke-Azure -Times 1 -Scope It -ParameterFilter {
            $args -and
            $args[0] -eq "storage" -and
            $args[1] -eq "container" -and
            $args[2] -eq "create"
        }
    }

    It "should not create a new storage account if one already exists" {
        Mock "Invoke-Azure" {
            if (
                $args -and
                $args[0] -eq "storage" -and
                $args[1] -eq "container" -and
                $args[2] -eq "exists"
            ) {
                return $true
            }
        }

        Set-StorageContainer -Name "storage_container" -StorageAccountName "storage_acc_name"

        Assert-MockCalled Invoke-Azure -Times 0 -Scope It -ParameterFilter {
            $args -and
            $args[0] -eq "storage" -and
            $args[1] -eq "container" -and
            $args[2] -eq "create"
        }
    }
}
