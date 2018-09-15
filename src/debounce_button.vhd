-- Debounce a button.
-- Detect button press for a time.
-- Then trigger output for pulse

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_button is
  generic(
    COUNT_TO : integer := 1000000
  );
  port(
    clk_100 : in  std_logic;
    btn_in  : in  std_logic;
    btn_out : out std_logic
  );
end entity debounce_button;

architecture arch of debounce_button is

  signal counter : unsigned(19 downto 0) := (others => '0');

begin

  countHighCycles : process(clk_100)
  begin
    if rising_edge(clk_100) then
      btn_out <= '0';
      if btn_in = '1' then
        if counter = 999999 then
          counter <= (others => '0');
          btn_out <= '1';
        else
          counter <= counter + 1;
        end if;
      else
        counter <= (others => '0');
      end if;
    end if;
  end process countHighCycles;

end architecture arch;