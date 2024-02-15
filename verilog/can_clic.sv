`timescale 1ns / 1ps

import common_pkg::*;

module can_clic (
    input Entries entries,

    output logic is_interrupt,
    output Index index
);
  Entry e;
  Index contender;
  logic or_value;

  always @entries begin
    for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
      e = entries[i];  // later enabled and pending
      $display("i=%2d, e=%3b", i, e);
      contender[i] = 1'b1;  // initially set true
    end

    // sanity check
    for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
      $display("i=%2d contender %0b", i, contender[i]);
    end

    $display("---- iterate over priority bits ----");

    // iterate over priority bits
    for (integer pb = NR_PRIO_BITS - 1; pb >= 0; pb--) begin
      or_value = 1'b0;

      $display("---- priority bit %2d: ored write ----", pb);

      // iterate over entries
      for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
        e = entries[i];
        $display("pb=%2d, i=%3d, e= %3b, e[pb] = %0b", pb, i, e, e[pb]);

        // we write a 1
        if (contender[i] & e[pb]) begin
          $display("or_value %0b, - write 1 -", or_value);
          or_value = 1'b1;
        end
      end

      // check if loose
      for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
        e = entries[i];
        if (or_value & !e[pb]) begin
          // it is ok to loose multiple times
          $display("i %d looses", i);
          contender[i] = 0;
        end
      end
    end

    $display("resolve ties");
    // now the same for resolving ties
    for (integer pb = NR_INDEX_BITS - 1; pb >= 0; pb--) begin
      or_value = 1'b0;
      for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
        $display("pb %3d, i %3d, i[pb] = %0b", pb, i, i[pb]);

        if (contender[i] & i[pb]) begin
          $display("or_value %0b, - write 1 -", or_value);
          or_value = 1'b1;

        end
      end
      $display("check loosers");
      for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
        if (or_value & !i[pb]) begin
          // it is ok to loose multiple times
          $display("i %d looses", i);
          contender[i] = 0;
        end
      end
    end

    is_interrupt = 0;
    index = '{default: '0};
    for (integer i = 0; i < 2 ** NR_INDEX_BITS; i++) begin
      if (contender[i]) begin
        assert (!is_interrupt)
        else $error("multiple winners");
        is_interrupt = 1'b1;
        index = i[2**NR_INDEX_BITS-1:0];
        $display("winner is i %d", i);
      end
    end
  end
endmodule

