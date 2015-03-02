library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_AWIDTH                     -- User logic address bus width
--   C_DWIDTH                     -- User logic data bus width
--   C_NUM_CE                     -- User logic chip enable bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_BE                    -- Bus to IP byte enables for user logic
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   Bus2IP_MstError              -- Bus to IP master error
--   Bus2IP_MstLastAck            -- Bus to IP master last acknowledge
--   Bus2IP_MstRdAck              -- Bus to IP master read acknowledge
--   Bus2IP_MstWrAck              -- Bus to IP master write acknowledge
--   Bus2IP_MstRetry              -- Bus to IP master retry
--   Bus2IP_MstTimeOut            -- Bus to IP mster timeout
--   IP2Bus_Addr                  -- IP to Bus address for the master transaction
--   IP2Bus_MstBE                 -- IP to Bus byte-enables qualifiers
--   IP2Bus_MstBurst              -- IP to Bus burst qualifier
--   IP2Bus_MstBusLock            -- IP to Bus bus-lock qualifier
--   IP2Bus_MstNum                -- IP to Bus burst size indicator
--   IP2Bus_MstRdReq              -- IP to Bus master read request
--   IP2Bus_MstWrReq              -- IP to Bus master write request
--   IP2IP_Addr                   -- IP to IP local device address for the master transaction
------------------------------------------------------------------------------
entity memory is
    generic
    (
        MEM_ADDR : std_logic_vector := x"00000000";
        C_AWIDTH : integer := 32;
        C_DWIDTH : integer := 64;
        C_NUM_CE : integer := 8
    );
    port
    ( 
        clk               :  in std_logic;
        rst               :  in std_logic;

        rd                :  in std_logic;
        wr                :  in std_logic;
        addr              :  in std_logic_vector(0 to C_AWIDTH-1);
        length            :  in std_logic_vector(0 to 23);
        ack               : out std_logic;
        last              : out std_logic;

    --Bus2IP_Data                    : in  std_logic_vector(0 to C_DWIDTH-1);
    --Bus2IP_BE                      : in  std_logic_vector(0 to C_DWIDTH/8-1);
    --Bus2IP_Burst                   : in  std_logic;
    --Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
    --Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
    --Bus2IP_RdReq                   : in  std_logic;
    --Bus2IP_WrReq                   : in  std_logic;
    --IP2Bus_Data                    : out std_logic_vector(0 to C_DWIDTH-1);
    --IP2Bus_Retry                   : out std_logic;
    --IP2Bus_Error                   : out std_logic;
    --IP2Bus_ToutSup                 : out std_logic;
    --IP2Bus_RdAck                   : out std_logic;
    --IP2Bus_WrAck                   : out std_logic;

        Bus2IP_MstError   : in  std_logic;
        Bus2IP_MstLastAck : in  std_logic;
        Bus2IP_MstRdAck   : in  std_logic;
        Bus2IP_MstWrAck   : in  std_logic;
        Bus2IP_MstRetry   : in  std_logic;
        Bus2IP_MstTimeOut : in  std_logic;

        IP2Bus_Addr       : out std_logic_vector(0 to C_AWIDTH-1);
        IP2Bus_MstBE      : out std_logic_vector(0 to C_DWIDTH/8-1);
        IP2Bus_MstBurst   : out std_logic;
        IP2Bus_MstBusLock : out std_logic;
        IP2Bus_MstNum     : out std_logic_vector(0 to 4);
        IP2Bus_MstRdReq   : out std_logic;
        IP2Bus_MstWrReq   : out std_logic;
        IP2IP_Addr        : out std_logic_vector(0 to C_AWIDTH-1)
    );
end entity memory;

architecture behavioral of memory is
    type state is
    (
        IDLE,
        SINGLE,
        BURST,
        LASTMEM,
        CHECK
    );

    signal go       : std_logic;
    signal mbrst_cv : std_logic;
    signal mbrst_nv : std_logic;

    signal rd_cv    : std_logic;
    signal rd_nv    : std_logic;
    signal wr_cv    : std_logic;
    signal wr_nv    : std_logic;

    signal mem_cs   : state;
    signal mem_ns   : state;

    signal count_cv : std_logic_vector(0 to 23);
    signal count_nv : std_logic_vector(0 to 23);

    signal baddr_cv : std_logic_vector(0 to 31);
    signal baddr_nv : std_logic_vector(0 to 31);

    signal be_cv    : std_logic_vector(0 to 7);
    signal be_nv    : std_logic_vector(0 to 7);

    signal burst_cv : std_logic_vector(0 to 4);
    signal burst_nv : std_logic_vector(0 to 4);
begin
    IP2Bus_Addr        <= baddr_cv;
    IP2Bus_MstBurst    <= mbrst_nv;
    IP2Bus_MstBE       <= be_cv;
    IP2Bus_MstBusLock  <= '0';
    IP2Bus_MstNum      <= burst_nv;
    IP2IP_Addr         <= MEM_ADDR;
    ack                <= Bus2IP_MstRdAck or Bus2IP_MstWrAck;
    go                 <= rd or wr;

    update : process(clk,rst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' ) then
                IP2Bus_MstRdReq    <= '0';
                IP2Bus_MstWrReq    <= '0';
                mbrst_cv           <= '0';
                rd_cv              <= '0';
                wr_cv              <= '0';
                be_cv              <= (others => '0');

                mem_cs   <= IDLE;
                count_cv <= (others => '0');
                baddr_cv <= (others => '0');
                burst_cv <= (others => '0');
            else
                IP2Bus_MstRdReq    <= rd_nv;
                IP2Bus_MstWrReq    <= wr_nv;
                mbrst_cv           <= mbrst_nv;

                be_cv    <= be_nv;
                rd_cv    <= rd_nv;
                wr_cv    <= wr_nv;
                mem_cs   <= mem_ns;
                count_cv <= count_nv;
                baddr_cv <= baddr_nv;
                burst_cv <= burst_nv;
            end if;
        end if;
    end process update;

    controller : process(mem_cs,count_cv,baddr_cv,burst_cv,go,length,addr,
                         Bus2IP_MstLastAck,rd_cv,wr_cv,rd,wr,be_cv) is
    begin
        mbrst_nv <= '0';
        last     <= '0';
        rd_nv    <= rd_cv;
        wr_nv    <= wr_cv;
        be_nv    <= be_cv;
        mem_ns   <= mem_cs;
        count_nv <= count_cv;
        baddr_nv <= baddr_cv;
        burst_nv <= burst_cv;

        case mem_cs is
        when IDLE =>
            rd_nv <= rd;
            wr_nv <= wr;
            if( go = '1' ) then
                count_nv <= length;
                baddr_nv <= addr;
                mem_ns   <= CHECK;
                if( length(23) = '1' ) then
                    case addr(29 to 31) is
                    when "000"  => be_nv <= x"80";
                    when "001"  => be_nv <= x"40";
                    when "010"  => be_nv <= x"20";
                    when "011"  => be_nv <= x"10";
                    when "100"  => be_nv <= x"08";
                    when "101"  => be_nv <= x"04";
                    when "110"  => be_nv <= x"02";
                    when others => be_nv <= x"01";
                    end case;
                elsif( length(22) = '1' ) then
                    case addr(29 to 30) is
                    when "00"   => be_nv <= x"C0";
                    when "01"   => be_nv <= x"30";
                    when "10"   => be_nv <= x"0C";
                    when others => be_nv <= x"03";
                    end case;
                elsif( length(21) = '1') then
                    case addr(29) is
                    when '0'    => be_nv <= x"F0";
                    when others => be_nv <= x"0F";
                    end case;
                else
                    be_nv <= x"FF";
                end if;
            end if;

        when SINGLE =>
            if ( Bus2IP_MstLastAck = '1' ) then
                rd_nv    <= '0';
                wr_nv    <= '0';
                mem_ns   <= IDLE;
                last     <= '1';
            else
                burst_nv <= "00001";
            end if;

        when BURST =>
            mbrst_nv <= '1';
            if ( Bus2IP_MstLastAck = '1' ) then
                mem_ns   <= CHECK;
                count_nv <= count_cv - 128;
                baddr_nv <= baddr_cv + 128;
            else
                burst_nv <= "10000";
            end if;

        when LASTMEM =>
            mbrst_nv <= '1';
            if ( Bus2IP_MstLastAck = '1' ) then
                count_nv <= (others => '0');
                last     <= '1';
                rd_nv    <= '0';
                wr_nv    <= '0';
                mem_ns   <= IDLE;
            else
                burst_nv <= count_cv(16 to 20);
            end if;

        when CHECK =>
            if ( count_cv = 0 ) then
                mem_ns   <= IDLE;
                rd_nv    <= '0';
                wr_nv    <= '0';
                last     <= '1';
            elsif ( count_cv <= 8 ) then
                burst_nv <= "00001";
                mem_ns   <= SINGLE;
            elsif ( count_cv <= 128 ) then
                mbrst_nv <= '1';
                burst_nv <= count_cv(16 to 20);
                mem_ns   <= LASTMEM;
            else
                mbrst_nv <= '1';
                burst_nv <= "10000";
                mem_ns   <= BURST;
            end if;

        when others =>
            mem_ns  <= IDLE;
        end case;
    end process controller;
end behavioral;
