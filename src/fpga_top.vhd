-- TOP LEVEL OF ARTIX 7 FPGA on ARTY BOARD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity fpga_top is
  port(
    clk_100 : in  std_logic;
    btns    : in  std_logic_vector(3 downto 0);
    switches : in  std_logic_vector(3 downto 0)
  );
end entity fpga_top;

architecture arch of fpga_top is

  signal rst_100 : std_logic := '1';

begin

  -- Generate a system reset signal
  rstGenInst : entity xil_defaultlib.rst_gen
    port map(
      clk_100 => clk_100,
      btn     => btn(0),
      rst_100 => rst_100
    );

  -- Capture the switches for the various led values
  tx_led_capture : entity xil_defaultlib.tx_led_capture
    port map(
      clk_100  => clk_100,
      rst_100  => rst_100,
      switches => switches,
      buttons  => btns(3 downto 1),
      tx_red   =>
      tx_green =>
      tx_blue  =>
    );



end architecture arch;