`timescale 1ns / 1ps

import common_pkg::*;

module tb_can_clic;

  Entries entries;
  logic   is_interrupt;
  Index   index;

  can_clic dut (
      entries,
      is_interrupt,
      index
  );

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;

    // highest entry (leftmost), represent the threshold
    entries = {{3'b001}, {3'b000}, {3'b000}, {3'b001}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    else $error("should be filtered by threshold");

    entries = {{3'b000}, {3'b000}, {3'b000}, {3'b000}};
    #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    else $error("should be filtered by threshold");

    entries = {{3'b000}, {3'b011}, {3'b010}, {3'b001}};
    #10 $display("(1), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 2) $display("ok");
    else $warning("should interrupt");

    entries = {{3'b011}, {3'b101}, {3'b010}, {3'b110}};
    #10 $display("(1), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 0) $display("ok");
    else $error("should interrupt");

    entries = {{3'b011}, {3'b101}, {3'b110}, {3'b100}};
    #10 $display("(1), is_interrupt %d, index %d", is_interrupt, index);
    assert (is_interrupt == 1 && index == 1) $display("ok");
    else $error("should interrupt");

  end

endmodule
