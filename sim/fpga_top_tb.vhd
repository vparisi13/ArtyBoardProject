-- Simulating the transmit of the uart data from
-- the top level of the FPGA.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity fpga_top_tb is
end entity fpga_top_tb;

architecture arch of fpga_top_tb is

  signal clk_100  : std_logic;
  signal rst_100  : std_logic;
  signal axi_rst_n : std_logic;
  signal btns     : std_logic_vector(2 downto 0);
  signal switches : std_logic_vector(3 downto 0);

  signal uart_axi_arvalid : std_logic;
  signal uart_axi_arready : std_logic;
  signal uart_axi_rdata   : std_logic_vector(31 downto 0);
  signal uart_axi_rvalid  : std_logic;

  component uart_interface
    port(
      s_axi_aclk    : in  std_logic;
      s_axi_aresetn : in  std_logic;
      interrupt     : out std_logic;
      s_axi_awaddr  : in  std_logic_vector(3 downto 0);
      s_axi_awvalid : in  std_logic;
      s_axi_awready : out std_logic;
      s_axi_wdata   : in  std_logic_vector(31 downto 0);
      s_axi_wstrb   : in  std_logic_vector(3 downto 0);
      s_axi_wvalid  : in  std_logic;
      s_axi_wready  : out std_logic;
      s_axi_bresp   : out std_logic_vector(1 downto 0);
      s_axi_bvalid  : out std_logic;
      s_axi_bready  : in  std_logic;
      s_axi_araddr  : in  std_logic_vector(3 downto 0);
      s_axi_arvalid : in  std_logic;
      s_axi_arready : out std_logic;
      s_axi_rdata   : out std_logic_vector(31 downto 0);
      s_axi_rresp   : out std_logic_vector(1 downto 0);
      s_axi_rvalid  : out std_logic;
      s_axi_rready  : in  std_logic;
      rx            : in  std_logic;
      tx            : out std_logic
    );
  end component;

begin

-- Generate 100MHz clock
  genClk100 : process
  begin
    clk_100 <= '1';
    wait for 5 ns;
    clk_100 <= '0';
    wait for 5 ns;
  end process genClk100;

-- Generate 100MHz reset
  rstGen100 : process
  begin
    rst_100 <= '1';
    for i in 0 to 19 loop
      wait until rising_edge(clk_100);
    end loop;
    rst_100 <= '0';
    wait;
  end process rstGen100;

  testProcess : process
  begin
    btns <= (others => '0');
    switches <= (others => '0');
    report "TEST FINISHED" severity failure;
    wait;
  end process testProcess;

-- Instantiate the top of the fpga
  dut : entity xil_defaultlib.fpga_top
    port map(
      clk_100  => clk_100,
      btns(0)  => rst_100,
      btns(3 downto 1) => btns,
      switches => switches,
      uart_tx  => uart_tx
    );

  -- NEED TO WRITE PROCESS TO POLL THE READ FIFO OF
  -- THE UART INTERFACE TO CHECK FOR VALID DATA.
  -- THEN READ THE VALID DATA. REPEAT

-- Test uart interface.
  axi_rst_n <= not rst_100;

  uart_read_interface : uart_interface
    port map(
      s_axi_aclk    => clk_100,
      s_axi_aresetn => axi_rst_n,
      interrupt     => open,
      s_axi_awaddr  => x"0",
      s_axi_awvalid => '0',
      s_axi_awready => open,
      s_axi_wdata   => (others => '0'),
      s_axi_wstrb   => (others => '0'),
      s_axi_wvalid  => '0',
      s_axi_wready  => open,
      s_axi_bresp   => "00",
      s_axi_bvalid  => open,
      s_axi_bready  => '1',
      s_axi_araddr  => x"0",
      s_axi_arvalid => uart_axi_arvalid,
      s_axi_arready => uart_axi_arready,
      s_axi_rdata   => uart_axi_rdata,
      s_axi_rresp   => open,
      s_axi_rvalid  => uart_axi_rvalid,
      s_axi_rready  => '1',
      rx            => '0',
      tx            => uart_tx
    );

end architecture arch;