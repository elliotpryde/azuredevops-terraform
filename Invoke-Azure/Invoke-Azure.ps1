function Invoke-Azure {
    & az $args
    $AzureExitCode = $LastExitCode
    if ($AzureExitCode -ne 0) {
        throw "The Azure CLI returned a non-zero exit code ($AzureExitCode) when running {az $args}: $AzureExitCode"
    }
}
