/*! @file cpu_core.vhd
 *  @brief x86 CPU core
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types;

entity cpu_core is
  port (clk, rst_n : in  std_logic;
        /*! Instruction memory address */
        i_addr     : in  std_logic_vector(types.addr_bits-1 downto 0);
        /*! I-mem read enable */
        i_re       : in  std_logic;
        /*! I-mem read data */
        i_rddata   : out std_logic_vector(types.i_data_bits-1 downto 0);

        /*! Data memory request */
        d_request  : out types.mem32_request;
        /*! D-mem response */
        d_response : in  types.mem32_response
  );
end entity;

architecture arch of cpu_core is

  signal pc, next_pc : std_logic_vector (31 downto 0);
  signal decoded : types.decode_t;

  component reg is
    generic (N : positive := 32;
             reset_val : std_logic_vector(N-1 downto 0) := (others => '0'));
    port (clk   : in  std_logic;
          rst_n : in  std_logic;
          en    : in  std_logic;
          D     : in  std_logic_vector(N-1 downto 0);
          Q     : out std_logic_vector(N-1 downto 0));
  end component;

  component decode is
    port (imem    : in std_logic_vector(types.i_data_bits-1 downto 0);
          decoded : out types.decode_t);
  end component;
begin

  /* I-mem Fetch */
  /* Fetch instructions that aren't in the decode cache.
   */

  pc_reg : reg
    generic map (N => pc'length)
    port map (clk => clk,
              rst_n => rst_n,
              en => '1',
              D => next_pc,
              Q => pc);
  next_pc <= std_logic_vector(unsigned(pc) + unsigned(decoded.i_len));

  d0 : decode port map (imem => i_rddata,
                        decoded => decoded);

  /* Decode */
  /* Decode the instruction fetched from memory.
   * @todo Put the decoding into the decode cache.
   */

  /* @todo Decode fetch */
  /* Fetch the decoding from the decode cache.
   */

  /* Argument fetch */
  /* Read the register file.
   * Calculate the memory address from which to read.
   * Request memory.
   */

  /* Execute */
  /* Perform an ALU operation.
   * Write to memory.
   */

  /* Writeback */
  /* Process any exceptions.
   * Write to the register file.
   */

end architecture;
