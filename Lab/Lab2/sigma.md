You’re very close, but there are several logic/assembly issues in your Part B version.

Why your code is not correct
You overwrite the temp-address register (r8) and use it as the numeric accumulator.
In the provided skeleton, r8 is loaded from opcode as a memory address (temp storage addr), while r10 is used as the running sum. Reusing r8 as the sum corrupts that pointer semantics and diverges from the intended register roles.

Your loop does not implement trapezoidal weighting (1,2,2,...,2,1).
Correct Part B must do:

sum
=
y
0
+
2
y
1
+
⋯
+
2
y
n
−
2
+
y
n
−
1
sum=y 
0
​
 +2y 
1
​
 +⋯+2y 
n−2
​
 +y 
n−1
​
 
The reference code explicitly checks first/last index and doubles only middle points. Your version instead adds r2+r3 repeatedly, which is not equivalent to the required weighting pattern.

You increment Y values instead of loading next Y elements from memory.
add r2, r2, #4 and add r3, r3, #4 increase the numeric Y values by 4; they do not advance through the Y array. You should index memory like ldr r1, [r7, r11] each iteration (as in the reference).

Rounding check is done on the wrong value.
Rounding-up decision must test odd/even of the pre-division product (prod = deltaX * sum), then divide by 2. Reference does tst r0,#1 before final rounded result write. If you test after shifting/dividing, the fractional-half information is gone.

Instruction form issue in your snippet:
lsr r8, #1 is not valid unified syntax (missing source register). It should be like lsr r8, r8, #1 (or use another destination register consistently).

What to do instead (quick fix strategy)
Keep r10 as accumulator (sum), keep r8 as temp pointer if needed.

Iterate index r11 = 0,4,8,...,(n-1)*4.

Each loop: ldr y, [r7, r11]; if first/last add once, else add y<<1.

Compute product from sum with deltaX branch/shift logic.

Round by testing product odd bit before/during divide step exactly like the provided structure.

Commands I used to verify this
✅ rg -n "Part B|Opcode|trapezoid|deltaX|X\\[1\\]" -S .

✅ sed -n '1,220p' Lab/Lab2/Provided/Lab2_L432KC/Lab2_L432KC/Lab2B/Lab2B_L432KC/Lab2b_L432KC.s

✅ nl -ba Lab/Lab2/Provided/Lab2_L432KC/Lab2_L432KC/Lab2B/Lab2B_L432KC/Lab2b_L432KC.s | sed -n '12,130p'

If you want, I can rewrite your exact snippet into a corrected version line-by-line using your register choices.
