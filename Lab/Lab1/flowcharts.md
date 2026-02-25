# Lab 1 Flowcharts

## Lab1a_L432KC.s — Hex ASCII to Value Converter

Converts hex ASCII characters (0–9, A–F, a–f) from source memory to 4-byte values in destination memory. Enter (0x0D) ends the loop.

```mermaid
flowchart TD
    Start([Start]) --> Init["R0 = 0x20001000 (source)<br/>R1 = 0x20002000 (dest)"]
    Init --> Loop
    Loop["Load R2 = [R0]"]
    Loop --> CheckEnter{"R2 == 0x0D<br/>(Enter)?"}
    CheckEnter -->|Yes| Exit([Exit])
    CheckEnter -->|No| CheckDigit{"R2 >= 0x30<br/>and R2 <= 0x39?"}
    CheckDigit -->|Yes| Digit["R3 = R2 - 0x30<br/>(digit 0-9)"]
    CheckDigit -->|No| CheckUpper{"R2 >= 0x41<br/>and R2 <= 0x46?"}
    CheckUpper -->|Yes| Upper["R3 = R2 - 0x37<br/>(A-F)"]
    CheckUpper -->|No| CheckLower{"R2 >= 0x61<br/>and R2 <= 0x66?"}
    CheckLower -->|Yes| Lower["R3 = R2 - 0x57<br/>(a-f)"]
    CheckLower -->|No| Invalid["R3 = 0xFFFFFFFF<br/>(invalid)"]
    Digit --> Store
    Upper --> Store
    Lower --> Store
    Invalid --> Store
    Store["[R1] = R3<br/>R0 += 4, R1 += 4"]
    Store --> Loop
```

---

## Lab1b_L432KC.s — Case Converter (Upper ↔ Lower)

Reads ASCII letters from source, converts uppercase→lowercase and lowercase→uppercase, writes to destination. Enter (0x0D) ends the loop. Non-letters become '*' (0x2A).

```mermaid
flowchart TD
    Start([Start]) --> Init["R0 = 0x20001000 (source)<br/>R1 = 0x20003000 (dest)"]
    Init --> Loop
    Loop["Load R2 = [R0]"]
    Loop --> CheckEnter{"R2 == 0x0D<br/>(Enter)?"}
    CheckEnter -->|Yes| Exit([Exit])
    CheckEnter -->|No| CheckUpper{"R2 >= 0x41<br/>and R2 <= 0x5A?"}
    CheckUpper -->|Yes| ToLower["R3 = R2 + 0x20<br/>(uppercase → lowercase)"]
    CheckUpper -->|No| CheckLower{"R2 >= 0x61<br/>and R2 <= 0x7A?"}
    CheckLower -->|Yes| ToUpper["R3 = R2 - 0x20<br/>(lowercase → uppercase)"]
    CheckLower -->|No| Invalid["R3 = 0x2A<br/>('*' invalid)"]
    ToLower --> Store
    ToUpper --> Store
    Invalid --> Store
    Store["[R1] = R3<br/>R0 += 4, R1 += 4"]
    Store --> Loop
```
