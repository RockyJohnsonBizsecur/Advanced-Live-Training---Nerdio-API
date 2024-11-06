![NerdioLogo](https://github.com/user-attachments/assets/972b8974-7317-4ed2-9347-e366f1829cb5)

# MS Graph API Examples

First, you need to connect to MS Graph using the Connect-MgGraphHelper function. This will open a browser window where you can login with your Microsoft account. And add the necessary permissions for the examples below.

```powershell
Connect-MgGraphHelper -tenantId 'your-tenant-id' -interactive
```

You can also connect using an app registration, this is recommended for headless automation.

After you've connected, you can use the following examples to interact with MS Graph.
Most examples use the Invoke-GraphRequestWithPaging function to handle paging for you.

## Get all users

```powershell
$allUsers = Invoke-GraphApiRequest -Uri 'https://graph.microsoft.com/v1.0/users'
```

## Get all users with assigned licenses

```powershell
$licensedUsers = Get-LicensedUsers
```

## Get all role assignments

```powershell
$roleAssignments = Get-AssignedRoleMembers
```

## Get directory audit logs

```powershell
# Get last 7 days of logs (default)
Get-DirectoryAuditLogs | Format-Table -AutoSize

# Get logs for specific date range
$start = (Get-Date).AddDays(-30)
$end = Get-Date
$auditLogs = Get-DirectoryAuditLogs -StartTime $start -EndTime $end -MaxResults 500

# Get last 24 hours of logs
$auditLogs = Get-DirectoryAuditLogs -DaysBack 1
```
