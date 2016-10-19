<#
	.SYNOPSIS
	
    .DESCRIPTION
	
    .PARAMETER

    .EXAMPLE
	
	.LINK

#>
param (
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty]
    [String] $Key,

    [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
    [ValidateNotNullOrEmpty]
    [String] $Organization
)

begin
{
    $Api = 'v0'
    $BaseUrl = 'https://dashboard.meraki.com'
    $Headers = @{"X-Cisco-Meraki-API-Key"="$key"}

    function New-MerakiNetwork
    {
        param (
            [Parameter(Position = 0, Mandatory = $true)]
            [String] $Name
        )

        Invoke-WebRequest -Headers $Headers -Method Post -Uri "$BaseUrl/$Api/$Organization/networks"
    }

    function Remove-MerakiNetwork
    {

    }

}

process
{
    
}