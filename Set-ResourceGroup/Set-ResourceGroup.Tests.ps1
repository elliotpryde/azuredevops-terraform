. ".\Set-ResourceGroup\Set-ResourceGroup.ps1"

Describe "Set-ResourceGroup" {

    It "should not create a resource group if one already exists" {
        Mock "Invoke-Azure" {
            if ($args -and $args[0] -eq "group" -and $args[1] -eq "exists") {
                return $true
            }
        }

        Set-ResourceGroup -Name "resource_grp_name"

        Assert-MockCalled Invoke-Azure -Times 0 -ParameterFilter {$args -and $args[0] -eq "group" -and $args[1] -eq "create"}
    }

    It "should create a resource group if it doesn't already exist" {
        Mock "Invoke-Azure" {
            if ($args -and $args[0] -eq "group" -and $args[1] -eq "exists") {
                return $false
            }
        }

        Set-ResourceGroup -Name "resource_grp_name"

        Assert-MockCalled Invoke-Azure -Times 1 -ParameterFilter {$args -and $args[0] -eq "group" -and $args[1] -eq "create"}
    }
}
