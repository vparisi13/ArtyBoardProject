-- Generate a reset on startup or any time btn0 is pushed
-- Each reset should be at 100 cycles @100MHz

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rst_gen is
  port(
    clk_100 : in  std_logic;
    btn0    : in  std_logic;
    rst_100 : out std_logic
  );
end entity rst_gen;

architecture arch of rst_gen is

  signal btn_reg   : std_logic := '0';
  signal local_rst : std_logic := '1';
  signal rst_cnt   : unsigned(6 downto 0) := (others => '0');

begin

  edgeDetect : process(clk_100)
  begin
    if rising_edge(clk) then
      btn_reg <= btn0;
      if local_rst = '1' then
        if rst_cnt = 100 then
          rst_cnt <= (others => '0');
          local_rst <= '0';
        else
          Rst_cnt <= rst_cnt + 1;
        end if;
      elsif btn_reg = '0' and btn0 = '1' then
        local_rst <= '1';
      end if;
    end if;
  end process edgeDetect;

  rst_100 <= local_rst;

end architecture arch;