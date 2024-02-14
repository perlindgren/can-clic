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

    //entries = {{3'b000}, {3'b001}, {3'b000}, {3'b001}};
    entries = {{2'b000}, {2'b001}};
    // #10 entries = {{3'b000}, {3'b000}};
    // #10 entries = {{3'b001}, {3'b000}};
    // #10 entries = {{3'b000}, {3'b001}};
    // #10 entries = {{3'b001}, {3'b001but}};
    #10 $finish;

  end

endmodule
