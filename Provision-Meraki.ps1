<#
	.SYNOPSIS
	
    .DESCRIPTION
	
    .PARAMETER

    .EXAMPLE
	
	.LINK

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
    $Headers = @{'X-Cisco-Meraki-API-Key' = $key}

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

        Invoke-WebRequest -Headers $Headers -Method Post -Uri "$BaseUrl/$ApiVersion/organizations/$Organization/networks" -Body $Body
    }

    function Remove-MerakiNetwork
    {

    }

}

process
{
    # Test the function
    New-MerakiNetwork -Name 'Test_Net' -Type 'switch'
}