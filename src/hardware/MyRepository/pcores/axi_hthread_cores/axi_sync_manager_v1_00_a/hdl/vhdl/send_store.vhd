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

entity send_store is
    generic
    (
        C_AWIDTH        : integer   := 32;
        C_DWIDTH        : integer   := 32;
        C_TWIDTH        : integer   := 8;
        C_MWIDTH        : integer   := 6;
        C_CWIDTH        : integer   := 8
    );
    port
    (
        clk             :  in std_logic;
        rst             :  in std_logic;

        sysrst          :  in std_logic;
        rstdone         : out std_logic;

        siaddr          :  in std_logic_vector(0 to C_TWIDTH-1);
        siena           :  in std_logic;
        siwea           :  in std_logic;
        sinext          :  in std_logic_vector(0 to C_TWIDTH-1);
        sonext          : out std_logic_vector(0 to C_TWIDTH-1)
    );
end send_store;

architecture behavioral of send_store is
    -- Calculate the number of mutexes to use
    constant THREADS : integer := pow2( C_TWIDTH );

    -- Constant for the last location to be reset
    constant RST_END : std_logic_vector(0 to C_TWIDTH-1) := (others => '1');

    -- Declare a storage area for the mutex data
    type tstore is array(0 to THREADS-1) of std_logic_vector(0 to C_TWIDTH-1);

    -- Declare signals for the mutex storage area
    signal store    : tstore;
    signal sena     : std_logic;
    signal swea     : std_logic;
    signal saddr    : std_logic_vector(0 to C_TWIDTH - 1);
    signal sinput   : std_logic_vector(0 to C_TWIDTH - 1);
    signal soutput  : std_logic_vector(0 to C_TWIDTH - 1);

    -- Type for the reset state machine
    type rststate is
    (
        IDLE,
        RESET
    );

    -- Declare signals for the reset
    signal rst_cs   : rststate;
    signal rena     : std_logic;
    signal rwea     : std_logic;
    signal raddr    : std_logic_vector(0 to C_TWIDTH - 1);
    signal raddrn   : std_logic_vector(0 to C_TWIDTH - 1);
    signal rnext    : std_logic_vector(0 to C_TWIDTH - 1);
begin
    sonext  <= soutput(0 to C_TWIDTH-1);

    send_mux : process(clk,rst,sysrst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                sena    <= rena;
                swea    <= rwea;
                saddr   <= raddr;
                sinput  <= rnext;
            else
                sena    <= siena;
                swea    <= siwea;
                saddr   <= siaddr;
                sinput  <= sinext;
            end if;
        end if;
    end process send_mux;

    send_reset_controller : process(clk,rst,sysrst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                rst_cs  <= RESET;
                raddr   <= raddrn;
            else
                rst_cs  <= IDLE;
            end if;
        end if;
    end process send_reset_controller;

    send_reset_logic : process(rst_cs,raddr) is
    begin
        rena    <= '1';
        rwea    <= '1';
        rstdone <= '1';
        rnext   <= (others => '0');

        case rst_cs is
            when IDLE =>
                raddrn <= (others => '0');

            when RESET =>
                if( raddr = RST_END ) then
                    raddrn  <= raddr;
                else
                    rstdone <= '0';
                    raddrn  <= raddr + 1;
                end if;
        end case;
    end process send_reset_logic;

    send_store_controller : process (clk) is
        variable output : std_logic_vector(0 to C_TWIDTH-1);
    begin
        if( rising_edge(clk) ) then
            if( sena = '1' ) then
                if( swea = '1' ) then
                    store( conv_integer(saddr) ) <=  sinput;
                end if;

                soutput <= store( conv_integer(saddr) );
            end if;
        end if;
    end process send_store_controller;
end behavioral;
