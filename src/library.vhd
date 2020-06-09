/*! @file library.vhd
 *  @brief Miscellaneous modules that are universally applicable
 *  @author Maxwell Johnson
 */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package lib is

  component reg is
    generic (N : positive := 32;
             reset_val : unsigned(N-1 downto 0) := (others => '0'));
    port (clk   : in  std_logic;
          rst_n : in  std_logic;
          en    : in  std_logic;
          D     : in  unsigned(N-1 downto 0);
          Q     : out unsigned(N-1 downto 0));
  end component;

end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

/*! @brief Register for a generic-width logic vector.
 *  Synchronous load, asynchronous reset. */
entity reg is
  generic (N         : positive := 32;      /*!< Width to store */
           reset_val : unsigned(N-1 downto 0)
                     := (others => '0'));   /*!< Value to reset to, default 0 */

  port (clk   : in  std_logic;         /*!< Clock */
        rst_n : in  std_logic;         /*!< Asynchronous reset, active low */
        en    : in  std_logic;         /*!< Synchronous load/enable */
        D     : in  unsigned(N-1 downto 0);  /*!< Input */
        Q     : out unsigned(N-1 downto 0)); /*!< Output */

end entity;

architecture arch of reg is
begin
  process (rst_n, clk) begin
    if (not rst_n) then /* Active low reset */
      Q <= reset_val;
    elsif (rising_edge(clk) and en = '1') then
      Q <= D;
    end if;
  end process;
end architecture;
