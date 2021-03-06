function Open-Browser
{
    <#
    .Synopsis
        Opens a new Browser
    .Description
        Opens a new Browser for automated browsing
    .Example
        Open-Browser
    .Example
        Open-Browser -Visible
    .Example
        Open-Browser -Url http://start-automating.com/                 
    .Link
        Close-Browser
    .Link
        Wait-Browser
    #>
    [OutputType([PSObject])]
    param(        
    # The URL to visit     
    [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][Uri]$Url,
    
    # The timeout to wait for the page to reload after an action 
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Timespan]$Timeout = "0:0:30",
    
    # The timeout to sleep in between each check to see if the page has reloaded
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Timespan]$SleepTime = "0:0:0.01",
            
    # If set, will not wait for the page to load
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [switch]$DoNotWait,
    
    # If set, the browser will be visible
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Switch]$Visible
    )
    
    process {
#        if ($env:PROCESSOR_ARCHITECTURE -eq 'x86') {        
            $ie = New-Object -ComObject InternetExplorer.Application
        <#} else {
            Start-Job -RunAs32 -ScriptBlock {
                New-Object -ComObject InternetExplorer.Application
            } | Wait-Job | Out-Null
            
            $ie = Get-Browser | 
                Where-Object { -not $_.LocationName -and -not $_.LocationUrl } |
                Select-Object -First 1 
        }#>
        $ie.Visible = $visible
        $null = $psBoundParameters.Remove('Visible')
        if ($psBoundParameters.ContainsKey("url")) {
            $ie | Set-BrowserLocation @psBoundParameters            
        } else {        
            $ie 
        }
    }
}