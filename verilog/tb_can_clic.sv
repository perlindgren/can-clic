`timescale 1ns / 1ps

import common_pkg::*;

module tb_can_clic;

  PrioEntries entries;
  BitEntries enable;
  BitEntries pend;
  logic is_interrupt;
  Index index;


  can_clic dut (
      entries,
      enable,
      pend,
      is_interrupt,
      index
  );

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;

    pend = '{default: '1};
    enable = '{default: '1};

    // highest entry (leftmost), represent the threshold
    // all at prio zero
    entries = {{3'b000}, {3'b000}, {3'b000}, {3'b000}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    else $error("should be filtered by threshold");

    // threshold at 2, highest prio interrupt at 0, should be filetered by threshold
    entries = {{3'b010}, {3'b001}, {3'b000}, {3'b010}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    else $error("should be filtered by threshold");

    // threshold at 2, highest prio interrupt at 5
    entries = {{3'b010}, {3'b101}, {3'b011}, {3'b010}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 2) $display("ok");
    else $error("should be filtered by threshold");

    // threshold at 2, highest prio interrupt at 4
    entries = {{3'b010}, {3'b001}, {3'b100}, {3'b010}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 1) $display("ok");
    else $error("should be filtered by threshold");

    // threshold at 2, highest prio interrupt at 3
    entries = {{3'b010}, {3'b001}, {3'b010}, {3'b011}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 0) $display("ok");
    else $error("should be filtered by threshold");

    // test enable

    // threshold at 2, highest prio interrupt at 4
    entries = {{3'b010}, {3'b101}, {3'b100}, {3'b010}};
    enable  = {1, 0, 1, 1};  // 2 not enabled
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 1) $display("ok");
    else $error("should be filtered by threshold");

    // threshold at 2, highest prio interrupt at 3
    entries = {{3'b010}, {3'b001}, {3'b110}, {3'b011}};
    enable = {1, 1, 1, 1};  // restore enable
    pend = {1, 1, 0, 1};  // 1 not pending 
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 0) $display("ok");
    else $error("should be filtered by threshold");

  end

endmodule
