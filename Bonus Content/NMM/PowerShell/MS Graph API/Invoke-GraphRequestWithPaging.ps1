function Invoke-GraphRequestWithPaging {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $false)]
        [hashtable]$Headers
    )

    # Initialize an array to store all results
    $allResults = [System.Collections.Generic.List[PSObject]]::new()

    do {
        Write-Verbose "Fetching data from URI: $Uri"

        try {
            # Invoke the Graph API request with or without headers based on the presence of $Headers
            if ($PSBoundParameters.ContainsKey('Headers')) {
                $response = Invoke-MgGraphRequest -Uri $Uri -OutputType PSObject -Headers $Headers
            }
            else {
                $response = Invoke-MgGraphRequest -Uri $Uri -OutputType PSObject
            }
        }
        catch {
            Write-Error "Failed to fetch data from $Uri. Error: $_"
            break
        }

        if ($response.value) {
            # Append the current page's items to the results
            $allResults.add($response.value)
            Write-Verbose "Retrieved $($response.value.Count) items."
        }
        else {
            Write-Verbose "No items found in the current response."
        }

        # Update the URI to the next page if available
        if ($response.'@odata.nextLink') {
            $Uri = $response.'@odata.nextLink'
        }
        else {
            $Uri = $null
        }

    } while ($Uri)

    return $allResults
}