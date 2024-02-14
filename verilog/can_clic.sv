module can_clic #(
    parameter PRIO_BITS  = 3,
    parameter INDEX_BITS = 2
) (
    input logic [INDEX_BITS-1:0][PRIO_BITS-1:0] entries,
    output logic is_interrupt,
    output logic [INDEX_BITS-1:0] index
);
  logic [PRIO_BITS-1:0] p;
  always begin
    for (integer i = 0; i < 2 ** (INDEX_BITS - 1); i++) begin
      p = entries[i];
      $display("i %3d prio %3b", i, p);

    end
    {is_interrupt, index} = {1'b0, 2'b00};
  end
endmodule

