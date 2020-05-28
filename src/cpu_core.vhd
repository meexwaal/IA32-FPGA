/*! @file cpu_core.vhd
 *  @brief x86 CPU core
 */

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg;

entity cpu_core is
  port (clk, rst_n : in  std_logic;
        /*! Instruction memory address */
        i_addr     : in  std_logic_vector(types_pkg.addr_bits-1 downto 0);
        /*! I-mem read enable */
        i_re       : in  std_logic;
        /*! I-mem read data */
        i_rddata   : out std_logic_vector(types_pkg.i_data_bits-1 downto 0);

        /*! Data memory request */
        d_request  : out types_pkg.mem32_request;
        /*! D-mem response */
        d_response : in  types_pkg.mem32_response
  );
end entity;

architecture arch of cpu_core is
begin
/* TODO */
end architecture;
