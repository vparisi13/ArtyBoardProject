-- Generate a reset on startup or any time btn is pushed
-- Each reset should be at 100 cycles @100MHz

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity rst_gen is
  port(
    clk_100 : in  std_logic;
    btn     : in  std_logic;
    rst_100 : out std_logic
  );
end entity rst_gen;

architecture arch of rst_gen is

  signal debounced_btn : std_logic;
  signal local_rst : std_logic := '1';
  signal rst_cnt   : unsigned(6 downto 0) := (others => '0');

begin

  debounceInst : entity xil_defaultlib.debounce_button
    port map(
      clk_100 => clk_100,
      btn_in  => btn,
      btn_out => debounced_btn
    );

  edgeDetect : process(clk_100)
  begin
    if rising_edge(clk) then
      if local_rst = '1' then
        if rst_cnt = 100 then
          rst_cnt <= (others => '0');
          local_rst <= '0';
        else
          rst_cnt <= rst_cnt + 1;
        end if;
      elsif debounced_btn = '1' then
        local_rst <= '1';
      end if;
    end if;
  end process edgeDetect;

  rst_100 <= local_rst;

end architecture arch;