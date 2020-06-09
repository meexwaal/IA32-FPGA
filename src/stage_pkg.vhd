/*! @file stage_pkg.vhd
 *  @brief Package containing signals from specific pipeline stages
 *         and their corresponding registers
 *  @author Maxwell Johnson
 *
 *  @todo The components in this package should not be necesssary. Ideally,
 *        we could use registers with a generic type. Generic types are
 *        supported in VHDL '08, but not currently in GHDL. Until then,
 *        these type-specific registers are a hack that will have to
 *        suffice. Coming from Verilog, I think it's wacky that you can't
 *        easily turn records into bits.
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types;

package stage is

  /*! Signals used in the Argument Fetch stage that come from the
   *  previous stage */
  type AF_t is record
    rs1      : types.reg_id_t;
    rs2      : types.reg_id_t;
    rs1_data : unsigned(31 downto 0);
    rs2_data : unsigned(31 downto 0);
  end record;

  /*! Signals used in the WriteBack stage that come from the
   *  previous stage */
  type WB_t is record
    rd      : types.reg_id_t;
    rd_data : unsigned(31 downto 0);
    rf_we   : std_logic;
  end record;

end package;
