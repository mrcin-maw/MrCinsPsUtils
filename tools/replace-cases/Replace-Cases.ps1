using namespace System.Collections;

<#
.SYNOPSIS
    Replace-Cases v1.6 – Normalizes text by replacing diacritics and special characters.

.DESCRIPTION
    Powerful text normalization function that:
    - Replaces national and diacritical characters with ASCII equivalents.
    - Optionally replaces special characters.
    - Optionally trims duplicated separators.
    
    Uses tab-separated CSV data files:
    - casedata.csv: mappings for diacritical characters.
    - specialcharsdata.csv: mappings for special characters.

.PARAMETER sourcestring
    [Position 0] The input text to normalize.
    
.PARAMETER replaceSpecialChars
    [switch] Use special character mappings instead of diacritical mappings.
    
.PARAMETER dontTouchSpaces
    [switch] When used with -replaceSpecialChars, preserves spaces unchanged.
    
.PARAMETER trim
    [switch] Enables separator trimming logic. If no separators provided, defaults to space.
    
.PARAMETER trimSeparators
    [Position 1] [ArrayList] Array of separator characters for trim logic.
    First element is treated as the "key character" (primary separator).
    Remaining elements are normalized around it.
    
.PARAMETER reloadTable
    [switch] Forces reload of CSV data on each function call.
    Without it, data loads once on first execution (cached in module scope).

.EXAMPLE
    Replace-Cases "Zażółć gęślą jaźń"
    # Output: Zazoulc gesla jazn

.EXAMPLE
    Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -trim @("-"," ","_")
    # Output: Ala-ta zoulta krouwa-ma_kota, a kot ma_wywalone.

.NOTES
    Version: 1.6
    Author: MrCin
    Encoding: UTF-8
#>

[psobject] $script:caseReplacementTable = @{};
[psobject] $script:specialCasesReplacementTable = @{};

[string] $script:casesdatafile = "$PSScriptRoot\casedata.csv";
[string] $script:specialcasesdatafile = "$PSScriptRoot\specialcharsdata.csv";

function Replace-Cases
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory = $true)] [string] $sourcestring,
        [switch] $replaceSpecialChars = $false,
        [switch] $dontTouchSpaces = $false,
        [switch] $trim = $false,
        [Parameter(Position = 1)] [ArrayList] $trimSeparators = $null,
        [switch] $reloadTable = $false
    );

    if (($script:caseReplacementTable.Count -eq 0) -or ($reloadTable -eq $true))
    {
        Invoke-ReplacementDataLoad;
    };

    [char[]] $sourcechars_ = [char[]]$sourcestring;
    [ArrayList] $result_ = @(,""*$sourcechars_.Count);
    [psobject] $replacementTable_ = @{};
    
    [char] $trimkeychar_ = " ";
    [char] $character_ = $null;
    [char] $nextchar_ = $null;
    [int] $trimpos_ = -1;
    [psobject] $trimlist_ = @{};
    [bool] $trimmed_ = $false;

    if ($replaceSpecialChars -eq $true)
    {
        $replacementTable_ = $script:specialCasesReplacementTable;
    }
    else
    {
        $replacementTable_ = $script:caseReplacementTable;
    };

    if ($trim.ToBool() -eq $true)
    {
        if ($trimSeparators -eq $null)
        {
            $trimSeparators = @(" ");
        };
    };

    for ([int] $i = 0; $i -lt $sourcechars_.Length; $i++)
    {
        if (
            (($replacementTable_["$($sourcechars_[$i])"].Count) -eq 0) `
            -or (($dontTouchSpaces.ToBool() -eq $true) -and ($sourcechars_[$i] -eq " "))
        )
        {
            $result_[$i] = $sourcechars_[$i];
        }
        else
        {
            $result_[$i] = "$(($replacementTable_["$($sourcechars_[$i])"]).char)";
        };
    };

    $result_ = [char[]] ($result_ -join "");

    if ($trimSeparators.Count -eq 0) 
    {
        return ($result_ -join "");
    };

    $trimkeychar_ = $trimSeparators[0];
    $trimpos_ = 0;

    # Build trim characters lookup table.
    [int] $i = 0;
    do
    {
        $trimlist_[$trimSeparators[$i]] = $true;
        
        # Remove trim chars from start or end.
        do
        {
            $trimmed_ = $false;
            
            if ($result_[0] -eq $trimSeparators[$i])
            {
                $result_.RemoveAt(0);
                $trimmed_ = $true;
            };
            
            if ($result_[$result_.Count-1] -eq $trimSeparators[$i])
            {
                $result_.RemoveAt($result_.Count-1);
                $trimmed_ = $true;
            };
        } while ($trimmed_);

        $i++;

    } while ($i -lt $trimSeparators.Count);

    # Process middle duplicates: consecutive separators.
    $i = 0;
    do
    {
        $character_ = $result_[$i];
        $nextchar_ = $result_[$i+1];
        
        if ($trimlist_["$character_"] -eq $true)
        {
            if ($trimlist_["$nextchar_"])
            {
                if(("$character_" -eq "$trimkeychar_") -or ("$nextchar_" -eq "$trimkeychar_"))
                {
                    $result_[$i] = $trimkeychar_;
                };
                
                $result_.RemoveAt($i+1);
                $i-=1;
            };
        };

        $i++;

    } while ($i -lt $result_.Count);

    return ($result_ -join "");
};

function Invoke-ReplacementDataLoad
{
    [CmdletBinding()]
    param();

    [string[]] $casesdata_ = @();
    [string[]] $row_ = @("char","ALT CODE","letter");

    # Load regional character data.
    if (Test-Path $script:casesdatafile -PathType Leaf)
    {
        $casesdata_ = Get-Content $script:casesdatafile -Encoding UTF8;
    };
    
    $casesdata_ | ForEach-Object
    {
        $row_ = $_.Split("`t");
        
        if (($row_[0]).Length -eq 1)
        {
            $script:caseReplacementTable["$($row_[0])"] = @{ALT = $row_[1]; char = $row_[2]};
        };
    };

    # Load special characters data.
    if (Test-Path $script:specialcasesdatafile -PathType Leaf)
    {
        $casesdata_ = Get-Content $script:specialcasesdatafile -Encoding UTF8;
    };
    
    $casesdata_ | ForEach-Object
    {
        $row_ = $_.Split("`t");
        
        if (($row_[0]).Length -eq 1)
        {
            $script:specialCasesReplacementTable["$($row_[0])"] = @{ALT = $row_[1]; char = $row_[2]};
        };
    };
};

Write-Host "## Replace-Cases v1.6 loaded ##" -ForegroundColor Cyan;
