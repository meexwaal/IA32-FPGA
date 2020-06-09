/*! @file alu.vhd
 *  @brief Combinational arithmetic-logic unit
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types;

entity alu is
  port (arg0, arg1 : in  unsigned(31 downto 0);
        op         : in  types.alu_op_t;
        result     : out unsigned(31 downto 0));
end entity;

architecture arch of alu is
begin

  process (all) begin
    case op is
      when types.ALU_ADD =>
        result <= arg0 + arg1;

      when others =>
        /* TODO */

    end case;
  end process;

end architecture;
