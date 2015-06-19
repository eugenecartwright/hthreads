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

entity lock_fsm is
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
end lock_fsm;

architecture behavioral of lock_fsm is
    -- A type for the states in the lock fsm
    type lock_state is
    (
        IDLE,
        READ,
        DONE,
        UPDATE
    );

    -- Declare signals for the lock fsm
    signal lock_cs          : lock_state;
    signal lock_ns          : lock_state;
begin
    -- This core resets in one clock cycle so it is always "done"
    rstdone <= '1';

    lock_update : process(clk,rst,sysrst,lock_ns) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                lock_cs <= IDLE;
            else
                lock_cs <= lock_ns;
            end if;
        end if;
    end process lock_update;

    lock_controller : process(lock_cs,start,mutex,thread,micount,mikind,miowner,milast,minext) is
    begin
        lock_ns <= lock_cs;
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

        case lock_cs is
            when IDLE =>
                if( start = '1' ) then
                    moaddr  <= mutex;
                    moena   <= '1';
                    mowea   <= '0';
                    lock_ns <= READ;
                end if;

            when READ =>
                lock_ns <= DONE;

            when DONE =>
                if( micount = zero(C_CWIDTH) ) then
                    moaddr  <= mutex;
                    moena   <= '1';
                    mowea   <= '1';
                    moowner <= thread;
                    monext  <= thread;
                    molast  <= thread;
                    mocount <= one( C_CWIDTH );
                    mokind  <= mikind;
                    finish  <= '1';
                    lock_ns <= IDLE;
                else
                    if( mikind = SYNCH_ERROR and miowner = thread ) then
                        data(0) <= '1';
                        finish  <= '1';
                        lock_ns <= IDLE;
                    elsif( mikind = SYNCH_RECURS and miowner = thread ) then
                        moaddr  <= mutex;
                        moena   <= '1';
                        mowea   <= '1';
                        moowner <= miowner;
                        monext  <= minext;
                        molast  <= milast;
                        mocount <= micount + 1;
                        mokind  <= mikind;
                        finish      <= '1';
                        lock_ns     <= IDLE;
                    elsif( minext = miowner ) then
                        toaddr  <= thread;
                        toena   <= '1';
                        towea   <= '1';
                        tonext  <= thread;
                        moaddr  <= mutex;
                        moena   <= '1';
                        mowea   <= '1';
                        moowner <= miowner;
                        monext  <= thread;
                        molast  <= thread;
                        mocount <= micount;
                        mokind  <= mikind;
                        finish  <= '1';
                        data(1) <= '1';
                        lock_ns <= IDLE;
                    else
                        toaddr  <= milast;
                        toena   <= '1';
                        towea   <= '1';
                        tonext  <= thread;
                        moaddr  <= mutex;
                        moena   <= '1';
                        mowea   <= '1';
                        moowner <= miowner;
                        monext  <= minext;
                        molast  <= thread;
                        mocount <= micount;
                        mokind  <= mikind;
                        finish  <= '0';
                        lock_ns <= UPDATE;
                    end if;
                end if;

            when UPDATE =>
                toaddr  <= thread;
                toena   <= '1';
                towea   <= '1';
                tonext  <= thread;
                finish  <= '1';
                data(1) <= '1';
                lock_ns <= IDLE;
        end case;
    end process lock_controller;
end behavioral;
