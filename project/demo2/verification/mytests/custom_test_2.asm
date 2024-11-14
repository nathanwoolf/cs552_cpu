// custom test 2

// added this test because our store wasn't working correctly for data hazards, 
// this simple test helped us debug this issue

lbi r0, 26
lbi r1, 15
st r1, r0, 0
ld r2, r0, 0
halt