function Get-AssignedRoleMembers {
    [CmdletBinding()]
    param()

    try {
        # Report on all users and their roles
        $roles = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/directoryRoles" -OutputType PSObject

        # Create a hashtable to store the user-role assignments
        $userRoles = @{}

        # Iterate over each role and get its members
        foreach ($role in $roles.value) {
            $roleId = $role.id
            $roleName = $role.displayName

            # Retrieve the members of the role
            $members = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/directoryRoles/$roleId/members" -OutputType PSObject

            # Iterate through the members
            foreach ($member in $members.value) {
                # Ensure member properties are not null
                $userPrincipalName = if ($member.userPrincipalName) { $member.userPrincipalName } else { "N/A" }
                $displayName = if ($member.displayName) { $member.displayName } else { "N/A" }
                $id = if ($member.id) { $member.id } else { "N/A" }

                if ($userRoles.ContainsKey($userPrincipalName)) {
                    # Append the role to the existing user's Roles list
                    $userRoles[$userPrincipalName].Roles.Add($roleName)
                }
                else {
                    # Create a new user object with their roles (using List for Roles)
                    $userRoles[$userPrincipalName] = [PSCustomObject]@{
                        UserPrincipalName = $userPrincipalName
                        DisplayName       = $displayName
                        Id                = $id
                        Roles             = [System.Collections.Generic.List[string]]::new()
                    }
                    $userRoles[$userPrincipalName].Roles.Add($roleName)
                }
            }
        }

        # Convert hashtable values to a list and format roles as a comma-separated string
        $roleAssignments = [System.Collections.Generic.List[PSObject]]::new()
        foreach ($user in $userRoles.Values) {
            $roleAssignments.Add([PSCustomObject]@{
                    UserPrincipalName = $user.UserPrincipalName
                    DisplayName       = $user.DisplayName
                    Id                = $user.Id
                    Roles             = ($user.Roles -join ", ")  # Convert list to a comma-separated string
                })
        }

        # Output the results
        if ($roleAssignments.Count -eq 0) {
            return [PSCustomObject]@{
                Info = "No role assignments found"
            }
        }
        else {
            return $roleAssignments
        }
    }
    catch {
        Write-Error "Error in Get-AssignedRoleMembers: $_"
    }
}