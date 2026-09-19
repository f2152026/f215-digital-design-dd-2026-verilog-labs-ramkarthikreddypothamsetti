// tb.v
module tb;

  reg  [1:0] t_a, t_b;              // driven by tb -> reg
  wire       t_gt, t_lt, t_eq;      // driven by DUT -> wire

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i, j;
  integer errors = 0;
  integer ones;   // 32-bit, so adding three 1-bit values can't wrap
  reg exp_gt, exp_lt, exp_eq;

  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;  // let the outputs settle before checking

        // reference model, computed on plain integers
        exp_gt = (i > j);
        exp_lt = (i < j);
        exp_eq = (i == j);

        // check 1: outputs match the reference model
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL @%0t: A=%0d B=%0d | got GT=%b LT=%b EQ=%b, expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end

        // check 2: exactly one output is high
        ones = t_gt + t_lt + t_eq;
        if (ones !== 1) begin
          $display("FAIL @%0t: A=%0d B=%0d | %0d outputs high, expected exactly 1",
                   $time, t_a, t_b, ones);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 16 combinations correct");
    else
      $display("DONE: %0d error(s) found", errors);
    $finish;
  end

endmodule