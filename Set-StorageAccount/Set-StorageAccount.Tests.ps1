. ".\Set-StorageAccount\Set-StorageAccount.ps1"

Describe "Set-StorageAccount" {

    Context "if the storage account name is not available and the reason is not AlreadyExists" {

        It "should throw an exception" {
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
                $arguments = @{
                    Name = "storage_account_name"
                    ResourceGroupName = "resource_grp_name"
                }
                Set-StorageAccount @arguments
            } | Should Throw "Could not create storage account because:"
        }
    }

    Context "if the storage account name is not available and the reason is AlreadyExists" {

        Mock "Invoke-Azure" {
            if (
                $args -and
                $args[0] -eq "storage" -and
                $args[1] -eq "account" -and
                $args[2] -eq "check-name"
            ) {
                return @"
                {
                    "nameAvailable": false,
                    "reason": "AlreadyExists"
                }
"@
            }
        }

        It "should not create a new storage account" {
            $arguments = @{
                Name = "storage_account_name"
                ResourceGroupName = "resource_grp_name"
            }
            Set-StorageAccount @arguments

            Assert-MockCalled Invoke-Azure -Times 0 -Scope It -ParameterFilter {
                $args -and
                $args[0] -eq "storage" -and
                $args[1] -eq "account" -and
                $args[2] -eq "create"
            }
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
                $arguments = @{
                    Name = "storage_account_name"
                    ResourceGroupName = "resource_grp_name"
                }
                Set-StorageAccount @arguments
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

            $arguments = @{
                Name = "storage_account_name"
                ResourceGroupName = "resource_grp_name"
            }
            Set-StorageAccount @arguments

            Assert-MockCalled Invoke-Azure -Times 1 -Scope It -ParameterFilter {
                $args -and
                $args[0] -eq "storage" -and
                $args[1] -eq "account"
                $args[2] -eq "create"
            }
        }
    }
}
