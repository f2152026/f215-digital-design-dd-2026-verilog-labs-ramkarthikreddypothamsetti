// tb.v
module tb;

  parameter WIDTH = 8;
  parameter DEPTH = 4;

  reg  [$clog2(DEPTH)-1:0] t_sel;   // driven by tb → reg
  wire [WIDTH-1:0]         t_dout;  // driven by DUT → wire

  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Step through every address, 5 time units apart
  integer k;
  initial begin
    for (k = 0; k < DEPTH; k = k + 1) begin
      t_sel = k;
      #5;
    end
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d (%b)", t_sel, t_dout, t_dout);

endmodule