module tb_can_clic;

  logic [1:0][2:0] entries;
  logic is_interrupt;
  logic [1:0] index;

  integer i;
  can_clic dut (
      entries,
      is_interrupt,
      index
  );

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;

    entries = {{3'b010}, {3'b100}};
    #10 $finish;

  end

endmodule
