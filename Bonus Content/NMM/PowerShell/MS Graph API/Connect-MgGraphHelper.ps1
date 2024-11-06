function Connect-MgGraphHelper {
    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    param (
        # Associate tenantId with both parameter sets
        [Parameter(Mandatory = $true, ParameterSetName = 'AppRegistration')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Interactive')]
        [string]$tenantId,

        [Parameter(Mandatory = $true, ParameterSetName = 'AppRegistration')]
        [string]$clientId,

        [Parameter(Mandatory = $true, ParameterSetName = 'AppRegistration')]
        [string]$clientSecret,

        [Parameter(Mandatory = $false, ParameterSetName = 'Interactive')]
        [switch]$interactive
    )

    begin {
        try {
            if ($PSCmdlet.ParameterSetName -eq 'AppRegistration') {
                # Validate required parameters for App Registration
                if (-not ($clientId -and $clientSecret)) {
                    throw "For App Registration authentication, -clientId and -clientSecret must be provided."
                }

                # Convert client secret to secure string
                $secureSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
                $credential = New-Object System.Management.Automation.PSCredential ($clientId, $secureSecret)

                # Connect to Microsoft Graph using App Registration
                Connect-MgGraph -NoWelcome -ClientSecretCredential $credential -TenantId $tenantId
                Write-Output "Connected to Microsoft Graph using App Registration."
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'Interactive') {
                # Connect to Microsoft Graph using interactive browser session
                $params = @{
                    Scopes   = @(
                        "Reports.Read.All",
                        "ReportSettings.Read.All",
                        "User.Read.All",
                        "Group.Read.All",
                        "Mail.Read",
                        "Mail.Send",
                        "Calendars.Read",
                        "Sites.Read.All",
                        "Directory.Read.All",
                        "RoleManagement.Read.Directory",
                        "AuditLog.Read.All",
                        "Organization.Read.All"
                    )
                    TenantId = $tenantId
                }
                Connect-MgGraph @params

                Write-Output "Connected to Microsoft Graph using interactive browser session."
            }
            else {
                throw "Please specify an authentication method: either provide -clientId, -clientSecret, and -tenantId for App Registration or use the -interactive switch for interactive login."
            }
        }
        catch {
            Write-Error "Failed to connect to Microsoft Graph: $_"
        }
    }
}