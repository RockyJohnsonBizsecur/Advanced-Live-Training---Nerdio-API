function Get-AvdImageSkus {
    <#
    .SYNOPSIS
        Gets available Azure Virtual Desktop image SKUs or lists available Azure regions.

    .DESCRIPTION
        This function either retrieves available Azure Virtual Desktop (AVD) image SKUs from the Azure Marketplace 
        or lists all available Azure regions when using the -ListRegions parameter.

    .PARAMETER Publishers
        Array of publisher names to search. Defaults to MicrosoftWindowsDesktop.

    .PARAMETER Location
        The Azure region to search for images.

    .PARAMETER Offers
        Array of offer names to search. Defaults to office-365, windows-10, and windows-11.

    .PARAMETER AvdOnly
        Switch to filter results to only AVD-compatible images.

    .PARAMETER ListRegions
        Switch to list all available Azure regions.

    .EXAMPLE
        Get-AvdImageSkus -ListRegions

        Lists all available Azure regions.

    .EXAMPLE
        Get-AvdImageSkus -Location 'eastus'

        Gets all Windows Desktop images in East US region.

    .EXAMPLE
        Get-AvdImageSkus -Location 'westeurope' -AvdOnly

        Gets only AVD-compatible images in West Europe region.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Publishers = @('MicrosoftWindowsDesktop'),
        
        [Parameter()]
        [string]$Location,
        
        [Parameter()]
        [string[]]$Offers = @('office-365', 'windows-10', 'windows-11'),
        
        [Parameter()]
        [switch]$AvdOnly,

        [Parameter()]
        [switch]$ListRegions
    )

    begin {
        # Set a control variable
        $skipProcessing = $false
        
        # If ListRegions is specified, only show regions and return
        if ($ListRegions) {
            Write-Output "`nAvailable Azure Regions:"
            Get-AzLocation | Select-Object -ExpandProperty Location | Sort-Object | ForEach-Object {
                Write-Output "- $_"
            }
            $skipProcessing = $true
            return
        }
        # Only check Location parameter if not listing regions
        elseif (-not $Location) {
            throw "The -Location parameter is required when not using -ListRegions"
        }
    }

    process {
        if ($skipProcessing) { return }
        
        try {
            # Import Az module if not already imported
            if (-not (Get-Module -Name Az)) {
                Import-Module Az
            }

            # Check and establish Azure connection
            $context = Get-AzContext
            if (-not $context) {
                Write-Output "Not connected to Azure. Initiating connection..."
                Connect-AzAccount
                $context = Get-AzContext
                if (-not $context) {
                    throw "Failed to establish Azure connection."
                }
            }

            # Create a Generic List for better performance
            $imageList = [System.Collections.Generic.List[PSCustomObject]]::new()

            foreach ($publisher in $Publishers) {
                foreach ($offer in $Offers) {
                    Write-Verbose "Getting SKUs for Publisher: $publisher, Offer: $offer"
                    
                    $skus = Get-AzVMImageSku -Location $Location -PublisherName $publisher -Offer $offer -ErrorAction SilentlyContinue

                    if ($skus) {
                        $skus | ForEach-Object {
                            # Filter for AVD SKUs if AvdOnly switch is used
                            if (-not $AvdOnly -or ($_.Skus -match 'evd|avd')) {
                                $imageList.Add([PSCustomObject]@{
                                        Publisher = $publisher
                                        Offer     = $offer
                                        Sku       = $_.Skus
                                        Location  = $Location
                                    })
                            }
                        }
                    }
                }
            }

            # Output results
            Write-Output $imageList | Sort-Object Publisher, Offer, Sku

        }
        catch {
            Write-Error "Error getting AVD image SKUs: $_"
        }
    }
}

