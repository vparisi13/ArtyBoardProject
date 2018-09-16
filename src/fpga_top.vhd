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

  signal rst_100  : std_logic := '1';
  signal tx_red   : std_logic_vector(3 downto 0);
  signal tx_green : std_logic_vector(3 downto 0);
  signal tx_blue  : std_logic_vector(3 downto 0);

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
      tx_red   => tx_red,
      tx_green => tx_green,
      tx_blue  => tx_blue
    );










  uart_interface_inst : uart_interface
    port map(
      s_axi_aclk    => ,
      s_axi_aresetn => ,
      interrupt     => ,
      s_axi_awaddr  => ,
      s_axi_awvalid => ,
      s_axi_awready => ,
      s_axi_wdata   => ,
      s_axi_wstrb   => ,
      s_axi_wvalid  => ,
      s_axi_wready  => ,
      s_axi_bresp   => ,
      s_axi_bvalid  => ,
      s_axi_bready  => ,
      s_axi_araddr  => ,
      s_axi_arvalid => ,
      s_axi_arready => ,
      s_axi_rdata   => ,
      s_axi_rresp   => ,
      s_axi_rvalid  => ,
      s_axi_rready  => ,
      rx            => ,
      tx            => 
    );





end architecture arch;