<#
    .SYNOPSIS
	
    .DESCRIPTION
	
    .PARAMETER

    .EXAMPLE
	
	.LINK
    https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Provisioning_API

#>
param (
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [String] $Key,

    [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
    [String] $Organization
)

begin
{
    $ApiVersion = 'v0'
    $BaseUrl = 'https://dashboard.meraki.com/api'
    $Headers = @{
        'X-Cisco-Meraki-API-Key' = $key
        'Content-Type' = 'application/json'
    }
    
    $Networks = @(
        @{
            'name' = 'NetLab Alderaan 1-3'
        },

        @{
            'name' = 'NetLab Alderaan 4-6'
        },

        @{
            'name' = 'NetLab Naboo 1-3'
        },
        
        @{
            'name' = 'NetLab Naboo 4-6'
        },

        @{
            'name' = 'NetLab Dagobah 1-3'
        },

        @{
            'name' = 'NetLab Dagobah 4-6'
        },

        @{
            'name' = 'NetLab Bespin 1-3'
        },

        @{
            'name' = 'NetLab Bespin 4-6'
        },

        @{
            'name' = 'NetLab Hoth 1-3'
        },

        @{
            'name' = 'NetLab Hoth 4-6'
        },

        @{
            'name' = 'NetLab Endor 1-3'
        },

        @{
            'name' = 'NetLab Endor 4-6'
        },

        @{
            'name' = 'NetLab Tatooine 1-3'
        },

        @{
            'name' = 'NetLab Tatooine 4-6'
        },

        @{
            'name' = 'NetLab Yavin 1-3'
        },

        @{
            'name' = 'NetLab Yavin 4-6'
        }
    )

    function Get-RedirectedUrl
    {
        # Get info about the organization to trigger a 302
        $Response = Invoke-WebRequest -Headers $Headers -Method Get -Uri "$BaseUrl/$ApiVersion/organizations/$Organization" -MaximumRedirection 0 -ErrorAction SilentlyContinue
        
        # If we get a 302, return the new URL. Else return the original $BaseUrl
        if ($Response.StatusCode -eq 302)
        {
            # Capture the URL, but not the version and organization
            # If the capture is successful, return it
            $Url = Select-String -Pattern "^(.*)/$ApiVersion/organizations/$Organization$" -InputObject ([String] $Response.Headers.Location)
            $RedirectedUrl = $Url.Matches.Groups[1].Value
            if ($RedirectedUrl)
            {
                return $RedirectedUrl
            }

            else 
            {
                return $BaseUrl
            }
        }

        else
        {
            return $BaseUrl
        }
    }

    function New-MerakiNetwork
    {
        param (
            [Parameter(Position = 0, Mandatory = $true)]
            [String] $Name,

            [Parameter(Position = 1, Mandatory = $true)]
            [ValidateSet('wireless', 'switch', 'appliance', 'phone')]
            [String] $Type
        )

        $Body = @{
            "name" = "$Name"
            "type" = "$type"
            "tags" = ''
            "timeZone" = 'America/New_York'
        }

        $Url = Get-RedirectedUrl
        $Results = Invoke-WebRequest -Headers $Headers -Method Post -Uri "$Url/$ApiVersion/organizations/$Organization/networks" -Body (ConvertTo-Json -InputObject $Body) -ErrorAction SilentlyContinue

        # Check to make sure an HTTP/201 was returned
        if ($Results.StatusCode -eq 201)
        {
            Write-Host -ForegroundColor Green "[Network] $Name successfully created"
        }

        else
        {
            Write-Host -ForegroundColor Red "[Network] ERROR: Cannot create network $Name. HTTP/$($Results.StatusCode)"   
        }

        # Sleep for .5 seconds
        Start-Sleep -Milliseconds 500
    }

    function Get-MerakiNetwork
    {
        param (
            [Parameter(Position = 0, Mandatory = $false)]
            [String] $Id
        )

        if ($Id)
        {
            $Results = Invoke-WebRequest -Headers $Headers -Method Get -Uri "$BaseUrl/$ApiVersion/networks/$Id"
            return (ConvertFrom-Json -InputObject $Results)
        }

        else
        {
            $Results = Invoke-WebRequest -Headers $Headers -Method Get -Uri "$BaseUrl/$ApiVersion/organizations/$Organization/networks"
            return (ConvertFrom-Json -InputObject $Results)
        }
    }

    function Remove-MerakiNetwork
    {
        param (
            [Parameter(Position = 0, Mandatory = $true)]
            [String] $Id
        )

        # Need the real URL for this, or else we get a 308
        $Url = Get-RedirectedUrl
        $Results = Invoke-WebRequest -Headers $Headers -Method Delete -Uri "$Url/$ApiVersion/networks/$Id" -ErrorAction SilentlyContinue

        # Check to make sure an HTTP/204 was returned
        if ($Results.StatusCode -eq 204)
        {
            Write-Host -ForegroundColor Green "[Network] $Id successfully removed"
        }

        else
        {
            Write-Host -ForegroundColor Red "[Network] ERROR: Cannot delete network $Id. HTTP/$($Results.StatusCode)"    
        }

        # Sleep for .5 seconds
        Start-Sleep -Milliseconds 500
    }

}

process
{
    # Remove all existing networks
    Get-MerakiNetwork | ForEach-Object {
        Remove-MerakiNetwork -Id $_.Id
    }

    # Create the new networks
    foreach ($Network in $Networks)
    {
        New-MerakiNetwork -Name $Network.name -Type 'switch'
    }
}