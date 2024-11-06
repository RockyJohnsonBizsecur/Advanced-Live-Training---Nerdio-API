![image](https://github.com/Get-Nerdio/NMM-SE/assets/52416805/5c8dd05e-84a7-49f9-8218-64412fdaffaf)

# Set Autoscale Settings

Below is an example powershell snippet of how to set the autoscale settings for a hostpool.


```powershell
# Example scaling triggers
$scalingTriggers = [System.Collections.Generic.List[hashtable]]::new()

# CPU Usage trigger
$scalingTriggers.Add(@{
    triggerType = "CPUUsage"
    cpu = @{
        scaleOut = @{
            averageTimeRangeInMinutes = 5
            hostChangeCount = 1
            value = 65
        }
        scaleIn = @{
            averageTimeRangeInMinutes = 15
            hostChangeCount = 1
            value = 40
        }
    }
})

# VM Template
$vmTemplate = @{
    prefix             = "API{###}"
    size               = "Standard_D2s_v3"
    image              = "MicrosoftWindowsDesktop/Windows-11/win11-22h2-avd/latest"
    storageType        = "StandardSSD_LRS"
    resourceGroupId    = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ExampleRG"
    networkId          = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ExampleRG/providers/Microsoft.Network/virtualNetworks/ExampleVnet"
    diskSize           = 128
    hasEphemeralOSDisk = $false
}

# Set autoscale configuration
$autoScaleParams = @{
    AccountId            = "12345"
    SubscriptionId       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ResourceGroup        = "ExampleRG"
    PoolName             = "Example-Hostpool"
    EnableAutoScale      = $false
    ScalingMode          = "Default"
    VmTemplate           = $vmTemplate
    HostPoolCapacity     = 1
    MinActiveHostsCount  = 0
    BurstCapacity        = 0
    ScalingTriggers      = $scalingTriggers
    Verbose              = $true
}

Set-AutoScale @autoScaleParams

```
## Some other trigger examples are below.

If you want to use a different trigger then modify the trigger type in the code example above.
Also for the image sku, select one from the list of available image SKUs examples below.

### User Driven trigger

```powershell
# User Driven trigger
$scalingTriggers.Add(@{
    triggerType = "UserDriven"
    userDriven = @{
        scaleOut = @{
            hostChangeCount = 1
            value = 2
        }
        scaleIn = @{
            hostChangeCount = 1
            value = 1
        }
    }
})
```

### AvgActiveSessions trigger example

```powershell
$scalingTriggers.Add(@{
    triggerType = "AvgActiveSessions"
    averageActiveSessions = @{
        scaleOut = @{
            hostChangeCount = 1
            value = 10
        }
        scaleIn = @{
            hostChangeCount = 1
            value = 5
        }
    }
})
```

## List of available image SKUs

There are much more sku's available, but these are the most common ones.

- win10-22h2-avd-m365
- win10-22h2-avd-m365
- win10-22h2-avd-m365-g2
- win10-22h2-avd-m365-g2
- win11-21h2-avd-m365
- win11-21h2-avd-m365
- win11-22h2-avd-m365
- win11-22h2-avd-m365
- win11-23h2-avd-m365
- win11-23h2-avd-m365
- win11-24h2-avd-m365
- win11-24h2-avd-m365
- 21h1-evd-g2
- 21h1-evd-g2
- win10-22h2-avd
- win10-22h2-avd
- win10-22h2-avd-g2
- win10-22h2-avd-g2
- win11-21h2-avd
- win11-21h2-avd
- win11-22h2-avd
- win11-22h2-avd
- win11-23h2-avd
- win11-23h2-avd
- win11-24h2-avd
- win11-24h2-avd
