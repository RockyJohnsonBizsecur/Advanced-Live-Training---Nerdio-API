![NerdioLogo](https://github.com/user-attachments/assets/972b8974-7317-4ed2-9347-e366f1829cb5)

# Examples

## Connect-NMMApi

This function is used to connect to your NMM instance. It will set the `$global:cachedToken` variable, which can be used in other functions, within your current PowerShell session.

```powershell
$tokenParams = @{
    BaseUri  = 'https://urlofyournmminstallation.azurewebsites.net/' #Or fill out the base URI as a string
    TenantId = 'tenantidofyournmminstallation' #Or fill out the tenant ID as a string
    ClientId = 'clientidofyournmminstallation' #Or fill out the client ID as a string
    Scope    = 'scopeofyournmminstallation' #Or fill out the scope as a string
    Secret  = 'secretofyournmminstallation' #Or fill out the secret as a string
}

Connect-NMMApi @tokenParams
```

This will set the `$global:cachedToken` variable, which can be used in other functions, within your current PowerShell session.

## Invoke-ApiRequest

The Invoke-ApiRequest function is used to make API requests to the NMM API more easily. It will return the response from the API as a PowerShell object. And supports all types of filters and parameters that the NMM API supports.

### Get a list of all accounts in NMM

```powershell
Invoke-ApiRequest -Method 'GET' -Endpoint 'accounts'
```

### Get a list of all Vulnerabilities

```powershell
Invoke-ApiRequest -Method 'GET' -Endpoint 'vulnerabilities'
```

### Get a list of all Directories for a specific Account

```powershell
Invoke-ApiRequest -Method 'GET' -Endpoint 'accounts/{accountId}/directories'
```
### Get all Hostpools for a specific Account

```powershell
Invoke-ApiRequest -Method 'GET' -Endpoint 'accounts/{accountId}/host-pool'
```
### Get all desktop images for a specific Account

```powershell
Invoke-ApiRequest -Method 'GET' -Endpoint 'accounts/{accountId}/desktop-image'
```
### Get details of a specific desktop image

```powershell
Invoke-ApiRequest -Method 'GET' -Endpoint 'accounts/{accountId}/desktop-image/{subscriptionId}/{resourceGroup}/{name}'
#Example: Invoke-ApiRequest -Method 'GET' -Endpoint 'accounts/67/desktop-image/da1a2fbb-3c08-48dc-bef8-2edabdc08f3f/nmm-salesdemos-winhart/Golden-UK-EMEA'
```