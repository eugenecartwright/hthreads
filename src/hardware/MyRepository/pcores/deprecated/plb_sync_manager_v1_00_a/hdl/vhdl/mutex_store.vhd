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

entity mutex_store is
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

        miaddr          :  in std_logic_vector(0 to C_MWIDTH-1);
        miena           :  in std_logic;
        miwea           :  in std_logic;
        miowner         :  in std_logic_vector(0 to C_TWIDTH-1);
        minext          :  in std_logic_vector(0 to C_TWIDTH-1);
        milast          :  in std_logic_vector(0 to C_TWIDTH-1);
        mikind          :  in std_logic_vector(0 to 1);
        micount         :  in std_logic_vector(0 to C_CWIDTH-1);

        sysrst          :  in std_logic;
        rstdone         : out std_logic;

        moowner         : out std_logic_vector(0 to C_TWIDTH-1);
        monext          : out std_logic_vector(0 to C_TWIDTH-1);
        molast          : out std_logic_vector(0 to C_TWIDTH-1);
        mokind          : out std_logic_vector(0 to 1);
        mocount         : out std_logic_vector(0 to C_CWIDTH-1)
    );
end mutex_store;

architecture behavioral of mutex_store is
    -- Calculate the number of mutexes to use
    constant MUTEXES : integer := pow2( C_MWIDTH );

    -- Constant for the last position to be reset
    constant RST_END : std_logic_vector(0 to C_MWIDTH-1) := (others => '1');

    -- Calculate the beginning and ending bit positions for data
    constant OWN_SRT : integer  := 0;
    constant OWN_END : integer  := OWN_SRT + C_TWIDTH-1;
    constant NXT_SRT : integer  := OWN_END+1;
    constant NXT_END : integer  := NXT_SRT + C_TWIDTH-1;
    constant LST_SRT : integer  := NXT_END+1;
    constant LST_END : integer  := LST_SRT + C_TWIDTH-1;
    constant KND_SRT : integer  := LST_END+1;
    constant KND_END : integer  := KND_SRT + 1;
    constant CNT_SRT : integer  := KND_END + 1;
    constant CNT_END : integer  := CNT_SRT + C_CWIDTH-1;

    -- Declare a storage area for the mutex data
    type mstore is array(0 to MUTEXES-1) of std_logic_vector(0 to 3*C_TWIDTH+C_CWIDTH+1);

    -- Declare signals for the mutex storage area
    signal store    : mstore;
    signal mena     : std_logic;
    signal mwea     : std_logic;
    signal maddr    : std_logic_vector(0 to C_MWIDTH-1);
    signal minput   : std_logic_vector(0 to 3*C_TWIDTH+C_CWIDTH+1);
    signal moutput  : std_logic_vector(0 to 3*C_TWIDTH+C_CWIDTH+1);

    -- Type for the reset state machine
    type rststate is
    (
        IDLE,
        RESET
    );

    -- Declare signals for the reset
    signal rena     : std_logic;
    signal rwea     : std_logic;
    signal rst_cs   : rststate;
    signal raddr    : std_logic_vector(0 to C_MWIDTH-1);
    signal raddrn   : std_logic_vector(0 to C_MWIDTH-1);
    signal rowner   : std_logic_vector(0 to C_TWIDTH-1);
    signal rnext    : std_logic_vector(0 to C_TWIDTH-1);
    signal rlast    : std_logic_vector(0 to C_TWIDTH-1);
    signal rkind    : std_logic_vector(0 to 1);
    signal rcount   : std_logic_vector(0 to C_CWIDTH-1);
begin
    moowner <= moutput(OWN_SRT to OWN_END);
    monext  <= moutput(NXT_SRT to NXT_END);
    molast  <= moutput(LST_SRT to LST_END);
    mokind  <= moutput(KND_SRT to KND_END);
    mocount <= moutput(CNT_SRT to CNT_END);

    mutex_mux : process(clk,rst,sysrst,rena,rwea,raddr,rowner,rnext,rlast,rkind,rcount,
                        miena,miwea,miaddr,miowner,milast,mikind,micount) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                mena    <= rena;
                mwea    <= rwea;
                maddr   <= raddr;
                minput  <= rowner & rnext & rlast & rkind & rcount;
            else
                mena    <= miena;
                mwea    <= miwea;
                maddr   <= miaddr;
                minput  <= miowner & minext & milast & mikind & micount;
            end if;
        end if;
    end process mutex_mux;

    mutex_reset_controller : process(clk,rst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                rst_cs  <= RESET;
                raddr   <= raddrn;
            else
                rst_cs  <= IDLE;
            end if;
        end if;
    end process mutex_reset_controller;

    mutex_reset_logic : process(rst_cs,raddr) is
    begin
        rena    <= '1';
        rwea    <= '1';
        rstdone <= '1';
        rowner  <= (others => '0');
        rnext   <= (others => '0');
        rlast   <= (others => '0');
        rkind   <= (others => '0');
        rcount  <= (others => '0');

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
    end process mutex_reset_logic;

    mutex_store_controller : process (clk) is
    begin
        if( rising_edge(clk) ) then
            if( mena = '1' ) then
                if( mwea = '1' ) then
                    store( conv_integer(maddr) ) <=  minput;
                end if;

                moutput <= store( conv_integer(maddr) );
            end if;
        end if;
    end process mutex_store_controller;
end behavioral;
