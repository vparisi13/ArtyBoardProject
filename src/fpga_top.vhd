-- TOP LEVEL OF ARTIX 7 FPGA on ARTY BOARD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity fpga_top is
  port(
    clk_100 : in  std_logic;
    btn0    : in  std_logic
  );
end entity fpga_top;

architecture arch of fpga_top is
  
  signal rst_100 : std_logic := '1';

begin

  rstGenInst : entity xil_defaultlib.rst_gen
    port map(
      clk_100 => clk_100,
      btn0    => btn0,
      rst_100 => rst_100
    );


end architecture arch;