// tb.v
module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer errors = 0;
  reg [3:0] expected;

  // wait for outputs to settle, then compare against a reference model
  task check;
    begin
      #5;
      expected = t_op ? (t_a - t_b) : (t_a + t_b);   // 4-bit wraparound, like hardware
      if (t_result !== expected) begin
        $display("FAIL @%0t: a=%0d b=%0d op=%b | got %0d, expected %0d",
                 $time, t_a, t_b, t_op, t_result, expected);
        errors = errors + 1;
      end
    end
  endtask

  integer i, j, k;
  initial begin
    // Part 1: change ONLY op, with a and b held fixed
    // (catches a sensitivity list that leaves out op)
    t_a = 4'd9; t_b = 4'd3; t_op = 0; check;   // 9+3 = 12
    t_op = 1;                         check;   // 9-3 = 6
    t_op = 0;                         check;   // back to 12

    // Part 2: exhaustive -- every a, b, op (512 cases)
    for (k = 0; k < 2; k = k + 1)
      for (i = 0; i < 16; i = i + 1)
        for (j = 0; j < 16; j = j + 1) begin
          t_op = k; t_a = i; t_b = j;
          check;
        end

    if (errors == 0)
      $display("PASS: all tests correct");
    else
      $display("DONE: %0d error(s) found", errors);
    $finish;
  end

endmodule