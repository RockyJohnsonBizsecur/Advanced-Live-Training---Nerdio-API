function Get-LicensedUsers {
    [CmdletBinding()]
    param ()
    
    try {
        # Initialize cache for license details
        $script:licenseCache = $null
        
        function Get-MsLicenseDetails {
            if (-not $script:licenseCache) {
                $csvUrl = "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv"
                try {
                    $csvContent = Invoke-RestMethod -Uri $csvUrl -Method Get
                    $script:licenseCache = $csvContent | ConvertFrom-Csv
                }
                catch {
                    Write-Warning "Failed to fetch license details: $_"
                    return $null
                }
            }
            return $script:licenseCache
        }

        function Get-FriendlyLicenseName {
            param ([string]$licenseId)
            
            $licenseDetails = Get-MsLicenseDetails
            $matchedLicense = $licenseDetails | Where-Object { $_.GUID -eq $licenseId } | Select-Object -First 1
            
            if ($matchedLicense) {
                return $matchedLicense.Product_Display_Name
            }
            return $licenseId
        }

        # Get all users with assigned licenses
        $selectedProperties = @(
            "displayName",
            "givenName",
            "surname",
            "department",
            "jobTitle",
            "mail",
            "officeLocation",
            "preferredLanguage",
            "userPrincipalName",
            "id",
            "assignedLicenses"
        ) -join ','

        $headers = @{
            'ConsistencyLevel' = 'eventual'
        }

        # Get all users with assigned licenses
        $users = Invoke-GraphRequestWithPaging -Uri "https://graph.microsoft.com/v1.0/users?`$filter=assignedLicenses/`$count ne 0&`$count=true&`$select=$selectedProperties" -Headers $headers
        
        $users | ForEach-Object {
            $friendlyNames = $_.assignedLicenses.skuId | ForEach-Object {
                Get-FriendlyLicenseName -licenseId $_
            }
            
            [PSCustomObject]@{
                DisplayName       = $_.displayName
                UserPrincipalName = $_.userPrincipalName
                Email            = $_.mail
                Licenses         = $friendlyNames -join ', '
            }
        }
    }
    catch {
        Write-Error "Error retrieving licensed users: $_"
    }
}