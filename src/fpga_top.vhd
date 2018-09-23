-- TOP LEVEL OF ARTIX 7 FPGA on ARTY BOARD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity fpga_top is
  port(
    clk_100  : in  std_logic;
    btns     : in  std_logic_vector(3 downto 0);
    switches : in  std_logic_vector(3 downto 0);
    uart_tx  : out std_logic
  );
end entity fpga_top;

architecture arch of fpga_top is

  signal rst_100  : std_logic := '1';
  signal tx_red   : std_logic_vector(3 downto 0);
  signal tx_green : std_logic_vector(3 downto 0);
  signal tx_blue  : std_logic_vector(3 downto 0);

  signal uart_interrupt : std_logic;
  signal axi_rst_n      : std_logic;

  signal uart_axi_awaddr  : std_logic_vector(3 downto 0);
  signal uart_axi_awvalid : std_logic;
  signal uart_axi_awready : std_logic;
  signal uart_axi_wdata   : std_logic_vector(31 downto 0);
  signal uart_axi_wstrb   : std_logic_vector(3 downto 0);
  signal uart_axi_wvalid  : std_logic;
  signal uart_axi_wready  : std_logic;
  signal uart_axi_bresp   : std_logic_vector(1 downto 0);
  signal uart_axi_bvalid  : std_logic;
  signal uart_axi_bready  : std_logic;
  signal uart_axi_araddr  : std_logic_vector(3 downto 0);
  signal uart_axi_arvalid : std_logic;
  signal uart_axi_arready : std_logic;
  signal uart_axi_rdata   : std_logic_vector(31 downto 0);
  signal uart_axi_rresp   : std_logic_vector(1 downto 0);
  signal uart_axi_rvalid  : std_logic;
  signal uart_axi_rready  : std_logic

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

-- Generate a 3 word packet containing the rgb data
  tx_pkt_gen : entity xil_defaultlib.tx_packet_gen
    generic map(
      INTER_PACKET_PERIOD => 100_000_000
    )
    port map(
      clk_100       => clk_100,
      rst_100       => rst_100,
      tx_red        => tx_red,
      tx_green      => tx_green,
      tx_blue       => tx_blue,
      m_axi_awaddr  => uart_axi_awaddr,
      m_axi_awvalid => uart_axi_awvalid,
      m_axi_awready => uart_axi_awready,
      m_axi_wdata   => uart_axi_wdata,
      m_axi_wstrb   => uart_axi_wstrb,
      m_axi_wvalid  => uart_axi_wvalid,
      m_axi_wready  => uart_axi_wready,
      m_axi_bresp   => uart_axi_bresp,
      m_axi_bvalid  => uart_axi_bvalid,
      m_axi_bready  => uart_axi_bready,
      m_axi_araddr  => uart_axi_araddr,
      m_axi_arvalid => uart_axi_arvalid,
      m_axi_arready => uart_axi_arready,
      m_axi_rdata   => uart_axi_rdata,
      m_axi_rresp   => uart_axi_rresp,
      m_axi_rvalid  => uart_axi_rvalid,
      m_axi_rready  => uart_axi_rready
    );

-- AXI uses an active low reset
  axi_rst_n <= not rst_100;

-- Turn the packetized rgb data into uart
  uart_interface_inst : uart_interface
    port map(
      s_axi_aclk    => clk_100,
      s_axi_aresetn => axi_rst_n,
      interrupt     => uart_interrupt,
      s_axi_awaddr  => uart_axi_awaddr,
      s_axi_awvalid => uart_axi_awvalid,
      s_axi_awready => uart_axi_awready,
      s_axi_wdata   => uart_axi_wdata,
      s_axi_wstrb   => uart_axi_wstrb,
      s_axi_wvalid  => uart_axi_wvalid,
      s_axi_wready  => uart_axi_wready,
      s_axi_bresp   => uart_axi_bresp,
      s_axi_bvalid  => uart_axi_bvalid,
      s_axi_bready  => uart_axi_bready,
      s_axi_araddr  => uart_axi_araddr,
      s_axi_arvalid => uart_axi_arvalid,
      s_axi_arready => uart_axi_arready,
      s_axi_rdata   => uart_axi_rdata,
      s_axi_rresp   => uart_axi_rresp,
      s_axi_rvalid  => uart_axi_rvalid,
      s_axi_rready  => uart_axi_rready,
      rx            => '0',
      tx            => uart_tx
    );

end architecture arch;