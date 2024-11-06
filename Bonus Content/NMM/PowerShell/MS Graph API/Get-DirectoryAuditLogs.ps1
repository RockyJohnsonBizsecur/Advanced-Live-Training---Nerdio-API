function Get-DirectoryAuditLogs {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]$DaysBack = 7,

        [Parameter()]
        [datetime]$StartTime,

        [Parameter()]
        [datetime]$EndTime = (Get-Date),

        [Parameter()]
        [int]$MaxResults = 1000
    )

    try {
        # If StartTime not specified, calculate from DaysBack
        if (-not $StartTime) {
            $StartTime = $EndTime.AddDays(-$DaysBack)
        }

        # Format dates for Graph API
        $startTimeUtc = $StartTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $endTimeUtc = $EndTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

        # Build query with time filter
        $filter = "activityDateTime ge $startTimeUtc and activityDateTime le $endTimeUtc"
        $select = "activityDateTime,activityDisplayName,result,initiatedBy,targetResources,additionalDetails,correlationId"
        $uri = "https://graph.microsoft.com/v1.0/auditLogs/directoryAudits?`$filter=$filter&`$select=$select&`$top=$MaxResults"

        $logs = Invoke-MgGraphRequest -Uri $uri -Method Get -OutputType PSObject

        # Process and format the results
        $logs.value | ForEach-Object {
            [PSCustomObject]@{
                Timestamp           = [datetime]$_.activityDateTime
                Activity           = $_.activityDisplayName
                Result            = $_.result
                InitiatedBy       = if ($_.initiatedBy.user.userPrincipalName) {
                    $_.initiatedBy.user.userPrincipalName
                } else {
                    $_.initiatedBy.app.displayName
                }
                InitiatorIpAddress = $_.initiatedBy.user.ipAddress
                TargetResource     = $_.targetResources.displayName -join ', '
                TargetType        = $_.targetResources.type -join ', '
                ModifiedProperties = ($_.targetResources.modifiedProperties | ForEach-Object {
                    "$($_.displayName): $($_.newValue)"
                }) -join '; '
                AdditionalDetails  = ($_.additionalDetails | ForEach-Object {
                    "$($_.key): $($_.value)"
                }) -join '; '
                CorrelationId     = $_.correlationId
            }
        }
    }
    catch {
        Write-Error "Error retrieving directory audit logs: $_"
    }
} 

# Get last 7 days of logs (default)
Get-DirectoryAuditLogs | Format-Table -AutoSize

# Get logs for specific date range
$start = (Get-Date).AddDays(-30)
$end = Get-Date
$result = Get-DirectoryAuditLogs -StartTime $start -EndTime $end -MaxResults 500

# Get last 24 hours of logs
$result = Get-DirectoryAuditLogs -DaysBack 1