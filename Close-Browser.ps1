function Close-Browser { 
    <#
    .Synopsis
        Closes a running autobrowser
    .Description
        Quits an InternetExplorer AutoBrowser.
    .Example
        Open-Browser -Visible -Url http://start-automating.com/ | Close-Browser
    .Link
        Open-Browser
    .Link
        Wait-Browser
    #> 
    [OutputType([Nullable])]
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
    $IE
    )
    process {
        #region Close the IE Object
        
        # Variable sleight of hand.  If $ie is assigned to null directly, it becomes invalid and the browser never really quits
        $ieObject = $ie#.Quit()
        $ieObject.Quit()
        $ieObject = $null        
        
        #endregion
    
    }
}