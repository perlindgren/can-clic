`timescale 1ns / 1ps

package common_pkg;


  // For testing
  parameter NR_PRIO_BITS = 3;
  parameter NR_INDEX_BITS = 2;

  // // Sweet spot, 8 priorities, 64 vectors
  // parameter NR_PRIO_BITS = 3;
  // parameter NR_INDEX_BITS = 6;

  // 256 priorities, 64 vectors
  // parameter NR_PRIO_BITS = 8;
  // parameter NR_INDEX_BITS = 6;

  // Too big
  // parameter NR_PRIO_BITS = 8;
  // parameter NR_INDEX_BITS = 8;

  typedef logic [NR_PRIO_BITS-1:0] PrioEntries[2**NR_INDEX_BITS-1:0];
  typedef logic BitEntries[2**NR_INDEX_BITS-1:0];
  typedef logic [NR_PRIO_BITS-1:0] Prio;
  typedef logic [NR_INDEX_BITS-1:0] Index;
endpackage
