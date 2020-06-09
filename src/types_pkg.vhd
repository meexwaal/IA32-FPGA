/*! @file types_pkg.vhd
 *  @brief Package containing types and constants used throughout the processor
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is

  /*! Generic address size in bits */
  constant addr_bits : integer := 32;

  /*! I-mem data interface size in bits */
  constant i_data_bits : integer := 16*8;

  /*! Type of a 32-bit read/write memory request */
  type mem32_request is record
    addr   : unsigned(addr_bits downto 0); /*! Address */
    re     : std_logic;                            /*! Read enable */
    we     : std_logic;                            /*! Write enable */
    wrdata : unsigned(31 downto 0);        /*! Write data */
  end record;

  /*! Type of a 32-bit read/write memory response */
  type mem32_response is record
    rddata : unsigned(31 downto 0); /*! Read data */
    /*! @todo Will eventually include error information */
  end record;

  /*! Result of the decoder */
  type decode_t is record
    /*! Instruction length, in bytes
     *  @todo should we use integer range? */
    i_len : unsigned(3 downto 0);
    /*! @todo */
  end record;

  /*! Register identifier, for all registers. Used primarily by register file
   *  and decode. */
  type reg_id_t is (REG_EAX); /*! @todo */

  /*! ALU operation */
  type alu_op_t is (ALU_ADD); /*! @todo */

end package;
