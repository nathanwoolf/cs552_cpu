// custom test 1

lbi r1, 100	//load 100 into r1
lbi r2, 99	//load 99 into r2
add r3, r1, r2	//expected r3 = 100 or 
add r2, r3, r1	//expected r2 = 299 or x012b
add r4, r1, r2	//expected r4 = 399 or x018f
add r6, r2, r1	//expected r6 = 399 or x018f
add r5, r1, r4	//expected r5 = 499 or x01f3
add r4, r5, r1	//expected r4 = 599 or x0257
nop
nop
nop
halt