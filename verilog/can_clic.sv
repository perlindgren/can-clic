module can_clic #(
    parameter PRIO_BITS  = 3,
    parameter INDEX_BITS = 2
) (
    input logic [INDEX_BITS-1:0][PRIO_BITS-1:0] entries,
    output logic is_interrupt,
    output logic [INDEX_BITS-1:0] index
);
  logic [PRIO_BITS-1:0] p;
  logic [INDEX_BITS-1:0][0:0] contender;
  logic or_value;

  always begin
    for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
      p = entries[i];  // later enabled and pending
      $display("i %3d prio %3b", i, p);
      contender[i] = 1'b1;  // initially set true
    end

    // sanity check
    for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
      $display("i %3d contender %0b", i, contender[i]);
    end


    for (integer j = PRIO_BITS - 1; j >= 0; j--) begin
      or_value = 1'b0;
      for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin

        p = entries[i];

        $display("j %3d, i %3d, p = %3b p[j] = %0b", j, i, p, p[j]);

        if (contender[i] & p[j]) begin

          $display("or_value %0b, - write 1 -", or_value);
          or_value = 1'b1;

        end
      end

      for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
        p = entries[i];
        if (or_value & !p[j]) begin
          // it is ok to loose multiple times
          $display("i %d looses", i);
          contender[i] = 0;
        end
      end
    end

    // for (integer j = INDEX_BITS - 1; j >= 0; j--) begin
    //   or_value = 1'b0;
    //   for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
    //     $display("j %3d, i %3d, ii = %3b p[j] = %0b", j, i, p, p[j]);

    //     if (contender[i] & p[j]) begin

    //       $display("or_value %0b, - write 1 -", or_value);
    //       or_value = 1'b1;

    //     end
    //   end

    //   for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
    //     p = entries[i];
    //     if (or_value & !p[j]) begin
    //       // it is ok to loose multiple times
    //       $display("i %d looses", i);
    //       contender[i] = 0;
    //     end
    //   end
    // end

    is_interrupt = 0;
    index = '{default: '0};
    for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
      if (contender[i]) begin
        assert (!is_interrupt)
        else $error("multiple winners");
        is_interrupt = 1'b1;
        index = i[1:0];
        $display("winner is i %d", i);
      end
    end
  end
endmodule

