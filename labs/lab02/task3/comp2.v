// comp2.v
module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);
  assign EQ = (A == B);
  assign GT = (A >  B);   // was (A >= B)
  assign LT = (A <  B);
endmodule