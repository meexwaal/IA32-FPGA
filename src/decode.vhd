/*! @file decode.vhd
 *  @brief x86 ISA combinational decoder module
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types;
use work.isa;

entity decode is
  port (
    /*! Instruction memory to decode.
     *  imem(0) is the byte from the lowest address.
     */
    imem    : in unsigned(types.i_data_bits-1 downto 0);
    /*! Decoded control signals etc. */
    decoded : out types.decode_t);
end entity;

architecture arch of decode is
  /* Opcode and variants that use some of the higher bits */
  signal op5b : unsigned(4 downto 0);
  signal op6b : unsigned(5 downto 0);
  signal op7b : unsigned(6 downto 0);
  signal op   : unsigned(7 downto 0);
begin
  /* TODO */
  /* Instruction memory format */
  /* type imem_t is array(0 to 15) of unsigned(7 downto 0); */
  op <= imem(types.i_data_bits-1 downto types.i_data_bits-8);

  op5b <= op(7 downto 3);
  op6b <= op(7 downto 2);
  op7b <= op(7 downto 1);

  /* Ideally, this would look like a 256-to-1 mux, with the op-code as
   * the selector. The complication is that many instructions only use
   * the 5 (or 6 or 7) most significant bits for the op code, using the
   * lower bits to encode other information. In hardware, we can achieve
   * this by just removing some muxes, so the same set of control signals
   * are selected by all 8-bit opcodes with the first 5 bits matching,
   * e.g., 0b01011 (POP). While the synthesis process is somewhat opaque,
   * VHDL 2008's matching case statement, case?, should achieve this.
   * Unfortunately, GHDL doesn't support this syntax yet. Instead, for
   * the sake of code clarity (at the cost of performance, assuming the
   * synthesizer does the naive thing and chains muxes), we'll have
   * separate case statements for 5-bit, 6b, 7b, and 8b opcodes, each
   * chained together as the "default" case of the previous.
   */
  /*! @todo Use a more optimal construct, likely case? if supported */

  process (all) begin
    case op is
      when isa.POP_m32 =>
        decoded.i_len <= 4d"1";           /* TODO incorrect example */
      when others =>
        /* TODO */
    end case;
  end process;

end architecture;
