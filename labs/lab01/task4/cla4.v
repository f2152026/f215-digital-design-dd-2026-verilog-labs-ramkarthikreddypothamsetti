module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3;

  wire t1;
  wire t2a, t2b;
  wire t3a, t3b, t3c;
  wire t4a, t4b, t4c, t4d;

  xor #(2) (p0, a[0], b[0]);
  xor #(2) (p1, a[1], b[1]);
  xor #(2) (p2, a[2], b[2]);
  xor #(2) (p3, a[3], b[3]);

  and #(2) (g0, a[0], b[0]);
  and #(2) (g1, a[1], b[1]);
  and #(2) (g2, a[2], b[2]);
  and #(2) (g3, a[3], b[3]);

  and #(2) (t1, p0, cin);
  or  #(2) (c1, g0, t1);

  and #(2) (t2a, p1, g0);
  and #(2) (t2b, p1, p0, cin);
  or  #(2) (c2, g1, t2a, t2b);

  and #(2) (t3a, p2, g1);
  and #(2) (t3b, p2, p1, g0);
  and #(2) (t3c, p2, p1, p0, cin);
  or  #(2) (c3, g2, t3a, t3b, t3c);

  and #(2) (t4a, p3, g2);
  and #(2) (t4b, p3, p2, g1);
  and #(2) (t4c, p3, p2, p1, g0);
  and #(2) (t4d, p3, p2, p1, p0, cin);
  or  #(2) (cout, g3, t4a, t4b, t4c, t4d);

  xor #(2) (sum[0], p0, cin);
  xor #(2) (sum[1], p1, c1);
  xor #(2) (sum[2], p2, c2);
  xor #(2) (sum[3], p3, c3);

endmodule