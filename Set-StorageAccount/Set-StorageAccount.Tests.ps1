. ".\Set-StorageAccount\Set-StorageAccount.ps1"

Describe "Set-StorageAccount" {

    Context "if the storage account name is not available" {

        It "should throw an exception if the reason is not AlreadyExists" {
            Mock "Invoke-Azure" {
                if (
                    $args -and
                    $args[0] -eq "storage" -and
                    $args[1] -eq "account" -and
                    $args[2] -eq "check-name"
                ) {
                    return @"
                    {
                        "nameAvailable": "false",
                        "reason": "AnotherReason"
                    }
"@
                }
            }

            {
                Set-StorageAccount -Name "storage_account_name" -ResourceGroupName "resource_grp_name"
            } | Should Throw "Could not create storage account because:"
        }

        It "should not throw an exception if the reason is AlreadyExists" {
            Mock "Invoke-Azure" {
                if (
                    $args -and
                    $args[0] -eq "storage" -and
                    $args[1] -eq "account" -and
                    $args[2] -eq "check-name"
                ) {
                    return @"
                    {
                        "nameAvailable": "false",
                        "reason": "AlreadyExists"
                    }
"@
                }
            }

            {
                Set-StorageAccount -Name "storage_account_name" -ResourceGroupName "resource_grp_name"
            } | Should Not Throw

        }
    }

    Context "if the storage account name is available" {

        It "should create a new storage account" {
            Mock "Invoke-Azure" {
                if (
                    $args -and
                    $args[0] -eq "storage" -and
                    $args[1] -eq "account" -and
                    $args[2] -eq "check-name"
                ) {
                    return @"
                    {
                        "nameAvailable": "true"
                    }
"@
                }
            }

            Set-StorageAccount -Name "storage_account_name" -ResourceGroupName "resource_grp_name"

            Assert-MockCalled Invoke-Azure -ParameterFilter {
                $args -and
                $args[0] -eq "storage" -and
                $args[1] -eq "account"
                $args[2] -eq "create"
            }
        }
    }
}
