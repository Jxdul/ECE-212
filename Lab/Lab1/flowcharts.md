# Lab 1 Flowcharts

## Lab1a_L432KC.s — Hex ASCII to Value Converter

Converts hex characters (0–9, A–F, a–f) from source to numeric values in destination. Enter ends the loop.

```mermaid
flowchart TD
    Start([Start]) --> Init["Set source and destination pointers"]
    Init --> Loop
    Loop["Read next character from source"]
    Loop --> CheckEnter{"Character is Enter?"}
    CheckEnter -->|Yes| Exit([Exit])
    CheckEnter -->|No| CheckDigit{"Character is digit '0'-'9'?"}
    CheckDigit -->|Yes| Digit["Result = numeric value of digit"]
    CheckDigit -->|No| CheckUpper{"Character is 'A'-'F'?"}
    CheckUpper -->|Yes| Upper["Result = hex value 10-15"]
    CheckUpper -->|No| CheckLower{"Character is 'a'-'f'?"}
    CheckLower -->|Yes| Lower["Result = hex value 10-15"]
    CheckLower -->|No| Invalid["Result = invalid marker"]
    Digit --> Store
    Upper --> Store
    Lower --> Store
    Invalid --> Store
    Store["Write result to destination<br/>Advance both pointers"]
    Store --> Loop
```

---

## Lab1b_L432KC.s — Case Converter (Upper ↔ Lower)

Reads letters from source, converts uppercase→lowercase and lowercase→uppercase, writes to destination. Enter ends the loop. Non-letters become '*'.

```mermaid
flowchart TD
    Start([Start]) --> Init["Set source and destination pointers"]
    Init --> Loop
    Loop["Read next character from source"]
    Loop --> CheckEnter{"Character is Enter?"}
    CheckEnter -->|Yes| Exit([Exit])
    CheckEnter -->|No| CheckUpper{"Character is uppercase A-Z?"}
    CheckUpper -->|Yes| ToLower["Result = lowercase version"]
    CheckUpper -->|No| CheckLower{"Character is lowercase a-z?"}
    CheckLower -->|Yes| ToUpper["Result = uppercase version"]
    CheckLower -->|No| Invalid["Result = '*'"]
    ToLower --> Store
    ToUpper --> Store
    Invalid --> Store
    Store["Write result to destination<br/>Advance both pointers"]
    Store --> Loop
```
