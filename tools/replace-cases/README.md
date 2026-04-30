# Replace-Cases v1.6

PowerShell function for normalizing text:
- Replacing diacritics/national characters with ASCII equivalents.
- Optionally replacing special characters.
- Optionally trimming duplicated separators.

## Files

- `Replace-Cases.ps1` – Contains `Replace-Cases` and `Invoke-ReplacementDataLoad` functions.
- `casedata.csv` – Mapping for 481 diacritical/national characters.
- `specialcharsdata.csv` – Mapping for special characters.

> **Note:** Both mapping files are tab-separated (`TSV`) even though they use `.csv` extension.

## Usage

```powershell
Replace-Cases "<text>" `
  [-replaceSpecialChars] `
  [-dontTouchSpaces] `
  [-trim [<trimSeparators>]] `
  [-reloadTable]
```

## Parameters

- **replaceSpecialChars** [switch]  
  Uses mappings from `specialcharsdata.csv` instead of `casedata.csv`.

- **dontTouchSpaces** [switch]  
  Works with `-replaceSpecialChars`; keeps spaces unchanged.

- **trim** [switch]  
  Enables separator trimming logic.  
  If no separators are provided, a single space (`" "`) is used.

- **trimSeparators** [ArrayList] (position 1)  
  Array of separators used by trim logic.  
  First element is treated as the leading separator ("key char"), remaining elements are normalized around it.

- **reloadTable** [switch]  
  Reloads mapping files on each call.  
  Without it, data is loaded once (on first function execution).

## Quick Start

```powershell
. .\Replace-Cases.ps1

Replace-Cases "Zażółć gęślą jaźń"
# Output: Zazoulc gesla jazn
```

## Examples

```powershell
# Basic diacritical replacement
Replace-Cases "Zażółć gęślą jaźń"
# Output: Zazoulc gesla jazn

# Without special trimming
Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._"
# Output: Ala - ta zoulta krouwa - ma_kota, a  kot _ma_ wywalone._

# Replace diacritics + replace special chars
Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -replaceSpecialChars
# Output: __Ala_-_ta_żółta_krówa_-_ma_kota_a__kot__ma__wywalone_

# Chain: first diacritics, then special chars
Replace-Cases (Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._") -replaceSpecialChars
# Output: __Ala_-_ta_zoulta_krouwa_-_ma_kota_a__kot__ma__wywalone_

# Simple trim (reduce spaces to single)
Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -trim
# Output: Ala - ta zoulta krouwa - ma_kota, a kot _ma_ wywalone._

# Trim with custom separators (- as key, remove extra - and spaces and _)
Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -trim @("-"," ","_")
# Output: Ala-ta zoulta krouwa-ma_kota, a kot ma_wywalone.

# Replace special + trim with separators
Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -replaceSpecialChars -trim @("-"," ","_")
# Output: Ala-ta_żółta_krówa-ma_kota_a_kot_ma_wywalone

# Replace special + trim + preserve spaces
Replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -replaceSpecialChars -trim @("-"," ","_") -dontTouchSpaces
# Output: Ala-ta żółta krówa-ma_kota a kot ma_wywalone
```

## Version History

- **v1.6** – Added trim connector space handling; refactored to PowerShell 5.1 standards.
