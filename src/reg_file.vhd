/*! @file reg_file.vhd
 *  @brief x86 register file. Dual combinational read, single synchronous
 *         write with internal forwarding.
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types;

entity reg_file is
  port (clk, rst_n         : in  std_logic;
        /*! Registers to read from */
        rs1, rs2           : in  types.reg_id_t;
        /*! Data from read registers */
        rs1_data, rs2_data : out unsigned(31 downto 0);
        /*! Register to write to */
        rd                 : in  types.reg_id_t;
        /*! Write-enable for register write */
        we                 : in  std_logic;
        /*! Data to write to rd */
        rd_data            : in  unsigned(31 downto 0));
end entity;

architecture arch of reg_file is
begin

  /*! @todo */

end architecture;
