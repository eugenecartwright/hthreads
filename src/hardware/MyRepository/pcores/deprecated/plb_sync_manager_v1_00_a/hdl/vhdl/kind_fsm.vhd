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

entity kind_fsm is
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

        start           :  in std_logic;
        finish          : out std_logic;

        rnw             :  in std_logic;
        datain          :  in std_logic_vector(0 to C_DWIDTH-1);
        data            : out std_logic_vector(0 to C_DWIDTH-1);

        mutex           :  in std_logic_vector(0 to C_MWIDTH-1);
        thread          :  in std_logic_vector(0 to C_TWIDTH-1);

        miowner         :  in std_logic_vector(0 to C_TWIDTH-1);
        minext          :  in std_logic_vector(0 to C_TWIDTH-1);
        milast          :  in std_logic_vector(0 to C_TWIDTH-1);
        micount         :  in std_logic_vector(0 to C_CWIDTH-1);
        mikind          :  in std_logic_vector(0 to 1);
        tinext          :  in std_logic_vector(0 to C_TWIDTH-1);

        moaddr          : out std_logic_vector(0 to C_MWIDTH-1);
        moena           : out std_logic;
        mowea           : out std_logic;
        moowner         : out std_logic_vector(0 to C_TWIDTH-1);
        monext          : out std_logic_vector(0 to C_TWIDTH-1);
        molast          : out std_logic_vector(0 to C_TWIDTH-1);
        mocount         : out std_logic_vector(0 to C_CWIDTH-1);
        mokind          : out std_logic_vector(0 to 1);

        sysrst          :  in std_logic;
        rstdone         : out std_logic;

        toaddr          : out std_logic_vector(0 to C_TWIDTH-1);
        toena           : out std_logic;
        towea           : out std_logic;
        tonext          : out std_logic_vector(0 to C_TWIDTH-1)
    );
end kind_fsm;

architecture behavioral of kind_fsm is
    -- A type for the states in the kind fsm
    type kind_state is
    (
        IDLE,
        READ,
        DONE
    );

    -- Declare signals for the kind register fsm
    signal kind_cs          : kind_state;
    signal kind_ns          : kind_state;

    -- Alias the kind input and output bits
    alias kidata : std_logic_vector(0 to 1) is datain(C_DWIDTH-2 to C_DWIDTH-1);
    alias kodata : std_logic_vector(0 to 1) is data(C_DWIDTH-2 to C_DWIDTH-1);
begin
    -- This core resets in one clock cycle so it is always "done"
    rstdone <= '1';

    kind_update : process (clk,rst,sysrst,kind_ns) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                kind_cs <= IDLE;
            else
                kind_cs <= kind_ns;
            end if;
        end if;
    end process kind_update;

    kind_controller : process (kind_cs,start,mutex,miowner,micount,mikind,milast,minext,rnw,datain) is
    begin
        kind_ns <= kind_cs;
        finish  <= '0';
        data    <= (others => '0');
        moaddr  <= (others => '0');
        moena   <= '0';
        mowea   <= '0';
        moowner <= (others => '0');
        monext  <= (others => '0');
        molast  <= (others => '0');
        mokind  <= (others => '0');
        mocount <= (others => '0');
        toaddr  <= (others => '0');
        toena   <= '0';
        towea   <= '0';
        tonext  <= (others => '0');

        case kind_cs is
            when IDLE =>
                if( start = '1' ) then
                    moaddr  <= mutex;
                    mowea   <= '0';
                    moena   <= '1';
                    kind_ns <= READ;
                end if;

            when READ =>
                kind_ns <= DONE;

            when DONE =>
                if( rnw = '0' ) then
                    moaddr  <= mutex;
                    moena   <= '1';
                    mowea   <= '1';
                    moowner <= miowner;
                    mokind  <= kidata;
                    mocount <= micount;
                    monext  <= minext;
                    molast  <= milast;
                    finish  <= '1';
                    kind_ns <= IDLE;
                else
                    finish  <= '1';
                    kodata  <= mikind;
                    kind_ns <= IDLE;
                end if;
        end case;
    end process kind_controller;
end behavioral;
