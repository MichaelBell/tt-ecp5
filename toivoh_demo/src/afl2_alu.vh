
`define AFL_INST_BITS      4
`define AFL_INST_NOP       4'd0

`define AFL_INST_CMPABS    4'd4
`define AFL_INST_ADD       4'd5
`define AFL_INST_NORMALIZE 4'd6

`define AFL_INST_LOAD      4'd8 // quite similar to addall
`define AFL_INST_ADDINT    4'd9

// Must be a pair differing only by LSB
`define AFL_INST_ADDALL0   4'd10
`define AFL_INST_ADDALL1   4'd11

`define AFL_INST_SQRT      4'd12 // quite similar to load, make them differ by one bit
