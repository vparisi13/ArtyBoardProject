-- Generate AXI packets for transmit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;

entity tx_packet_gen is
  generic(
    INTER_PACKET_PERIOD : integer range 1000 to 100000000 -- Generate a packet every this many cycles
  );
  port(
    -- Clocks and resets
    clk_100       : in  std_logic;
    rst_100       : in  std_logic;
    -- values to set LEDs to
    tx_red        : in  std_logic_vector(3 downto 0);
    tx_green      : in  std_logic_vector(3 downto 0);
    tx_blue       : in  std_logic_vector(3 downto 0);
    -- AXI signals
    m_axi_awaddr  : out std_logic_vector(3 downto 0);
    m_axi_awvalid : out std_logic;
    m_axi_awready : in  std_logic;
    m_axi_wdata   : out std_logic_vector(31 downto 0);
    m_axi_wstrb   : out std_logic_vector(3 downto 0);
    m_axi_wvalid  : out std_logic;
    m_axi_wready  : in  std_logic;
    m_axi_bresp   : in  std_logic_vector(1 downto 0);
    m_axi_bvalid  : in  std_logic;
    m_axi_bready  : out std_logic;
    m_axi_araddr  : out std_logic_vector(3 downto 0);
    m_axi_arvalid : out std_logic;
    m_axi_arready : in  std_logic;
    m_axi_rdata   : in  std_logic_vector(31 downto 0);
    m_axi_rresp   : in  std_logic_vector(1 downto 0);
    m_axi_rvalid  : in  std_logic;
    m_axi_rready  : out std_logic
  );
end entity tx_packet_gen;

architecture arch of tx_packet_gen is

  signal counter    : unsigned(26 downto 0);
  signal gen_packet : std_logic;

  signal pkt_cnt : unsigned(1 downto 0);
  signal tvalid  : std_logic;

begin

  -- Wait a given interval before sending a packet
  interPacketCount : process(clk_100)
  begin
    if rising_edge(clk_100) then
      if rst_100 = '1' then
        counter <= (others => '0');
        gen_packet <= '0';
      else
        gen_packet <= '0';
        if counter = INTER_PACKET_PERIOD-1 then
          counter <= (others => '0');
          gen_packet <= '1';
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process interPacketCount;

  -- Write out the packet in the order red value, green value, blue value
  writePacket : process(clk_100)
  begin
    if rising_edge(clk_100) then
      if rst_100 = '1' then
        tvalid <= '0';
      else
        

        -- Write state machine for Idle, write word, get response



      end if;
    end if;
  end process writePacket;

  -- output data depending on which word of the packet is being written
  m_axi_wdata   <= x"000000" & tx_red when pkt_cnt = 1 else
                   x"000000" & tx_green when pkt_cnt = 2 else
                   x"000000" & tx_blue when pkt_cnt = 3 else
                   (others => '0');
  m_axi_wvalid  <= tvalid;
  m_axi_awvalid <= tvalid;
  m_axi_awaddr  <= x"4";
  m_axi_wstrb   <= x"F";


  m_axi_bresp   
  m_axi_bvalid  
  m_axi_bready  
  m_axi_araddr  
  m_axi_arvalid 
  m_axi_arready 
  m_axi_rdata   
  m_axi_rresp   
  m_axi_rvalid  
  m_axi_rready  

  m_axi_wready  
  m_axi_awready 

end architecture arch;