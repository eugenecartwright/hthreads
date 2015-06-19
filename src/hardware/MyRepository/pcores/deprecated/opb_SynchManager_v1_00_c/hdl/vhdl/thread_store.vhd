-------------------------------------------------------------------------------------
-- Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
--     * Neither the name of the University of Kansas nor the name of the
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

entity thread_store is
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

        tiaddr          :  in std_logic_vector(0 to C_TWIDTH-1);
        tiena           :  in std_logic;
        tiwea           :  in std_logic;
        tinext          :  in std_logic_vector(0 to C_TWIDTH-1);
        tonext          : out std_logic_vector(0 to C_TWIDTH-1)
    );
end thread_store;

architecture behavioral of thread_store is
    -- Calculate the number of mutexes to use
    constant THREADS : integer := pow2( C_TWIDTH );

    -- Constant for the last location to be reset
    constant RST_END : std_logic_vector(0 to C_TWIDTH-1) := (others => '1');

    -- Declare a storage area for the mutex data
    type tstore is array(0 to THREADS-1) of std_logic_vector(0 to C_TWIDTH-1);

    -- Declare signals for the mutex storage area
    signal store    : tstore;
    signal tena     : std_logic;
    signal twea     : std_logic;
    signal taddr    : std_logic_vector(0 to C_TWIDTH - 1);
    signal tinput   : std_logic_vector(0 to C_TWIDTH - 1);
    signal toutput  : std_logic_vector(0 to C_TWIDTH - 1);

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
    tonext  <= toutput(0 to C_TWIDTH-1);

    thread_mux : process(clk,rst,sysrst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                tena    <= rena;
                twea    <= rwea;
                taddr   <= raddr;
                tinput  <= rnext;
            else
                tena    <= tiena;
                twea    <= tiwea;
                taddr   <= tiaddr;
                tinput  <= tinext;
            end if;
        end if;
    end process thread_mux;

    thread_reset_controller : process(clk,rst,sysrst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                rst_cs  <= RESET;
                raddr   <= raddrn;
            else
                rst_cs  <= IDLE;
            end if;
        end if;
    end process thread_reset_controller;

    thread_reset_logic : process(rst_cs,raddr) is
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
    end process thread_reset_logic;

    thread_store_controller : process (clk) is
        variable output : std_logic_vector(0 to C_TWIDTH-1);
    begin
        if( rising_edge(clk) ) then
            if( tena = '1' ) then
                if( twea = '1' ) then
                    store( conv_integer(taddr) ) <=  tinput;
                end if;

                toutput <= store( conv_integer(taddr) );
            end if;
        end if;
    end process thread_store_controller;
end behavioral;
