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

  signal idle_count : unsigned(26 downto 0);
  signal pkt_cnt : unsigned(1 downto 0);

  type fsm_type is (Idle, writeWord, resetTxFifo);
  signal current_state is fsm_type;

begin

  m_axi_wstrb   <= (others => '1');
  m_axi_bready  <= '1';
  m_axi_araddr  <= (others => '0');
  m_axi_rready  <= '1';
  m_axi_arvalid <= '0';

  -- Write out the packet in the order red value, green value, blue value
  writePacket : process(clk_100)
  begin
    if rising_edge(clk_100) then
      if rst_100 = '1' then
        current_state <= Idle;
        idle_count <= (others => '0');
        pkt_cnt <= (others => '0');
        m_axi_awaddr <= (others => '0');
        m_axi_awvalid <= '0';
        m_axi_wvalid <= '0';
      else
        m_axi_awvalid <= '0';
        m_axi_wvalid <= '0';
        case current_state is
          when Idle =>
            -- Send the new values every second
            if idle_count = INTER_PACKET_PERIOD then
              current_state <= writeWord;
              idle_count <= (others => '0');
            else
              idle_count <= idle_count + 1;
            end if;
          when writeWord =>
            m_axi_awaddr <= x"4";
            m_axi_awvalid <= '1';
            m_axi_wvalid <= '1';
            if m_axi_bvalid = '1' then
              if m_axi_bresp /= "00" then
                current_state <= resetTxFifo;
                pkt_cnt <= (others => '0');
                m_axi_wvalid <= '0';
                m_axi_awvalid <= '0';
              else
                if pkt_cnt = 2 then
                  pkt_cnt <= (others => '0');
                  current_state <= Idle;
                  m_axi_wvalid <= '0';
                  m_axi_awvalid <= '0';
                else
                  pkt_cnt <= pkt_cnt + 1;
                end if;
              end if;
            end if;
          when resetTxFifo =>
            m_axi_awaddr <= x"C";
            m_axi_awvalid <= '1';
            m_axi_wvalid <= '1';
            if m_axi_bvalid = '1' then
              current_state <= Idle;
              m_axi_awvalid <= '0';
              m_axi_wvalid <= '0';
            end if;
          when others =>
            current_state <= Idle;
        end case;
      end if;
    end if;
  end process writePacket;

  -- output data depending on which word of the packet is being written
  m_axi_wdata   <= x"00000001" when current_state <= resetTxFifo else
                   x"0000001" & tx_red when pkt_cnt = 0 else
                   x"0000002" & tx_green when pkt_cnt = 1 else
                   x"0000004" & tx_blue when pkt_cnt = 2 else
                   (others => '0');

end architecture arch;