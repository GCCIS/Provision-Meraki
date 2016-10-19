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

    function Get-OrganizationUrl
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

        Get-OrganizationUrl
        #$Response = Invoke-WebRequest -Headers $Headers -Method Post -Uri "$BaseUrl/$ApiVersion/organizations/$Organization/networks" -Body (ConvertTo-Json -InputObject $Body)
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