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

entity result_fsm is
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

        sysrst          :  in std_logic;
        rstdone         : out std_logic;

        rnw             :  in std_logic;
        datain          :  in std_logic_vector(0 to C_DWIDTH-1);
        data            : out std_logic_vector(0 to C_DWIDTH-1)
    );
end result_fsm;

architecture behavioral of result_fsm is
    -- Declare signals for the results register
    signal results : std_logic_vector(0 to C_DWIDTH-1) := (others => '0');
begin
    -- This core resets in one clock cycle so it is always "done"
    rstdone <= '1';

    result_controller : process (clk,rst,sysrst,start,results,datain,rnw) is
    begin
        if( rising_edge(clk) ) then
            data    <= (others => '0');
            finish  <= '0';
            if( rst = '1' or sysrst = '1' ) then
                results <= (others => '0');
            else
                results <= results;

                if( start = '1' ) then
                    if( rnw = '1' ) then
                        results <= datain;
                    else
                        data    <= results;
                    end if;

                    finish   <= '1';
                end if;
            end if;
        end if;
    end process result_controller;
end behavioral;
