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
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package common is
    -- Synch Manager Operations
    constant SYNCH_LOCK     : std_logic_vector(0 to 2)  := "000";
    constant SYNCH_UNLOCK   : std_logic_vector(0 to 2)  := "001";
    constant SYNCH_TRY      : std_logic_vector(0 to 2)  := "010";
    constant SYNCH_OWNER    : std_logic_vector(0 to 2)  := "011";
    constant SYNCH_KIND     : std_logic_vector(0 to 2)  := "100";
    constant SYNCH_COUNT    : std_logic_vector(0 to 2)  := "101";
    constant SYNCH_RESULT   : std_logic_vector(0 to 2)  := "110";

    -- Synch Manager Lock Types
    constant SYNCH_FAST     : std_logic_vector(0 to 1)  := "00";
    constant SYNCH_RECURS   : std_logic_vector(0 to 1)  := "01";
    constant SYNCH_ERROR    : std_logic_vector(0 to 1)  := "10";

    -- Constants for the status codes which are returned
    constant SYNCH_LOCKSTA_CONTINUE     : std_logic_vector(0 to 0)  := "0";
    constant SYNCH_LOCKSTA_BLOCK        : std_logic_vector(0 to 0)  := "1";
    constant SYNCH_UNLOCKSTA_SUCCESS    : std_logic_vector(0 to 0)  := "0";
    constant SYNCH_UNLOCKSTA_ERROR      : std_logic_vector(0 to 0)  := "1";
    constant SYNCH_TRYLOCKSTA_SUCCESS   : std_logic_vector(0 to 0)  := "0";
    constant SYNCH_TRYLOCKSTA_ERROR     : std_logic_vector(0 to 0)  := "1";

    -- Constants used by this package
    constant CMBITS          : natural   := 3;
    constant KNBITS          : natural   := 2;

    -- Calculate the number one for any given bit width
    function one( n : in natural ) return std_logic_vector;

    -- Calculate the number zero for any given bit width
    function zero( n : in natural ) return std_logic_vector;

    -- Calculate the log base 2 of some natural number. This function can be
    -- used to determine the minimum number of bits needed to represent the
    -- given natural number.
    function log2( n : in natural ) return positive;

    -- Calculate the 2 to the power n. This function can be used to determine
    -- the maximum natural number which is representable by a given number
    -- of bits.
    function pow2( n : in natural ) return positive;

    -- Determine if a number is exactly a power of two. This can be used
    -- to check that generics are input as power of two (if that is what
    -- is wanted).
    function is_pow2( n : in natural ) return boolean;

    -- Calculate the address used to add a thread to the thread scheduler.
    function add_thread( base : in std_logic_vector;
                         tid  : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address used to store the result value from an add thread.
    function add_result( base : in std_logic_vector ) return std_logic_vector;

    -- Calculate a synchronization manager command
    function synch_cmd( BASE  : in std_logic_vector;
                        DWID  : in natural;
                        MBITS : in natural;
                        TBITS : in natural;
                        CBITS : in natural;
                        tid   : in std_logic_vector;
                        mid   : in std_logic_vector;
                        cmd   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_lockcmd( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            tid   : in std_logic_vector;
                            mid   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_unlockcmd( BASE  : in std_logic_vector;
                              DWID  : in natural;
                              MBITS : in natural;
                              TBITS : in natural;
                              CBITS : in natural;
                              tid   : in std_logic_vector;
                              mid   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_trylockcmd( BASE  : in std_logic_vector;
                               DWID  : in natural;
                               MBITS : in natural;
                               TBITS : in natural;
                               CBITS : in natural;
                               tid   : in std_logic_vector;
                               mid   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_kindcmd( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            tid   : in std_logic_vector;
                            mid   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_countcmd( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             tid   : in std_logic_vector;
                             mid   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_ownercmd( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             tid   : in std_logic_vector;
                             mid   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_locksta( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            sta   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_unlocksta( BASE  : in std_logic_vector;
                              DWID  : in natural;
                              MBITS : in natural;
                              TBITS : in natural;
                              CBITS : in natural;
                              sta   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_trylocksta( BASE  : in std_logic_vector;
                               DWID  : in natural;
                               MBITS : in natural;
                               TBITS : in natural;
                               CBITS : in natural;
                               sta   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_kindsta( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            sta   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_countsta( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             sta   : in std_logic_vector ) return std_logic_vector;

    -- Calculate the address for a lock command
    function synch_ownersta( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             sta   : in std_logic_vector ) return std_logic_vector;
end package common;

package body common is
    -- Calculate a synchronization manager command
    function synch_cmd( BASE  : in std_logic_vector;
                        DWID  : in natural;
                        MBITS : in natural;
                        TBITS : in natural;
                        CBITS : in natural;
                        tid : in std_logic_vector;
                        mid : in std_logic_vector;
                        cmd : in std_logic_vector ) return std_logic_vector is
        variable addr : std_logic_vector(0 to DWID-1);
    begin
        addr := BASE;
        addr(DWID-MBITS-2 to DWID-3)                            := mid;
        addr(DWID-MBITS-TBITS-2 to DWID-MBITS-3)                := tid;
        addr(DWID-MBITS-TBITS-CMBITS-2 to DWID-MBITS-TBITS-3)    := cmd;

        return addr;
    end function synch_cmd;

    -- Calculate the address for a lock command
    function synch_lockcmd( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            tid   : in std_logic_vector;
                            mid   : in std_logic_vector ) return std_logic_vector is 
    begin
        return synch_cmd(BASE,DWID,MBITS,TBITS,CBITS,tid,mid,SYNCH_LOCK);
    end function synch_lockcmd;

    -- Extract status information for the lock operation
    function synch_locksta( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            sta   : in std_logic_vector ) return std_logic_vector is 
        variable tmp : std_logic_vector(0 to 0);
    begin
        tmp(0) := sta(0) or sta(1);
        return tmp;
    end function synch_locksta;

    -- Calculate the address for a lock command
    function synch_unlockcmd( BASE  : in std_logic_vector;
                              DWID  : in natural;
                              MBITS : in natural;
                              TBITS : in natural;
                              CBITS : in natural;
                              tid   : in std_logic_vector;
                              mid   : in std_logic_vector ) return std_logic_vector is 
    begin
        return synch_cmd(BASE,DWID,MBITS,TBITS,CBITS,tid,mid,SYNCH_UNLOCK);
    end function synch_unlockcmd;

    -- Extract status information for the unlock operation
    function synch_unlocksta( BASE  : in std_logic_vector;
                              DWID  : in natural;
                              MBITS : in natural;
                              TBITS : in natural;
                              CBITS : in natural;
                              sta   : in std_logic_vector ) return std_logic_vector is 
    begin
        return sta(0 to 0);
    end function synch_unlocksta;

    -- Calculate the address for a lock command
    function synch_trylockcmd( BASE  : in std_logic_vector;
                               DWID  : in natural;
                               MBITS : in natural;
                               TBITS : in natural;
                               CBITS : in natural;
                               tid   : in std_logic_vector;
                               mid   : in std_logic_vector ) return std_logic_vector is 
    begin
        return synch_cmd(BASE,DWID,MBITS,TBITS,CBITS,tid,mid,SYNCH_TRY);
    end function synch_trylockcmd;

    -- Extract status information for the unlock operation
    function synch_trylocksta( BASE  : in std_logic_vector;
                               DWID  : in natural;
                               MBITS : in natural;
                               TBITS : in natural;
                               CBITS : in natural;
                               sta   : in std_logic_vector ) return std_logic_vector is 
    begin
        return sta(1 to 1);
    end function synch_trylocksta;

    -- Calculate the address for a lock command
    function synch_kindcmd( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            tid   : in std_logic_vector;
                            mid   : in std_logic_vector ) return std_logic_vector is 
    begin
        return synch_cmd(BASE,DWID,MBITS,TBITS,CBITS,tid,mid,SYNCH_KIND);
    end function synch_kindcmd;

    -- Extract status information for the unlock operation
    function synch_kindsta( BASE  : in std_logic_vector;
                            DWID  : in natural;
                            MBITS : in natural;
                            TBITS : in natural;
                            CBITS : in natural;
                            sta   : in std_logic_vector ) return std_logic_vector is 
    begin
        return sta(DWID-2 to DWID-1);
    end function synch_kindsta;

    -- Calculate the address for a lock command
    function synch_ownercmd( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             tid   : in std_logic_vector;
                             mid   : in std_logic_vector ) return std_logic_vector is 
    begin
        return synch_cmd(BASE,DWID,MBITS,TBITS,CBITS,tid,mid,SYNCH_OWNER);
    end function synch_ownercmd;

    -- Extract status information for the unlock operation
    function synch_ownersta( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             sta   : in std_logic_vector ) return std_logic_vector is 
    begin
        return sta(DWID-TBITS to DWID-1);
    end function synch_ownersta;

    -- Calculate the address for a lock command
    function synch_countcmd( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             tid   : in std_logic_vector;
                             mid   : in std_logic_vector ) return std_logic_vector is 
    begin
        return synch_cmd(BASE,DWID,MBITS,TBITS,CBITS,tid,mid,SYNCH_COUNT);
    end function synch_countcmd;

    -- Extract status information for the unlock operation
    function synch_countsta( BASE  : in std_logic_vector;
                             DWID  : in natural;
                             MBITS : in natural;
                             TBITS : in natural;
                             CBITS : in natural;
                             sta   : in std_logic_vector ) return std_logic_vector is 
    begin
        return sta(DWID-CBITS to DWID-1);
    end function synch_countsta;

    -- Calculate the number one for any given bit width
    function one( n : in natural ) return std_logic_vector is
        variable o : std_logic_vector(0 to n-1);
    begin
        o(0 to n-2) := (others => '0');
        o(n-1)      := '1';
        return o;
    end function one;

    -- Calculate the number zero for any given bit width
    function zero( n : in natural ) return std_logic_vector is
        variable z : std_logic_vector(0 to n-1);
    begin
        z(0 to n-1) := (others => '0');
        return z;
    end function zero;

    -- Calculate the log base 2 of some natural number. This function can be
    -- used to determine the minimum number of bits needed to represent the
    -- given natural number.
    function log2( n : in natural ) return positive is
    begin
        if n <= 2 then
            return 1;
        else
            return 1 + log2(n/2);
        end if;
    end function log2;

    -- Calculate the 2 to the power n. This function can be used to determine
    -- the maximum natural number which is representable by a given number
    -- of bits.
    function pow2( n : in natural ) return positive is
    begin
        if n = 0 then
            return 1;
        else
            return 2 * pow2( n - 1 );
        end if;
    end function pow2;

    -- Determine if a number is exactly a power of two. This can be used
    -- to check that generics are input as power of two (if that is what
    -- is wanted).
    function is_pow2( n : in natural ) return boolean is
        variable l : positive;
        variable p : positive;
    begin
        if( n = 1 ) then
            return true;
        end if;

        if( (n mod 2) = 1 or n = 0) then
            return false;
        end if;

        return is_pow2( n / 2 );
    end function is_pow2;

    -- Calculate the address used to add a thread to the thread scheduler.
    function add_thread( base : in std_logic_vector; tid : in std_logic_vector ) return std_logic_vector is
    begin
        return base(0 to base'high - tid'length - 7) &
               "00100" &
               tid &
               base(base'high-1 to base'high);
    end function add_thread;

    -- Calculate the address used to store the result value from an add thread.
    function add_result( base : in std_logic_vector ) return std_logic_vector is
    begin
        return base(0 to base'high-2) & "11";
    end function add_result;
end package body common;
