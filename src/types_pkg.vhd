/*! @file types_pkg.vhd
 *  @brief Package containing types and constants used throughout the processor
 */

library ieee;
use ieee.std_logic_1164.all;

package types_pkg is

  /*! Generic address size in bits */
  constant addr_bits : integer := 32;

  /*! I-mem data interface size in bits */
  constant i_data_bits : integer := 16*8;

  /*! Type of a 32-bit read/write memory request */
  type mem32_request is record
    addr   : std_logic_vector(addr_bits downto 0); /*! Address */
    re     : std_logic;                            /*! Read enable */
    we     : std_logic;                            /*! Write enable */
    wrdata : std_logic_vector(31 downto 0);        /*! Write data */
  end record;

  /*! Type of a 32-bit read/write memory response */
  type mem32_response is record
    rddata : std_logic_vector(31 downto 0); /*! Read data */
    /*! @todo Will eventually include error information */
  end record;

end package;