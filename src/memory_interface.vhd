/*! @file memory_interface.vhd
 *  @brief Interface to the memory hierarchy
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types;

/*! @brief Memory interface to processor
 *
 *  Contains the actual memory storage element, as well as any caches.
 *  @todo Will eventually have interface to RAM?
 */
entity memory_interface is
  port (clk, rst_n : in  std_logic;
        /*! Instruction memory address */
        i_addr     : out std_logic_vector(types.addr_bits-1 downto 0);
        /*! I-mem read enable */
        i_re       : out std_logic;
        /*! I-mem read data */
        i_rddata   : in  std_logic_vector(types.i_data_bits-1 downto 0);

        /*! Data memory request */
        d_request  : in  types.mem32_request;
        /*! D-mem response */
        d_response : out types.mem32_response
  );
end entity;

architecture arch of memory_interface is
begin
/* TODO */
end architecture;
