module p_clic #(
    parameter integer unsigned NrSources = 4,
    parameter integer unsigned PrioWidth = 3,

    localparam integer SrcWidth = $clog2(NrSources)  // derived parameter
) (
    input [NrSources-1:0] p,  // pending    
    input [NrSources-1:0] e,  // enabled
    input [PrioWidth-1:0] prio[NrSources],  // priority
    input [PrioWidth-1:0] t,  // threshold

    output logic [SrcWidth-1:0] index,  // index of winner
    output logic is_interrupt  // true if interrupt
);

  always_comb begin

    logic [PrioWidth-1:0] threshold = t;
    is_interrupt = 0;
    index = '{default: 0};
    for (integer i = 0; i < NrSources; i++) begin
      if (p[i] & e[i] & prio[i] > threshold) begin
        threshold = prio[i];
        index = i[SrcWidth-1:0];
        is_interrupt = 1;
      end
    end
  end


endmodule



