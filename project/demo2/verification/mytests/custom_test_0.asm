// custom test 0

// manually inserted nops where they should be generated to test our pipelined design BEFORE
// we added in hazard checking

lbi r1, 100	//load 100 into r1
lbi r2, 99	//load 99 into r2
nop
nop
nop
add r3, r1, r2	//expected r3 = 100 or 
nop
nop
nop
add r2, r3, r1	//expected r2 = 299 or x012b
nop
nop
nop
add r4, r1, r2	//expected r4 = 399 or x018f
nop
nop
nop
add r6, r2, r1	//expected r6 = 399 or x018f
nop
nop
nop
add r5, r1, r4	//expected r5 = 499 or x01f3
nop
nop
nop
add r4, r5, r1	//expected r4 = 599 or x0257
nop
nop
nop
halt