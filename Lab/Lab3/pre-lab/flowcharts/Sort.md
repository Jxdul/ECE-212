# Sort Flowchart

```mermaid
flowchart TD
    start([Start Sort]) --> saveRegs[Save callee registers]
    saveRegs --> readInputs[Read entryCount from stack and arrayBase from R0]
    readInputs --> initOuter[Set i = 0]
    initOuter --> outerDone{"i >= entryCount - 1?"}
    outerDone -->|Yes| restoreEnd([Restore registers and return with stack unchanged])
    outerDone -->|No| initInner[Set j = 0]
    initInner --> innerDone{"j >= entryCount - 1 - i?"}
    innerDone -->|Yes| nextOuter[Increment i] --> outerDone
    innerDone -->|No| loadPair[Load array[j] and array[j+1]]
    loadPair --> compareVals{"array[j] > array[j+1]?"}
    compareVals -->|Yes| swapVals[Swap adjacent elements]
    compareVals -->|No| incInner[Increment j]
    swapVals --> incInner
    incInner --> innerDone
```
