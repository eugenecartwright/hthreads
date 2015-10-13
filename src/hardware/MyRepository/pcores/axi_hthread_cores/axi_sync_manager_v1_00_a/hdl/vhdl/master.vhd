-------------------------------------------------------------------------------------
-- Copyright (c) 2015, University of Arkansas - Hybridthreads Group
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice,
--       this list of conditions and the following disclaimer in the documentation
--       and/or other materials provided with the distribution.
--     * Neither the name of the University of Arkansas nor the name of the
--       Hybridthreads Group nor the names of its contributors may be used to
--       endorse or promote products derived from this software without specific
--       prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
-- ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.common.all;

entity master is
    generic
    (
        C_BASEADDR          : std_logic_vector  := x"00000000";
        C_HIGHADDR          : std_logic_vector  := x"FFFFFFFF";
        C_SCHED_BASEADDR    : std_logic_vector  := x"00000000";
        C_RESULT_BASEADDR   : std_logic_vector  := x"00000000";

        C_NUM_THREADS       : integer   := 256;
        C_NUM_MUTEXES       : integer   := 64;

        C_AWIDTH            : integer   := 32;
        C_DWIDTH            : integer   := 32;
        C_MAX_AR_DWIDTH     : integer   := 32;
        C_NUM_ADDR_RNG      : integer   := 6;
        C_NUM_CE            : integer   := 4
    );
    port
    (
        Bus2IP_Clk          :  in std_logic;
        Bus2IP_Reset        :  in std_logic;
--        Bus2IP_MstLastAck   :  in std_logic;
--        IP2Bus_Addr         : out std_logic_vector(0 to C_AWIDTH-1);
--        IP2Bus_MstBE        : out std_logic_vector(0 to C_DWIDTH/8-1);
--        IP2Bus_MstBurst     : out std_logic;
--        IP2Bus_MstBusLock   : out std_logic;
--        IP2Bus_MstRdReq     : out std_logic;
--        IP2Bus_MstWrReq     : out std_logic;
--        IP2IP_Addr          : out std_logic_vector(0 to C_AWIDTH-1);

        IP2Bus_MstRd_Req               : out std_logic;
        IP2Bus_MstWr_Req               : out std_logic;
        IP2Bus_Mst_Addr                : out std_logic_vector(0 to C_AWIDTH-1);
        IP2Bus_Mst_BE                  : out std_logic_vector(0 to C_DWIDTH/8-1);
        IP2Bus_Mst_Lock                : out std_logic;
        IP2Bus_Mst_Reset               : out std_logic;
        Bus2IP_Mst_CmdAck              : in  std_logic;
        Bus2IP_Mst_Cmplt               : in  std_logic;
        Bus2IP_Mst_Error               : in  std_logic;
        Bus2IP_Mst_Rearbitrate         : in  std_logic;
        Bus2IP_Mst_Cmd_Timeout         : in  std_logic;
        Bus2IP_MstRd_d                 : in  std_logic_vector(0 to C_DWIDTH-1);
        Bus2IP_MstRd_src_rdy_n         : in  std_logic;
        IP2Bus_MstWr_d                 : out std_logic_vector(0 to C_DWIDTH-1);
        Bus2IP_MstWr_dst_rdy_n         : in  std_logic;

        system_reset        :  in std_logic;
        system_resetdone    : out std_logic;

        send_ena            : in  std_logic;
        send_id             : in  std_logic_vector(0 to log2(C_NUM_THREADS)-1);
        send_ack            : out std_logic;

        saddr              : out std_logic_vector(0 to log2(C_NUM_THREADS)-1);
        sena               : out std_logic;
        swea               : out std_logic;
        sonext             : out std_logic_vector(0 to log2(C_NUM_THREADS)-1);
        sinext             :  in std_logic_vector(0 to log2(C_NUM_THREADS)-1)
    );
end master;

architecture behavioral of master is
    constant THR_BIT        : integer   := log2( C_NUM_THREADS );

    type send_state is
    (
        IDLE,
        SENDING,
        FINISH
    );

    type queue_state is
    (
        IDLE,
        DONE,
        GETWAIT,
        GETDONE
    );

    signal mst_cmplt    : std_logic := '0';

    signal send_cs      : send_state;
    signal send_ns      : send_state;
    signal queue_cs     : queue_state;
    signal queue_ns     : queue_state;
    signal send_rdy     : std_logic;
    signal send_valid   : std_logic;
    signal send_validn  : std_logic;

    signal send_cur     : std_logic_vector(0 to THR_BIT-1);
    signal send_curn    : std_logic_vector(0 to THR_BIT-1);
    signal send_first   : std_logic_vector(0 to THR_BIT-1);
    signal send_firstn  : std_logic_vector(0 to THR_BIT-1);
    signal send_last    : std_logic_vector(0 to THR_BIT-1);
    signal send_lastn   : std_logic_vector(0 to THR_BIT-1);
    signal send_count   : std_logic_vector(0 to THR_BIT-1);
    signal send_countn  : std_logic_vector(0 to THR_BIT-1);
begin
    -- System reset only takes one clock cycle so were always "done"
    system_resetdone    <= '1';

    queue_update : process(Bus2IP_Clk) is
    begin
        if( rising_edge(Bus2IP_Clk) ) then
            if( Bus2IP_Reset = '1' or system_reset = '1' ) then
                queue_cs       <= IDLE;
                send_count     <= (others => '0');
                send_first     <= (others => '0');
                send_last      <= (others => '0');
                send_cur       <= (others => '0');
                send_valid     <= '0';
            else
                queue_cs       <= queue_ns;
                send_count     <= send_countn;
                send_first     <= send_firstn;
                send_last      <= send_lastn;
                send_cur       <= send_curn;
                send_valid     <= send_validn;
            end if;
        end if;
    end process queue_update;

    queue_controller : process(Bus2IP_Clk,queue_cs, send_cur, send_last, send_first, send_count, send_ena, send_id, send_rdy, sinext) is
    begin
        sena        <= '0';
        swea        <= '0';
        saddr       <= (others => '0');
        sonext      <= (others => '0');
        queue_ns    <= queue_cs;
        send_curn   <= send_cur;
        send_lastn  <= send_last;
        send_firstn <= send_first;
        send_countn <= send_count;
        send_validn <= '0';

        case queue_cs is
            when IDLE =>
                if( send_ena = '1' ) then
                    if( send_count = zero(THR_BIT) ) then
                        send_firstn <= send_id;
                    else
                        sena        <= '1';
                        swea        <= '1';
                        saddr       <= send_last;
                        sonext      <= send_id;
                    end if;
                    send_lastn  <= send_id;
                    send_countn <= send_count+1;
                    send_ack    <= '1';
                    queue_ns    <= DONE;
                elsif( send_rdy = '1' and send_count /= zero(THR_BIT) ) then
                    send_curn   <= send_first;
                    send_validn <= '1';
                    sena        <= '1';
                    saddr       <= send_first;
                    queue_ns    <= GETWAIT;
                end if;

            when DONE =>
                send_ack <= '1';
                if( send_ena = '0' ) then
                    queue_ns <= IDLE;
                end if;

            when GETWAIT => null;
                queue_ns    <= GETDONE;

            when GETDONE =>
                send_firstn <= sinext;
                send_countn <= send_count-1;
                queue_ns    <= IDLE;
        end case;
    end process queue_controller;

    send_update : process (Bus2IP_Clk,send_ns) is
    begin
        if( rising_edge(Bus2IP_Clk) ) then
            if( Bus2IP_Reset = '1' or system_reset = '1' ) then
                send_cs     <= IDLE;
            else
                send_cs     <= send_ns;
            end if;
        end if;
    end process send_update;

    send_controller : process (Bus2IP_Mst_CmdAck, Bus2IP_MstRd_src_rdy_n, send_cs,send_valid,send_cur) is
    begin
        send_ns             <= send_cs;
        send_rdy            <= '0';
        IP2Bus_Mst_Addr         <= (others => '0');
        IP2Bus_Mst_BE        <= (others => '0');
        IP2Bus_MstRd_Req     <= '0';

        case send_cs is
            when IDLE =>
                send_rdy <= '1';
                if( send_valid = '1' ) then
                    send_ns <= SENDING;
                end if;

            when SENDING =>
                -- Capture the Bus2IP_Mst_Cmplt value for later.
                if (mst_cmplt = '0') then
                  mst_cmplt <= Bus2IP_Mst_Cmplt;
                end if;

                if (Bus2IP_Mst_CmdAck = '1') then
                  send_ns <= FINISH;
                else
                  IP2Bus_Mst_Addr <= add_thread(C_SCHED_BASEADDR,send_cur);
                  IP2Bus_MstRd_Req <= '1';
                  IP2Bus_Mst_BE <= "1111";
                  send_ns <= SENDING;
                end if;

            when FINISH =>
                if ((mst_cmplt = '1') or (Bus2IP_Mst_Cmplt = '1')) then
                  send_ns <= IDLE;
                else
                  send_ns <= FINISH;
                end if;

        end case;
    end process send_controller;
end behavioral;
