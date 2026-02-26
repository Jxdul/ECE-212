# Lab 2 Flow Charts

This file documents flow charts for the current implementations in:

- `Lab/Lab2/Provided/Lab2_L432KC/Lab2_L432KC/Lab2A/Lab2A_L432KC/Lab2a_L432KC.s`
- `Lab/Lab2/Provided/Lab2_L432KC/Lab2_L432KC/Lab2B/Lab2B_L432KC/Lab2b_L432KC.s`

## Lab2A Part A (Addressing Modes)

### Part 1: Register Indirect With Offset (First 3 Elements)

```mermaid
flowchart TD
    A([Start TestAsmCall]) --> B[Push LR and saved registers]
    B --> C[Load opcode base 0x20001000]
    C --> D[Read N, addrA, addrB]
    D --> E[Read dest1 address from opcode + 0x0C]
    E --> F[Load first elements from A and B using offset addressing]
    F --> G[Add and store first result in dest1]
    G --> H[Load second elements from A and B using offset addressing]
    H --> I[Add and store second result in dest1]
    I --> J[Load third elements from A and B using offset addressing]
    J --> K[Add and store third result in dest1]
    K --> L[Proceed to Part 2]
```

### Part 2: Indexed Register Indirect (Entire Array)

```mermaid
flowchart TD
    A([Part 2 Start]) --> B[Reload addrA and addrB]
    B --> C[Load dest2 address from opcode + 0x10]
    C --> D[Compute byte limit = N * 4]
    D --> E[Set index = 0]
    E --> F{index >= byte limit?}
    F -- Yes --> G[Part 2 done]
    F -- No --> H[Load current elements from A and B using indexed addressing]
    H --> I[Add values]
    I --> J[Store sum to current dest2 element]
    J --> K[index = index + 4]
    K --> F
```

### Part 3: Post-Increment Register Indirect (Entire Array)

```mermaid
flowchart TD
    A([Part 3 Start]) --> B[Reload addrA and addrB]
    B --> C[Load dest3 address from opcode + 0x14]
    C --> D{N == 0?}
    D -- Yes --> E[Part 3 done]
    D -- No --> F[Load current A value and post-increment A pointer]
    F --> G[Load current B value and post-increment B pointer]
    G --> H[Add values]
    H --> I[Store result and post-increment dest3 pointer]
    I --> J[N = N - 1]
    J --> K{N != 0?}
    K -- Yes --> F
    K -- No --> E[Part 3 done]
    E --> L[Pop registers and return]
```

## Lab2B Part B (Trapezoidal Rule)

### Trapezoidal Area Calculation (No `MUL`)

```mermaid
flowchart TD
    A([Start TestAsmCall]) --> B[Push LR and saved registers]
    B --> C[Load opcode base 0x20001000]
    C --> D[Read input addresses and sizes]
    D --> E[Load first two X values]
    E --> F[Compute deltaX from first two X values]
    F --> G[Initialize sum to zero]
    G --> H[Initialize index and byte limit]
    H --> I{Reached end of Y array}
    I -- Yes --> J[Weighted sum complete]
    I -- No --> K{First or last element}
    K -- Yes --> L[Add current Y value to sum]
    K -- No --> M[Add double current Y value to sum]
    L --> N[Advance index by one word]
    M --> N
    N --> I
    J --> O[Compute product using shifts and branches]
    O --> P[Divide product by two]
    P --> Q{Product is odd}
    Q -- Yes --> R[Round up final result]
    Q -- No --> S[Keep truncated result]
    R --> T[Store final area to result address]
    S --> T
    T --> U[Pop registers and return]
```

## Notes for Report / Demo

- Lab2A Part 1 intentionally processes only the first 3 elements (per lab spec).
- Lab2A Part 2 uses an explicit index register (`r8`) and indexed addressing.
- Lab2A Part 3 uses post-increment addressing (`[reg], #4`) for all pointers.
- Lab2B avoids `MUL` and uses shifts/branch logic because `deltaX` is constrained to `1`, `2`, or `4`.
- Lab2B rounds only at the end (final result rounded up if fractional), matching the lab PDF requirement.
