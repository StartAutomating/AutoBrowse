function Set-BrowserControl
{
    <#
    .Synopsis
        Sets a value in a browser control
    .Description
        Sets the value of a control in a browser, and fires an On_Change event
    .Link
        Get-BrowserControl
    #>
    [CmdletBinding(DefaultParameterSetName='Id')]
    [OutputType([PSObject])]
    param(
    # The Browser Object.
    [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
    [ValidateScript({
        if ($_.psobject.typenames -notcontains 'System.__ComObject' -and -not $_.Quit) {
            throw "Not IE"
        }
        $true
    })]
    $IE,

    # Sets a series of values to specific IDs
    [Parameter(Mandatory=$true, ParameterSetName='Table')]
    [Hashtable]
    $Hashtable,    
    
    # The ID of the object within the page    
    [Parameter(Mandatory=$true, ParameterSetName='ById')]
    [string]$Id,
    # The name of the object within the page
    [Parameter(Mandatory=$true, ParameterSetName='ByName')]
    [string]$Name,
    # The tag name of the object within the page
    [Parameter(Mandatory=$true, ParameterSetName='ByTagName')]
    [string]$TagName,
    
    # The value to set
    [string]$Value
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'Table') {
            foreach ($kv in $Hashtable.GetEnumerator()) {
                $idMatch = Get-BrowserControl -ie $ie -Id $kv.Key
                if (-not $IdMatch) {
                    $nameMatch = Get-BrowserControl -ie $ie -Name $kv.Key
                    if ($nameMatch) {
                        foreach ($nm in $nameMatch) {
                            if ($nm.psobject.properties["Value"]) {
                                $nm.Value = $kv.Value
                            } elseif ($nm.psobject.properties["InnerText"]) {
                                $nm.InnerText = $kv.Value
                            }
                            
                        }
                    }
                } else {
                    $idMatch.Value = $kv.Value
                }
                
                
            }
        } else {
            $null = $psBoundParameters.Remove("Value")
            Get-BrowserControl @psBoundParameters |
                ForEach-Object {
                    if ($_.psobject.properties["Value"]) {
                        $_.Value = $value
                    } elseif ($_.psobject.properties["InnerText"])  {
                        $_.InnerText = $value
                    }
                    
                    $null = $_.FireEvent("onchange", $null)
                }
           
        } 
        $ie
    }
}