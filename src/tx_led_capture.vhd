-- Capture the various LED configurations on button pushes
-- Output to be prepared for transmission

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity tx_led_capture is
  port(
    clk_100  : in  std_logic;
    rst_100  : in  std_logic;
    switches : in  std_logic_vector(3 downto 0);
    buttons  : in  std_logic_vector(2 downto 0);
    tx_red   : out std_logic_vector(3 downto 0);
    tx_green : out std_logic_vector(3 downto 0);
    tx_blue  : out std_logic_vector(3 downto 0)
  );
end entity tx_led_capture;

architecture arch of tx_led_capture is

  signal debounce_button : std_logic_vector(2 downto 0);

begin

  -- Debounce all the buttons as input
  debounceButtonGen : for i in 0 to 2 generate
    debounceButtonInst : entity xil_defaultlib.debounce_button
      port map(
        clk_100 => clk_100,
        btn_in  => buttons(i),
        btn_out => debounce_button(i)
      );
  end generate debounceButtonGen;

  -- Capture switches on different button pushes
  switchCapture : process(clk_100)
  begin
    if rising_edge(clk_100) then
      if rst_100 = '1' then
        tx_red <= x"A";
        tx_green <= x"B";
        tx_blue <= x"C";
      else
        if debounce_button(0) = '1' then
          tx_red <= switches;
        end if;
        if debounce_button(1) = '1' then
          tx_green <= switches;
        end if;
        if debounce_button(2) = '1' then
          tx_blue <= switches;
        end if;
      end if;
    end if;
  end process switchCapture;

end architecture arch;
