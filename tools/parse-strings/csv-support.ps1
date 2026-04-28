###
#
#    Author: MaWCin (MaW/MrCin)
#    This code comes from repository https://github.com/mrcin-maw/ParseStrings
#    You can use it, redistribute and/or modify it under the terms of the GNU
#    General Public License as published by the Free Software Foundation,
#    either version 3 of the License, or (at your option) any later version.
# 
###

using namespace System.IO
using namespace System.Collections

function Check-IfCSVData ([string[]] $data_)
{
   [array] $line1 = (Find-Delimiter ($data_[0]) -showCount)
   [array] $line2 = (Find-Delimiter ($data_[1]) -showCount)

   return ( ([string]::IsNullOrEmpty($data_[0]) -ne $true) -and ([string]::IsNullOrEmpty($data_[1]) -ne $true) -and ($line1[0] -eq $line2[0]) -and ($line1[1] -eq $line2[1]) )

}

function Get-DelimiterName([char] $delimiter_)
{
    switch ($delimiter_)
    {
        ","  {"',' (comma)";break}
        ";"  {"';' (semicolon)";break}
        "|"  {"'|' (pipe)";break}
        "*"  {"'*' (asterix)";break}
        "`t" {"'___' (tabulation)";break}
        " "  {"' ' (space)";break}
    }
}
function Find-Delimiter([string] $firstLine_, [switch] $showCount=$false)
{
    [arraylist] $counter_ = @()
    [array] $delimiters = @(",",";","`t"," ")
    [int] $n_ = 0

    for ([int] $i=0; $i -lt $delimiters.Count;$i++)
    {
        #spaces may give a false positive
        if ($delimiters[$i] -ne ' ')
        {
            $n_ = ($firstLine_ -split $delimiters[$i]).Count
            $counter_.Add(@($n_,$i))|Out-Null
        }
        else
        {
            $counter_.Add(@(0,$i))|Out-Null
        }
    }
    #Write-host $($counter_ -join ",")
    if ([bool] $showCount -eq $true)
    {
        # Write-Host ($counter_|Sort-Object -Descending|select -First 1)
        return (@($delimiters[($counter_|Sort-Object -Descending|select -First 1)[1]],($counter_|Sort-Object -Descending|select -First 1)[0]))
    }
    return ($delimiters[($counter_|Sort-Object -Descending|select -First 1)[1]])
}
#endregion

#region CSV operations

#View data
function View-CSV ($source_,$title = "CSV Data")
{
    $source_|Out-GridView -Title $title
}
