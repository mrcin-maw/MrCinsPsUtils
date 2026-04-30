# MrCinsPsUtils

Repozytorium na wiele narzędzi/użytków PowerShell.

## Struktura

- `tools/parse-strings/` – podprojekt z funkcjami do parsowania stringów i pracy z CSV.
  - `Parse-StringToTimeValue.ps1`
  - `csv-support.ps1`
- `tools/replace-cases/` – podprojekt do normalizacji tekstu i zamiany znaków diakrytycznych.
  - `Replace-Cases.ps1`
  - `casedata.csv`
  - `specialcharsdata.csv`
- `wiki/` – materiały pomocnicze.

## Podprojekt: parse-strings

### `Parse-StringToTimeValue.ps1`
Udostępnia funkcję:

- `Parse-StringToTimeValue ([string] $value, [switch] $returnString = $false)`

Funkcja parsuje wartość tekstową do czasu (`HH:mm:ss`).
Akceptuje różne formaty wejściowe, m.in.:

- ciąg cyfr (np. `93015`, `123045`)
- fragmenty rozdzielone znakami nienumerycznymi (np. `9:30`, `12-30-45`)

Domyślnie zwraca obiekt `[DateTime]`.
Po użyciu przełącznika `-returnString` zwraca tekst w formacie `HH:mm:ss`.

### `csv-support.ps1`
Udostępnia funkcje pomocnicze do pracy z CSV:

- `Check-IfCSVData` – sprawdza, czy dwie pierwsze linie wyglądają jak poprawne dane CSV.
- `Find-Delimiter` – próbuje wykryć separator (`,`, `;`, tabulator, spacja).
- `Get-DelimiterName` – zwraca nazwę separatora.
- `View-CSV` – wyświetla dane w `Out-GridView`.

## Podprojekt: replace-cases

### `Replace-Cases.ps1`
Udostępnia funkcję:

- `Replace-Cases ([string] $sourcestring, [-replaceSpecialChars] [-dontTouchSpaces] [-trim [<trimSeparators>]] [-reloadTable])`

Funkcja normalizuje tekst poprzez:

- zamianę znaków diakrytycznych i narodowych na odpowiedniki ASCII,
- opcjonalną zamianę znaków specjalnych,
- opcjonalne usuwanie zduplikowanych separatorów.

## Użycie

```powershell
. ./tools/parse-strings/Parse-StringToTimeValue.ps1
. ./tools/parse-strings/csv-support.ps1
. ./tools/replace-cases/Replace-Cases.ps1
```

Następnie można wywoływać funkcje bezpośrednio w bieżącej sesji PowerShell.
