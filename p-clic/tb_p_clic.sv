module tb_p_clic;

  parameter integer unsigned NrSources = 4;
  parameter integer unsigned PrioWidth = 3;

  localparam integer SrcWidth = $clog2(NrSources);  // derived parameter

  logic [NrSources-1:0] p;  // pending    
  logic [NrSources-1:0] e;  // enabled
  logic [PrioWidth-1:0] prio[NrSources];  // priority
  logic [PrioWidth-1:0] t;  // threshold

  logic [SrcWidth-1:0] index;  // index of winner
  logic is_interrupt;  // t

  p_clic dut (
      .p(p),
      .e(e),
      .prio(prio),
      .t(t),
      .index(index),
      .is_interrupt(is_interrupt)
  );

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;

    p = '{default: '1};
    e = '{default: '1};

    t = {3'b000};


    // highest entry (leftmost), represent the threshold
    // all at prio zero
    prio = {{3'b000}, {3'b000}, {3'b000}, {3'b000}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);

    prio = {{3'b000}, {3'b000}, {3'b000}, {3'b001}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);

    prio = {{3'b000}, {3'b000}, {3'b001}, {3'b001}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);

    prio = {{3'b000}, {3'b001}, {3'b001}, {3'b001}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    
    prio = {{3'b001}, {3'b001}, {3'b001}, {3'b001}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    //assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    // else $error("should be filtered by threshold");

    // threshold at 2, highest prio interrupt at 0, should be filetered by threshold



  end

endmodule

