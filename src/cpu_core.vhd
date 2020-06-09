/*! @file cpu_core.vhd
 *  @brief x86 CPU core
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types;
use work.lib;
use work.stage;

entity cpu_core is
  port (clk, rst_n : in  std_logic;
        /*! Instruction memory address */
        i_addr     : in  unsigned(types.addr_bits-1 downto 0);
        /*! I-mem read enable */
        i_re       : in  std_logic;
        /*! I-mem read data */
        i_rddata   : out unsigned(types.i_data_bits-1 downto 0);

        /*! Data memory request */
        d_request  : out types.mem32_request;
        /*! D-mem response */
        d_response : in  types.mem32_response
  );
end entity;

architecture arch of cpu_core is

  signal pc, next_pc : unsigned(31 downto 0);
  signal decoded : types.decode_t;

  /* TODO */
  signal AF : stage.AF_t;
  signal WB : stage.WB_t;

  component decode is
    port (imem    : in  unsigned(types.i_data_bits-1 downto 0);
          decoded : out types.decode_t);
  end component;

  component reg_file is
    port (clk, rst_n         : in  std_logic;
          rs1, rs2           : in  types.reg_id_t;
          rs1_data, rs2_data : out unsigned(31 downto 0);
          rd                 : in  types.reg_id_t;
          we                 : in  std_logic;
          rd_data            : in  unsigned(31 downto 0));
  end component;

  component alu is
    port (arg0, arg1 : in  unsigned(31 downto 0);
          op         : in  types.alu_op_t;
          result     : out unsigned(31 downto 0));
  end component;

begin

  /* I-mem Fetch */
  /* Fetch instructions that aren't in the decode cache.
   */

  pc_reg : lib.reg
    generic map (N => pc'length)
    port map (clk   => clk,
              rst_n => rst_n,
              en    => '1',
              D     => next_pc,
              Q     => pc);
  next_pc <= pc + decoded.i_len;        /* TODO check this */

  /* Decode */
  /* Decode the instruction fetched from memory.
   * @todo Put the decoding into the decode cache.
   */

  d0 : decode port map (imem    => i_rddata,
                        decoded => decoded);

  /* @todo Decode fetch */
  /* Fetch the decoding from the decode cache.
   */

  /* Argument fetch */
  /* Read the register file.
  * Calculate the memory address from which to read.
  * Request memory.
  */

  rf0 : reg_file port map (clk      => clk,
                           rst_n    => rst_n,
                           rs1      => AF.rs1,
                           rs2      => AF.rs2,
                           rs1_data => AF.rs1_data,
                           rs2_data => AF.rs2_data,
                           rd       => WB.rd,
                           we       => WB.rf_we,
                           rd_data  => WB.rd_data);

  /* Execute */
  /* Perform an ALU operation.
   * Write to memory.
   */

  /* TODO */
  /* a0 : alu port map (arg0 */

  /* Writeback */
  /* Process any exceptions.
   * Write to the register file.
   */

end architecture;
