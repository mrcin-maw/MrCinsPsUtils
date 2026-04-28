# MrCinsPsUtils

Repozytorium na wiele narzędzi/użytków PowerShell.

## Struktura

- `tools/parse-strings/` – podprojekt z funkcjami do parsowania stringów i pracy z CSV.
  - `Parse-StringToTimeValue.ps1`
  - `csv-support.ps1`
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

## Użycie

```powershell
. ./tools/parse-strings/Parse-StringToTimeValue.ps1
. ./tools/parse-strings/csv-support.ps1
```

Następnie można wywoływać funkcje bezpośrednio w bieżącej sesji PowerShell.
