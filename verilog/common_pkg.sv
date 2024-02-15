`timescale 1ns / 1ps

package common_pkg;
  parameter NR_PRIO_BITS = 3;
  parameter NR_INDEX_BITS = 2;
  // parameter MAX_INDEX = (2 ** NR_INDEX_BITS);

  typedef logic [NR_PRIO_BITS-1:0] Entries[2**NR_INDEX_BITS-1:0];
  typedef logic [NR_PRIO_BITS-1:0] Entry;
  typedef logic [NR_INDEX_BITS-1:0] Index;
endpackage
