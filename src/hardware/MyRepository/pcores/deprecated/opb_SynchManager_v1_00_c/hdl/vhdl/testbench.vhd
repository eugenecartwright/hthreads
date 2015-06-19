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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.common.all;

entity testbench is
end testbench;

architecture behavior of testbench is 
    -- Synch Manager Configuration Constants
    constant SCHED_BADDR : std_logic_vector(0 to 31)    := x"60000000";
    constant SCHED_HADDR : std_logic_vector(0 to 31)    := x"6FFFFFFF";
    constant MUTEX_BADDR : std_logic_vector(0 to 31)    := x"70000000";
    constant MUTEX_HADDR : std_logic_vector(0 to 31)    := x"7FFFFFFF";
    constant SYNCH_THREADS  : integer                   := 256;
    constant SYNCH_MUTEXES  : integer                   := 64;

    -- Constants for the number of bits needed to represent certain data
    constant MUTEX_BITS     : integer   := log2(SYNCH_MUTEXES);
    constant THREAD_BITS    : integer   := log2(SYNCH_THREADS);
    constant KIND_BITS      : integer   := 2;
    constant COUNT_BITS     : integer   := 8;
    constant COMMAND_BITS   : integer   := 3;
    constant DATA_BITS      : integer   := 32;

	--Inputs
	signal OPB_Clk      : std_logic := '0';
	signal OPB_Rst      : std_logic := '0';
	signal OPB_RNW      : std_logic := '0';
	signal OPB_select   : std_logic := '0';
	signal OPB_seqAddr  : std_logic := '0';
	signal OPB_errAck   : std_logic := '0';
	signal OPB_MGrant   : std_logic := '0';
	signal OPB_retry    : std_logic := '0';
	signal OPB_timeout  : std_logic := '0';
	signal OPB_xferAck  : std_logic := '0';
	signal OPB_ABus     : std_logic_vector(0 to 31) := (others=>'0');
	signal OPB_BE       : std_logic_vector(0 to 3)  := (others=>'0');
	signal OPB_DBus     : std_logic_vector(0 to 31) := (others=>'0');

	--Outputs
	signal Sl_DBus      : std_logic_vector(0 to 31);
	signal Sl_errAck    : std_logic;
	signal Sl_retry     : std_logic;
	signal Sl_toutSup   : std_logic;
	signal Sl_xferAck   : std_logic;
	signal M_ABus       : std_logic_vector(0 to 31);
	signal M_BE         : std_logic_vector(0 to 3);
	signal M_busLock    : std_logic;
	signal M_request    : std_logic;
	signal M_RNW        : std_logic;
	signal M_select     : std_logic;
	signal M_seqAddr    : std_logic;

    -- Reset signals
    signal system_reset     : std_logic;
    signal system_resetdone : std_logic;
begin

	-- Instantiate the Unit Under Test (UUT)
    synch : entity work.opb_synchmanager
    generic map
    (
        C_NUM_THREADS   => SYNCH_THREADS,
        C_NUM_MUTEXES   => SYNCH_MUTEXES,
        C_SCHED_BADDR   => SCHED_BADDR,
        C_SCHED_HADDR   => SCHED_HADDR,
        C_BASEADDR      => MUTEX_BADDR,
        C_HIGHADDR      => MUTEX_HADDR
    )
    port map
    (
		OPB_Clk     => OPB_Clk,
		OPB_Rst     => OPB_Rst,
		Sl_DBus     => Sl_DBus,
		Sl_errAck   => Sl_errAck,
		Sl_retry    => Sl_retry,
		Sl_toutSup  => Sl_toutSup,
		Sl_xferAck  => Sl_xferAck,
		OPB_ABus    => OPB_ABus,
		OPB_BE      => OPB_BE,
		OPB_DBus    => OPB_DBus,
		OPB_RNW     => OPB_RNW,
		OPB_select  => OPB_select,
		OPB_seqAddr => OPB_seqAddr,
		M_ABus      => M_ABus,
		M_BE        => M_BE,
		M_busLock   => M_busLock,
		M_request   => M_request,
		M_RNW       => M_RNW,
		M_select    => M_select,
		M_seqAddr   => M_seqAddr,
		OPB_errAck  => OPB_errAck,
		OPB_MGrant  => OPB_MGrant,
		OPB_retry   => OPB_retry,
		OPB_timeout => OPB_timeout,
		OPB_xferAck => OPB_xferAck,
        system_reset     => system_reset,
        system_resetdone => system_resetdone
	);
    
	tb : process
        procedure bus_trans( rnw : in std_logic;
                             abus : in std_logic_vector(0 to 31); 
                             dbus : in std_logic_vector(0 to 31) ) is
        begin
            wait until OPB_Clk = '1';
            OPB_ABus        <= abus;
            OPB_DBus        <= dbus;
            OPB_RNW         <= rnw;
            OPB_select      <= '1';
            OPB_BE          <= (others => '1');
    
            wait until Sl_xferAck = '1' and OPB_Clk = '1';
            OPB_ABus        <= (others => '0');
            OPB_DBus        <= (others => '0');
            OPB_RNW         <= '0';
            OPB_select      <= '0';
            OPB_BE          <= (others => '0');
    
            wait until OPB_Clk = '1';
        end procedure bus_trans;
    
        procedure bus_reset is
        begin
            wait until OPB_Clk = '1';
    
            OPB_Rst         <= '1';
            OPB_select      <= '0';
            OPB_seqAddr     <= '0';
            OPB_RNW         <= '0';
            OPB_BE          <= (others => '0');
            OPB_ABus        <= (others => '0');
            OPB_DBus        <= (others => '0');
    
            wait until OPB_Clk = '1';
            OPB_Rst         <= '0';
        end procedure bus_reset;

        procedure sys_reset is
        begin
            -- Issue a bus reset first
            bus_reset;

            -- Assert the system reset signal
            system_reset <= '1';

            -- Wait until the core is finished resetting
            wait until system_resetdone = '1';

            -- Deassert the system reset signal
            system_reset <= '0';
        end procedure sys_reset;
    
        function synch_cmd( tid : in std_logic_vector(0 to THREAD_BITS-1);
                            mid : in std_logic_vector(0 to MUTEX_BITS-1); 
                            cmd : in std_logic_vector(0 to COMMAND_BITS-1) )
                          return std_logic_vector is
            variable addr : std_logic_vector(0 to 31);
        begin
            addr := MUTEX_BADDR;
            addr(30-MUTEX_BITS to 29)   := mid;
            addr(30-MUTEX_BITS-THREAD_BITS to 29-MUTEX_BITS) := tid;
            addr(30-MUTEX_BITS-THREAD_BITS-COMMAND_BITS to 29-MUTEX_BITS-THREAD_BITS) := cmd;
            return addr;
        end function synch_cmd;

        procedure synchm_lock(   tid : in std_logic_vector(0 to THREAD_BITS-1);
                                mid : in std_logic_vector(0 to MUTEX_BITS-1) ) is
        begin
            bus_trans('1',synch_cmd(tid,mid,SYNCH_LOCK),x"FFFFFFFF");
        end procedure synchm_lock;

        procedure synchm_unlock(   tid : in std_logic_vector(0 to THREAD_BITS-1);
                                  mid : in std_logic_vector(0 to MUTEX_BITS-1) ) is
        begin
            bus_trans('1',synch_cmd(tid,mid,SYNCH_UNLOCK),x"FFFFFFFF");
        end procedure synchm_unlock;

        procedure synchm_trylock(   tid : in std_logic_vector(0 to THREAD_BITS-1);
                                    mid : in std_logic_vector(0 to MUTEX_BITS-1) ) is
        begin
            bus_trans('1',synch_cmd(tid,mid,SYNCH_TRY),x"FFFFFFFF");
        end procedure synchm_trylock;

        procedure synchm_kind( mid : in std_logic_vector(0 to MUTEX_BITS-1) ) is
        begin
            bus_trans('1',synch_cmd(x"00",mid,SYNCH_KIND),x"FFFFFFFF");
        end procedure synchm_kind;

        procedure synchm_count( mid : in std_logic_vector(0 to MUTEX_BITS-1) ) is
        begin
            bus_trans('1',synch_cmd(x"00",mid,SYNCH_COUNT),x"FFFFFFFF");
        end procedure synchm_count;

        procedure synchm_owner( mid : in std_logic_vector(0 to MUTEX_BITS-1) ) is
        begin
            bus_trans('1',synch_cmd(x"00",mid,SYNCH_OWNER),x"FFFFFFFF");
        end procedure synchm_owner;

        procedure synchm_setkind( mid : in std_logic_vector(0 to MUTEX_BITS-1);
                                 kind : in std_logic_vector(0 to KIND_BITS-1)) is
            variable data : std_logic_vector(0 to DATA_BITS-1);
        begin
            data := (others => '0');
            data(DATA_BITS-KIND_BITS to DATA_BITS-1) := kind;
            bus_trans('0',synch_cmd(x"00",mid,SYNCH_KIND),data);
        end procedure synchm_setkind;
	begin
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

        -- Send a bus reset command
        sys_reset;

        -- Setup the mutex kinds
        synchm_setkind( "000000", SYNCH_FAST );
        synchm_setkind( "000001", SYNCH_FAST );
        synchm_setkind( "000010", SYNCH_ERROR );
        synchm_setkind( "000011", SYNCH_RECURS );

        -- Test standard locking and unlocking
        synchm_lock( x"01", "000000" );
        synchm_lock( x"02", "000000" );
        synchm_trylock( x"03", "000000" );
        synchm_lock( x"04", "000000" );
        synchm_unlock( x"01", "000000" );
        synchm_unlock( x"02", "000000" );
        synchm_unlock( x"04", "000000" );

        -- Test that fast mutex locking method works properly
        synchm_lock( x"0A", "000001" );
        synchm_lock( x"0A", "000001" );
        synchm_lock( x"0A", "000001" );
        synchm_lock( x"0A", "000001" );

        -- Test that error checking mutex locking method works properly
        synchm_lock( x"0B", "000010" );
        synchm_lock( x"0B", "000010" );
        synchm_lock( x"0B", "000010" );
        synchm_lock( x"0B", "000010" );

        -- Test that recursive mutex locking method works properly
        synchm_lock( x"0C", "000011" );
        synchm_lock( x"0C", "000011" );
        synchm_lock( x"0C", "000011" );
        synchm_lock( x"0C", "000011" );

        -- Test that getting the owner works properly
        synchm_owner( "000001" );
        synchm_owner( "000010" );
        synchm_owner( "000011" );

        -- Test that getting the count works properly
        synchm_count( "000011" );

        -- Test that getting the kind works properly
        synchm_kind( "000000" );
        synchm_kind( "000001" );
        synchm_kind( "000010" );
        synchm_kind( "000011" );

        -- Test that recursive mutex unlocking works
        synchm_unlock( x"0C", "000011" );
        synchm_unlock( x"0C", "000011" );
        synchm_unlock( x"0C", "000011" );
        synchm_unlock( x"0C", "000011" );

		wait; -- will wait forever
	end process;

    clk : process
    begin
        OPB_Clk <= '0';
        wait for 10 ns;

        loop
            OPB_Clk <= '1', '0' after 5 ns;
            wait for 10 ns;
        end loop;
    end process;
end;
