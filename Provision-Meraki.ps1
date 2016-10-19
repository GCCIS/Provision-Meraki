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
        'Content-Type' = 'application/json'}

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

        #Invoke-RestMethod -Headers $Headers -Method Post -Uri "$BaseUrl/$ApiVersion/organizations/$Organization/networks" -Body (ConvertTo-Json -InputObject $Body) -ContentType 'application/json'
        try {
            $Response = Invoke-WebRequest -Headers $Headers -Method Post -Uri "$BaseUrl/$ApiVersion/organizations/$Organization/networks" -Body (ConvertTo-Json -InputObject $Body) -ContentType 'application/json'
        }

        catch {
            $Error = $_.Exception
        }

        $Error.Response
        $Error.Message
    }

    function Remove-MerakiNetwork
    {

    }

}

process
{
    # Test the function
    New-MerakiNetwork -Name 'TestNet' -Type 'switch'
}