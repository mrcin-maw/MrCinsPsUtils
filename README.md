# MrCinsPsUtils

Repozytorium na wiele narzędzi/użytków PowerShell.

## Struktura

- `tools/parse-strings/` – obecny podprojekt z funkcjami do parsowania stringów.
  - `Parse-StringToTimeValue.ps1`
  - `csv-support.ps1`
- `wiki/` – materiały pomocnicze.

## Podprojekt: parse-strings

### Parse-StringToTimeValue ([string] $value)
Zwraca obiekt `[DateTime]` jeśli źródłowy string pasuje do formatu czasu
(`HH?mm?ss` lub jedna z postaci: `h`, `hm`, `HHm`, `HHmm`, `HHmms`, `HHmmss`).

### Użycie

```powershell
. ./tools/parse-strings/Parse-StringToTimeValue.ps1
. ./tools/parse-strings/csv-support.ps1
```
