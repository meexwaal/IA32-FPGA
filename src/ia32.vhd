/*! @file ia32.vhd
 *  @brief Top-level instantiation of modules
 */

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg;

/*! @brief Top-level entity */
entity ia32 is
end entity;

architecture arch of ia32 is
  signal i_addr     : std_logic_vector(types_pkg.addr_bits-1 downto 0);
  signal i_re       : std_logic;
  signal i_rddata   : std_logic_vector(types_pkg.i_data_bits-1 downto 0);
  signal d_request  : types_pkg.mem32_request;
  signal d_response : types_pkg.mem32_response;

  component memory_interface is
    port (clk, rst_n : in  std_logic;
          i_addr     : out std_logic_vector(types_pkg.addr_bits-1 downto 0);
          i_re       : out std_logic;
          i_rddata   : in  std_logic_vector(types_pkg.i_data_bits-1 downto 0);
          d_request  : in  types_pkg.mem32_request;
          d_response : out types_pkg.mem32_response
    );
  end component;

  component cpu_core is
    port (clk, rst_n : in  std_logic;
          i_addr     : in  std_logic_vector(types_pkg.addr_bits-1 downto 0);
          i_re       : in  std_logic;
          i_rddata   : out std_logic_vector(types_pkg.i_data_bits-1 downto 0);
          d_request  : out types_pkg.mem32_request;
          d_response : in  types_pkg.mem32_response
    );
  end component;

begin

  /* The CPU's interface to the memory */
  m0 : memory_interface port map (clk        => '0', /* TODO clk/rst */
                                  rst_n      => '0',
                                  i_addr     => i_addr,
                                  i_re       => i_re,
                                  i_rddata   => i_rddata,

                                  d_request  => d_request,
                                  d_response => d_response);

  /* The CPU core itself */
  c0 : cpu_core port map (clk        => '0', /* TODO clk/rst */
                          rst_n      => '0',
                          i_addr     => i_addr,
                          i_re       => i_re,
                          i_rddata   => i_rddata,

                          d_request  => d_request,
                          d_response => d_response);

  /*! @todo Add other components, e.g. timer, keyboard, display, port NoC */
end architecture;
