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
use ieee.std_logic_unsigned.all; 

ENTITY bram_imp_dual IS
	port (
	clk: IN std_logic;
	addra: IN std_logic_VECTOR(0 to 12);
	dia: IN std_logic_VECTOR(0 to 31);
	doa: OUT std_logic_VECTOR(0 to 31);
	ena : IN std_logic;
	wea: IN std_logic;
	addrb: IN std_logic_VECTOR(0 to 12);
	dib: IN std_logic_VECTOR(0 to 31);
	dob: OUT std_logic_VECTOR(0 to 31);
	enb : IN std_logic;
	web: IN std_logic);
END bram_imp_dual;


ARCHITECTURE beh of bram_imp_dual is
	--BRAM DECLARATION SIGNALS
	type ram_type is array (0 to 8191) of std_logic_vector (0 to 31); 
	shared variable RAM : ram_type;

BEGIN
	porta : process
	begin 
		wait until rising_edge(clk);

		if (ena = '1') then 
			if (wea = '1') then 
				RAM(conv_integer(addra)) := dia;
			end if;
			doa <= RAM(conv_integer(addra));
		end if; 
	end process; 

	portb : process
	begin 
		wait until rising_edge(clk);

		if (enb = '1') then 
			if (web = '1') then 
				RAM(conv_integer(addrb)) := dib;
			end if;
			dob <= RAM(conv_integer(addrb));
		end if; 
	end process; 
END beh;
