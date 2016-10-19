<#
	.SYNOPSIS
	
	.DESCRIPTION
	
	.PARAMETER Name

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

}

process
{
    
}