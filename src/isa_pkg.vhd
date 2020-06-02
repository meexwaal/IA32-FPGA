/*! @file isa_pkg.vhd
 *  @brief Definitions for the x86 ISA. In particular, opcode definitions.
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;

package isa is

  /* 8-bit opcodes */
  constant POP_m32 : std_logic_vector(7 downto 0) := 8x"8F";

end package;
