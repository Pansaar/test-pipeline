# Authenticate using Managed Identity when running in Azure
if ($env:MSI_SECRET) {
    Disable-AzContextAutosave -Scope Process | Out-Null

    Connect-AzAccount -Identity
    
    Write-Host "Connected to Azure using Managed Identity"
}