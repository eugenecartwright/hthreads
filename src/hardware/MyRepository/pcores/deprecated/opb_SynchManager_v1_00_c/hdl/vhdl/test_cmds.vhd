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

entity test_cmds is
    generic
    (
        C_AWIDTH        : integer   := 32;
        C_DWIDTH        : integer   := 32;
        C_TWIDTH        : integer   := 8;
        C_MWIDTH        : integer   := 6;
        C_CWIDTH        : integer   := 8;
        BASE            : std_logic_vector  := x"75000000"
    );
    port
    (
        clk             :  in std_logic;
        rst             :  in std_logic;

        start           :  in std_logic;
        finish          : out std_logic;

        addr            : out std_logic_vector(0 to C_DWIDTH-1);
        data            : out std_logic_vector(0 to C_DWIDTH-1);
        datain          :  in std_logic_vector(0 to C_DWIDTH-1);

        kind            : out std_logic_vector(0 to 1);
        owner           : out std_logic_vector(0 to C_TWIDTH-1);
        count           : out std_logic_vector(0 to C_CWIDTH-1);

        mutex           :  in std_logic_vector(0 to C_MWIDTH-1);
        thread          :  in std_logic_vector(0 to C_TWIDTH-1);

        miowner         :  in std_logic_vector(0 to C_TWIDTH-1);
        milast          :  in std_logic_vector(0 to C_TWIDTH-1);
        micount         :  in std_logic_vector(0 to C_CWIDTH-1);
        mikind          :  in std_logic_vector(0 to 1);
        tinext          :  in std_logic_vector(0 to C_TWIDTH-1);

        moaddr          : out std_logic_vector(0 to C_MWIDTH-1);
        moena           : out std_logic;
        mowea           : out std_logic;
        moowner         : out std_logic_vector(0 to C_TWIDTH-1);
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
end test_cmds;

architecture behavioral of test_cmds is
    -- A type for the states in the lock fsm
    type lock_state is
    (
        IDLE,
        SETID,
        SETMID,
        DOLOCK,
        DOUNLOCK,
        DOTRYLOCK,
        DOSETKIND,
        DOGETKIND,
        DOGETCOUNT,
        DOGETOWNER,
        DONE
    );

    -- Declare signals for the lock fsm
    signal lock_cs          : lock_state;
    signal lock_ns          : lock_state;

    -- Signals for stuff
    signal tid  : std_logic_vector(0 to C_TWIDTH-1);
    signal mid  : std_logic_vector(0 to C_MWIDTH-1);
    signal tidn : std_logic_vector(0 to C_TWIDTH-1);
    signal midn : std_logic_vector(0 to C_MWIDTH-1);
begin
    -- This core resets in one clock cycle so it is always "done"
    rstdone <= '1';

    lock_update : process(clk,rst,sysrst,lock_ns) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' or sysrst = '1' ) then
                lock_cs <= IDLE;
                tid     <= (others => '0');
                mid     <= (others => '0');
            else
                lock_cs <= lock_ns;
                tid     <= tidn;
                mid     <= midn;
            end if;
        end if;
    end process lock_update;

    lock_controller : process(lock_cs,start,mutex,thread,micount,mikind,miowner,milast) is
    begin
        lock_ns <= lock_cs;
        finish  <= '0';
        data    <= (others => '0');
        moaddr  <= (others => '0');
        moena   <= '0';
        mowea   <= '0';
        moowner <= (others => '0');
        molast  <= (others => '0');
        mokind  <= (others => '0');
        mocount <= (others => '0');
        toaddr  <= (others => '0');
        toena   <= '0';
        towea   <= '0';
        tonext  <= (others => '0'); 
        tidn    <= tid;
        midn    <= mid;

        case lock_cs is
            when IDLE =>
                if( start = '1' ) then
                    if( mikind = "00" ) then
                        lock_ns <= DOLOCK;
                    elsif( mikind = "01" ) then
                        lock_ns <= SETID;
                    else
                        lock_ns <= SETMID;
                    end if;
                end if;

            when SETID =>
                tidn    <= miowner;
                lock_ns <= IDLE;

            when SETMID =>
                midn    <= mutex;
                lock_ns <= IDLE;

            -- LOCK Command:
            -- To perform a lock operation with the synchronization manager you
            -- perform a read to the address generated by the function
            -- synch_lockcmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use when locking the mutex
            -- and the 7th parameter is the mutex identifier to lock.
            --
            -- Thus a to generate the address to use when performing a lock operation:
            --      synch_lockcmd(  BASE,        -- The base addr of the synch. man.
            --                      DATA WIDTH,  -- Number of bits for the data bus
            --                      MUTEX BITS,  -- Number of bits for the mutex id
            --                      THREAD BITS, -- Number of bits for the thread id
            --                      COUNT BITS,  -- Number of bits for the lock count
            --                      THREAD ID,   -- Thread identifier to use
            --                      MUTEX ID );  -- Mutex identifier to use
            --
            -- The results of the read operation can then be sent to the function
            -- synch_locksta which will return information on whether the mutex
            -- was successfully locked or not. This function has 6 parameters. The
            -- first five parameters are the same generic parameters used in the
            -- lock command. The 6th parameter is the value returned from the read
            -- operation.
            --
            -- Thus to check the status of the lock operation:
            --      synch_locksta(  BASE,        -- The base addr of the synch. man.
            --                      DATA WIDTH,  -- Number of bits for the data bus
            --                      MUTEX BITS,  -- Number of bits for the mutex id
            --                      THREAD BITS, -- Number of bits for the thread id
            --                      COUNT BITS,  -- Number of bits for the lock count
            --                      READ VALUE); -- Result returned by synch. man.
            --
            -- If the returned status is SYNCH_LOCKSTA_CONTINUE then the lock was
            -- successfully locked and the thread can continue to run. If the
            -- returned status is SYNCH_LOCKSTA_BLOCK then the thread did not get
            -- the lock and should not continue to run.
            when DOLOCK =>
                addr <= synch_lockcmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                if( synch_locksta(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,datain) =
                    SYNCH_LOCKSTA_CONTINUE ) then
                        null;   -- Continue the operation of the core
                else
                        null;   -- Halt the operation of the core
                end if;
                lock_ns <= DOUNLOCK;

            -- UNLOCK Command:
            -- To perform an unlock operation with the synchronization manager you
            -- perform a read to the address generated by the function
            -- synch_unlockcmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use the 7th parameter is the
            -- mutex identifier.
            --
            -- Thus a to generate the address to use when performing an unlock operation:
            --      synch_unlockcmd(  BASE,        -- The base addr of the synch. man.
            --                        DATA WIDTH,  -- Number of bits for the data bus
            --                        MUTEX BITS,  -- Number of bits for the mutex id
            --                        THREAD BITS, -- Number of bits for the thread id
            --                        COUNT BITS,  -- Number of bits for the lock count
            --                        THREAD ID,   -- Thread identifier to use
            --                        MUTEX ID );  -- Mutex identifier to use
            --
            -- The results of the read operation can then be sent to the function
            -- synch_unlocksta which will return information on whether the mutex
            -- was successfully locked or not. This function has 6 parameters. The
            -- first five parameters are the same generic parameters used in the
            -- lock command. The 6th parameter is the value returned from the read
            -- operation.
            --
            -- Thus to check the status of the unlock operation:
            --      synch_unlocksta(  BASE,        -- The base addr of the synch. man.
            --                        DATA WIDTH,  -- Number of bits for the data bus
            --                        MUTEX BITS,  -- Number of bits for the mutex id
            --                        THREAD BITS, -- Number of bits for the thread id
            --                        COUNT BITS,  -- Number of bits for the lock count
            --                        READ VALUE); -- Result returned by synch. man.
            --
            -- If the returned status is SYNCH_UNLOCKSTA_SUCCESS then the unlock was
            -- successful and the thread can continue to run. If the returned
            -- status is SYNCH_UNLOCKSTA_ERROR then the thread did not unlock
            -- the lock because some error occurred.
            when DOUNLOCK =>
                addr <= synch_unlockcmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                if (synch_unlocksta(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,datain) =
                    SYNCH_UNLOCKSTA_SUCCESS ) then
                        null;   -- Unlock operation was successful
                else
                        null;   -- Unlock operation failed because of some reason
                end if;
                lock_ns <= DOTRYLOCK;

            -- TRYLOCK Command:
            -- To perform a try lock operation with the synchronization manager you
            -- perform a read to the address generated by the function
            -- synch_trylockcmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use and the 7th parameter is
            -- the mutex identifier.
            --
            -- Thus a to generate the address to use when performing a try lock:
            --      synch_trylockcmd(  BASE,        -- The base addr of the synch. man.
            --                         DATA WIDTH,  -- Number of bits for the data bus
            --                         MUTEX BITS,  -- Number of bits for the mutex id
            --                         THREAD BITS, -- Number of bits for the thread id
            --                         COUNT BITS,  -- Number of bits for the lock count
            --                         THREAD ID,   -- Thread identifier to use
            --                         MUTEX ID );  -- Mutex identifier to use
            --
            -- The results of the read operation can then be sent to the function
            -- synch_trylocksta which will return information on whether the mutex
            -- was successfully locked or not. This function has 6 parameters. The
            -- first five parameters are the same generic parameters used in the
            -- lock command. The 6th parameter is the value returned from the read
            -- operation.
            --
            -- Thus to check the status of the trylock operation:
            --      synch_trylocksta(  BASE,        -- The base addr of the synch. man.
            --                         DATA WIDTH,  -- Number of bits for the data bus
            --                         MUTEX BITS,  -- Number of bits for the mutex id
            --                         THREAD BITS, -- Number of bits for the thread id
            --                         COUNT BITS,  -- Number of bits for the lock count
            --                         READ VALUE); -- Result returned by synch. man.
            --
            -- If the returned status is SYNCH_TRYLOCKSTA_SUCCESS then the lock was
            -- successful and the thread can continue to run. If the returned
            -- status is SYNCH_TRYLOCKSTA_ERROR then the thread did not get the lock
            -- because the lock was already owned by another thread.
            when DOTRYLOCK =>
                addr<=synch_trylockcmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                if( synch_trylocksta(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,datain) = 
                    SYNCH_TRYLOCKSTA_SUCCESS ) then
                        null;   -- Lock was acquired
                else
                        null;   -- Lock was already owned by another thread
                end if;
                lock_ns <= DOSETKIND;

            -- SET KIND Command:
            -- To perform a kind set operation with the synchronization manager you
            -- perform a write to the address generated by the function
            -- synch_kindcmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use and the 7th parameter is
            -- the mutex identifier.
            --
            -- Thus a to set the kind of an mutex:
            --      synch_kindcmd(  BASE,        -- The base addr of the synch. man.
            --                      DATA WIDTH,  -- Number of bits for the data bus
            --                      MUTEX BITS,  -- Number of bits for the mutex id
            --                      THREAD BITS, -- Number of bits for the thread id
            --                      COUNT BITS,  -- Number of bits for the lock count
            --                      THREAD ID,   -- Thread identifier to use
            --                      MUTEX ID );  -- Mutex identifier to use
            --
            -- Since this is a write operation no status information is returned.
            when DOSETKIND =>
                -- As write operation
                addr <= synch_kindcmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                lock_ns <= DOGETKIND;

            -- GET KIND Command:
            -- To perform a get kind operation with the synchronization manager you
            -- perform a read to the address generated by the function
            -- synch_kindcmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use and the 7th parameter is
            -- the mutex identifier.
            --
            -- Thus a to generate the address to use when performing the operation:
            --      synch_kindcmd(  BASE,        -- The base addr of the synch. man.
            --                      DATA WIDTH,  -- Number of bits for the data bus
            --                      MUTEX BITS,  -- Number of bits for the mutex id
            --                      THREAD BITS, -- Number of bits for the thread id
            --                      COUNT BITS,  -- Number of bits for the lock count
            --                      THREAD ID,   -- Thread identifier to use
            --                      MUTEX ID );  -- Mutex identifier to use
            --
            -- The results of the read operation can then be sent to the function
            -- synch_kindsta which will gets the kind. This function has 6 parameters.
            -- The first five parameters are the same generic parameters used in the
            -- lock command. The 6th parameter is the value returned from the read
            -- operation.
            --
            -- Thus to get the kind of a mutex:
            --      synch_kindsta(  BASE,        -- The base addr of the synch. man.
            --                      DATA WIDTH,  -- Number of bits for the data bus
            --                      MUTEX BITS,  -- Number of bits for the mutex id
            --                      THREAD BITS, -- Number of bits for the thread id
            --                      COUNT BITS,  -- Number of bits for the lock count
            --                      READ VALUE); -- Result returned by synch. man.
            --
            -- The value returned from this function is one of SYNCH_FAST, SYNCH_RECURS,
            -- or SYNCH_ERROR depending on the type of mutex that was returned.
            when DOGETKIND =>
                -- As read operations
                addr <= synch_kindcmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                kind <= synch_kindsta(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,datain);
                lock_ns <= DOGETCOUNT;

            -- GET COUNT Command:
            -- To perform a get count operation with the synchronization manager you
            -- perform a read to the address generated by the function
            -- synch_countcmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use and the 7th parameter is
            -- the mutex identifier.
            --
            -- Thus a to generate the address to use when performing the operation:
            --      synch_countcmd(  BASE,        -- The base addr of the synch. man.
            --                       DATA WIDTH,  -- Number of bits for the data bus
            --                       MUTEX BITS,  -- Number of bits for the mutex id
            --                       THREAD BITS, -- Number of bits for the thread id
            --                       COUNT BITS,  -- Number of bits for the lock count
            --                       THREAD ID,   -- Thread identifier to use
            --                       MUTEX ID );  -- Mutex identifier to use
            --
            -- The results of the read operation can then be sent to the function
            -- synch_countsta which will gets the count. This function has 6 parameters.
            -- The first five parameters are the same generic parameters used in the
            -- lock command. The 6th parameter is the value returned from the read
            -- operation.
            --
            -- Thus to check the recursive lock count of a mutex::
            --      synch_countsta(  BASE,        -- The base addr of the synch. man.
            --                       DATA WIDTH,  -- Number of bits for the data bus
            --                       MUTEX BITS,  -- Number of bits for the mutex id
            --                       THREAD BITS, -- Number of bits for the thread id
            --                       COUNT BITS,  -- Number of bits for the lock count
            --                       READ VALUE); -- Result returned by synch. man.
            --
            -- The value returned by this function is the recursive lock count.
            when DOGETCOUNT =>
                addr <= synch_countcmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                count <= synch_countsta(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,datain);
                lock_ns <= DOGETOWNER;

            -- GET OWNER Command:
            -- To perform a get owner operation with the synchronization manager you
            -- perform a read to the address generated by the function
            -- synch_ownercmd. This command has 7 parameters. The first 5 parameters
            -- are used to pass information on the bit widths of certain parameters
            -- (this is used to support generics in the VHDL which can be used to
            --  configure the number of threads/mutexes at synthesis time). The 6th
            -- paramaeter if the thread identifier to use and the 7th parameter is
            -- the mutex identifier.
            --
            -- Thus a to generate the address to use when performing the operation:
            --      synch_ownercmd(  BASE,        -- The base addr of the synch. man.
            --                       DATA WIDTH,  -- Number of bits for the data bus
            --                       MUTEX BITS,  -- Number of bits for the mutex id
            --                       THREAD BITS, -- Number of bits for the thread id
            --                       COUNT BITS,  -- Number of bits for the lock count
            --                       THREAD ID,   -- Thread identifier to use
            --                       MUTEX ID );  -- Mutex identifier to use
            --
            -- The results of the read operation can then be sent to the function
            -- synch_ownersta which will gets the owner. This function has 6 parameters.
            -- The first five parameters are the same generic parameters used in the
            -- lock command. The 6th parameter is the value returned from the read
            -- operation.
            --
            -- Thus to check the owner of a mutex::
            --      synch_ownersta(  BASE,        -- The base addr of the synch. man.
            --                       DATA WIDTH,  -- Number of bits for the data bus
            --                       MUTEX BITS,  -- Number of bits for the mutex id
            --                       THREAD BITS, -- Number of bits for the thread id
            --                       COUNT BITS,  -- Number of bits for the lock count
            --                       READ VALUE); -- Result returned by synch. man.
            --
            -- The value returned by this function is the owner of the mutex.
            when DOGETOWNER =>
                addr <= synch_ownercmd(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,tid,mid);
                owner <= synch_ownersta(BASE,C_DWIDTH,C_MWIDTH,C_TWIDTH,C_CWIDTH,datain);
                lock_ns <= DONE;

            when DONE =>
                lock_ns     <= IDLE;
        end case;
    end process lock_controller;
end behavioral;
