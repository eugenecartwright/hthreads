-------------------------------------------------------------------------------
-- icap_statemachine.vhd - entity/architecture pair

-------------------------------------------------------------------------------
-- (c) Copyright 2010 - 2011 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-- Filename:        icap_statemachine.vhd
-- Version :        v7.01a
-- Description:     This module genrates the ce, we signals to ICAP
--                  based on busy signal,control register & FIFO flags
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_com"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library axi_lite_ipif_v3_0;
library lib_pkg_v1_0;
use lib_pkg_v1_0.lib_pkg.all;
use axi_lite_ipif_v3_0.ipif_pkg.all;
-------------------------------------------------------------------------------
-- -- Generics
--  ICAP_DWIDTH         -- Icap Data Width;
--  C_FAMILY            -- Family of FPGA
-- -- Inputs
--  Clk                 -- Clock
--  Rst                 -- Reset
--  Wrfifo_dataout      -- Write fifo data read
--  Icap_dataout        -- ICAP data out
--  Wrfifo_empty        -- Write fifo empty
--  Wrfifo_full         -- Write fifo full
--  Rdfifo_empty        -- Read fifo empty
--  Rdfifo_full         -- Read fifo full
--  Icap_busy           -- ICAP busy
--  Rnc                 -- Read not configuration
--  Size                -- Size of data transfer in words
-- -- Outputs
--  Wrfifo_rden         -- Write fifo read enable
--  Rdfifo_wren         -- Read fifo write enable
--  Icap_ce             -- ICAP chip enable
--  Icap_we             -- ICAP write eneble
--  Send_done           -- Read done
--  Reset_cr            -- Reset the control register
--  Icap_datain         -- ICAP data in
--  Rdfifo_datain       -- Read fifo data in
-------------------------------------------------------------------------------

entity icap_statemachine is
  generic (
    ICAP_DWIDTH         : integer := 16;
    C_MODE              : integer := 0;
    C_FAMILY            : string  := "virtex7");
  port (
    Clk                 : in  std_logic;
    Rst                 : in  std_logic;
    Wrfifo_dataout      : in  std_logic_vector(0 to ICAP_DWIDTH-1);
    Icap_dataout        : in  std_logic_vector(0 to ICAP_DWIDTH-1);
    Wrfifo_full         : in  std_logic;
    Wrfifo_empty        : in  std_logic;
    Rdfifo_empty        : in  std_logic;
    Rdfifo_full         : in  std_logic;
    Icap_busy           : in  std_logic;
    Rnc                 : in  std_logic_vector(0 to 1);
    Abort               : in  std_logic;
    Size                : in  std_logic_vector(0 to 11);
    Status_read         : in  std_logic;
    Size_counter        : out std_logic_vector(0 to 11);
    Wrfifo_rden         : out std_logic;
    Rdfifo_wren         : out std_logic;
    Icap_ce             : out std_logic;
    Icap_we             : out std_logic;
    Send_done           : out std_logic;
    Reset_cr            : out std_logic;
    Abort_in_progress   : out std_logic;
    Hang_status         : out std_logic;
    Icap_status         : out std_logic_vector(0 to 31);
    Icap_datain         : out std_logic_vector(0 to ICAP_DWIDTH-1);
    Rdfifo_datain       : out std_logic_vector(0 to ICAP_DWIDTH-1)
    );

attribute KEEP : string;
attribute KEEP of Icap_ce : signal is "TRUE";
attribute KEEP of Icap_we : signal is "TRUE";
attribute KEEP of Icap_datain : signal is "TRUE";
attribute KEEP of Icap_dataout : signal is "TRUE";
attribute KEEP of Icap_busy : signal is "TRUE";

end entity icap_statemachine;

architecture imp of icap_statemachine is
  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";

attribute mark_debug : string;
  -- icap state machine
  type  SM_TYPE is (ICAP_IDLE,ICAP_WRITE1,ICAP_WRITE2,ICAP_WRITE3,ICAP_WRITE4,
                    ICAP_WRITE5,ICAP_READ1,ICAP_ABORT0,ICAP_ABORT_HANG,ICAP_ABORT1,ICAP_ABORT2,
                    ICAP_ABORT3,ICAP_ABORT4,DONE);
  signal icap_nstate_ns, icap_nstate_cs : SM_TYPE;
  signal icap_ce_ns,icap_ce_cs,icap_ce_cs1  : std_logic;
  signal icap_we_ns,icap_we_cs,icap_we_cs1  : std_logic;
  signal rdfifo_wren_ns,rdfifo_wren_cs : std_logic;
  signal wrfifo_rden_ns : std_logic;
  signal Send_done_ns,Send_done_cs : std_logic;
  signal size_ns,size_cs : std_logic_vector(0 to 11);
  signal reset_cr_cs,reset_cr_ns: std_logic;
  signal abort_ns,abort_cs,abort_cs2 : std_logic;
  signal icap_status_i  : std_logic_vector(0 to 31);
  signal abort_i_ns,abort_i_cs,abort_i_cs2: std_logic;
  signal icap_dataout_i : std_logic_vector(0 to ICAP_DWIDTH-1);
  signal Wrfifo_empty_r,Wrfifo_empty_r1 : std_logic;
  signal tmp_datain_ns,tmp_datain_cs : std_logic_vector(0 to ICAP_DWIDTH-1);
  signal icap_datain_ns,icap_datain_cs, int1, int2 : std_logic_vector(0 to ICAP_DWIDTH-1);
  signal stm_skip : std_logic;
  signal count : std_logic_vector (2 downto 0);
  signal count_enable_ns, count_enable_cs : std_logic;
  signal count_reset_ns, count_reset_cs : std_logic;
  signal hang_status_ns, hang_status_cs : std_logic := '0';
attribute mark_debug of icap_ce_cs : signal is "true";
attribute mark_debug of icap_we_cs: signal is "true";
attribute mark_debug of icap_datain_cs : signal is "true";
attribute mark_debug of icap_dataout_i : signal is "true";

begin


GEN_SKIP : if (C_MODE = 1) generate
begin
     stm_skip <= '1';
end generate GEN_SKIP;


GEN_NOSKIP : if (C_MODE = 0) generate
begin
     stm_skip <= '0';
end generate GEN_NOSKIP;


-------------------------------------------------------------------------------
-- ICAP FSM
-------------------------------------------------------------------------------
ICAP_FSM_NS : process (icap_nstate_cs,Rnc,Abort,Rdfifo_full,
              Size,size_cs,Wrfifo_empty,Wrfifo_empty_r,Wrfifo_empty_r1,
              Send_done_cs,Status_read,
              icap_ce_cs,icap_we_cs,Icap_busy,stm_skip,
              count_enable_cs, count_reset_cs, hang_status_cs, count)
      begin
            -- default
            rdfifo_wren_ns      <= '0';
            wrfifo_rden_ns      <= '0';
            Send_done_ns        <= Send_done_cs;
            reset_cr_ns         <= '0';
            icap_ce_ns          <= icap_ce_cs;
            icap_we_ns          <= icap_we_cs;
            icap_nstate_ns      <= icap_nstate_cs;
            size_ns             <= size_cs;
            abort_ns            <= '0';
            abort_i_ns          <= '0';
            count_enable_ns <= count_enable_cs;
            count_reset_ns <= count_reset_cs;
            hang_status_ns <= hang_status_cs;
--            tmp_datain_ns       <= tmp_datain_cs;
--            icap_datain_ns      <= icap_datain_cs;
         case icap_nstate_cs is

            when ICAP_IDLE      =>
               if Status_read = '1' then
                  abort_ns   <= '0';
                  count_enable_ns       <= '0';
               end if;   
               if Abort = '1' then
                  reset_cr_ns        <= '0';
	          icap_ce_ns         <= '0';
	          abort_i_ns         <= '1';
                  icap_nstate_ns     <= ICAP_ABORT0;
               elsif Rnc = "01" then
                  if Wrfifo_empty = '0'then
                    icap_nstate_ns   <= ICAP_WRITE1;
                    wrfifo_rden_ns   <= '1';
                    Send_done_ns     <= '0';
                    reset_cr_ns      <= '0';
                  else
                    icap_nstate_ns   <= ICAP_IDLE;
                  end if;
               elsif Rnc = "10" then
                  if Rdfifo_full = '0'then
                    icap_nstate_ns   <= ICAP_READ1;
                    Send_done_ns     <= '0';
                    reset_cr_ns      <= '0';
                    size_ns          <= Size;
                  else
                    icap_nstate_ns   <= ICAP_IDLE;
                  end if;
               else
                  Send_done_ns     <= '1';
                  reset_cr_ns      <= '0';
                  icap_nstate_ns   <= ICAP_IDLE;
               end if;
                  count_reset_ns <= '1';
                  count_enable_ns       <= '0';

            when ICAP_WRITE1    =>
--               tmp_datain_ns    <= Wrfifo_dataout;
               icap_we_ns       <= '0';
               if Wrfifo_empty = '1' then
                  icap_nstate_ns   <= ICAP_WRITE3;
                  wrfifo_rden_ns   <= '0';
               else 
                  icap_nstate_ns   <= ICAP_WRITE5;
                  wrfifo_rden_ns   <= '1';
               end if;   
            when ICAP_WRITE5    =>
               icap_ce_ns       <= '0';
               icap_we_ns       <= '0';
--               tmp_datain_ns    <= Wrfifo_dataout;
--               icap_datain_ns   <= tmp_datain_cs;
               icap_nstate_ns   <= ICAP_WRITE2;
               if Wrfifo_empty = '1' then
                  wrfifo_rden_ns   <= '0';
               else 
                  wrfifo_rden_ns   <= '1';
               end if;   
            
            when ICAP_WRITE2    =>
               if Status_read = '1' then
                  abort_ns   <= '0';
               end if;
               if Wrfifo_empty_r1 = '0' then
                  icap_ce_ns       <= '0';
                  icap_we_ns       <= '0';
--                  tmp_datain_ns    <= Wrfifo_dataout;
--                  icap_datain_ns   <= tmp_datain_cs;
                  if Abort = '1' and icap_ce_cs = '0'then
                     icap_nstate_ns    <= ICAP_ABORT1;
                     icap_we_ns        <= '1';
                     abort_i_ns        <= '1';                  
              --    elsif (Icap_busy = '0' and Wrfifo_empty_r = '0') then
                  elsif (Wrfifo_empty_r = '0') then
                     icap_nstate_ns   <= ICAP_WRITE2;
                     wrfifo_rden_ns   <= '1'; 
                  else 
                     icap_nstate_ns   <= ICAP_WRITE2;                  
                     wrfifo_rden_ns   <= '0'; 
                  end if;
               else
                  icap_nstate_ns   <= DONE;
	          Send_done_ns     <= '1';
	          reset_cr_ns      <= '1';
                  wrfifo_rden_ns   <= '0';
--                  tmp_datain_ns    <= (others => '0');
--                  icap_datain_ns   <= (others => '0');
                  icap_ce_ns       <= '1';
                  icap_we_ns       <= '0';
               end if;

            when ICAP_WRITE3 =>               
               icap_ce_ns       <= '0';
               icap_we_ns       <= '0';
--               icap_datain_ns   <= tmp_datain_cs;
               if (stm_skip = '1') then             -- Skipping to maintain single write on ICAP
                  icap_nstate_ns   <= DONE;         -- This is not required in actual h/w, and is more of simulation fix
               elsif (Icap_busy = '0') then
                  icap_nstate_ns   <= ICAP_WRITE4;
               else
                  icap_nstate_ns   <= ICAP_WRITE3;               
               end if;
               
            when ICAP_WRITE4 =>               
                  icap_nstate_ns   <= DONE;
	          Send_done_ns     <= '1';
	          reset_cr_ns      <= '1';
--                  tmp_datain_ns    <= (others => '0');
--                  icap_datain_ns   <= (others => '0');
                  icap_ce_ns       <= '1';
                  icap_we_ns       <= '0';

            when ICAP_READ1 =>
             if Status_read = '1' then
                abort_ns   <= '0';
             end if;   
             if Rdfifo_full = '0' then
                if (size_cs > 0) then
                  if Abort = '1' and icap_ce_cs = '0'then
                     icap_ce_ns         <= '0';
                     icap_we_ns         <= '1';
                     icap_we_ns        <= '0';
                     abort_i_ns        <= '1';
                     icap_nstate_ns    <= ICAP_ABORT1;
                     count_enable_ns      <= '0';
                     hang_status_ns    <= '0';
                  elsif Icap_busy = '0' then
                     if (size_cs = 1) then
                       icap_nstate_ns    <= DONE;
                       icap_ce_ns         <= '1';
                     else
                       icap_ce_ns         <= '0';
                       icap_nstate_ns    <= ICAP_READ1;
                     end if;
                     size_ns           <= size_cs - 1;
                     icap_we_ns         <= '1';
                     rdfifo_wren_ns    <= '1';
                     count_enable_ns      <= '0';
                     hang_status_ns <= '0';
                  else
                     icap_ce_ns         <= '0';
                     icap_we_ns         <= '1';
                     if (count = "111") then
                        hang_status_ns <= '1';
                        icap_nstate_ns    <= ICAP_ABORT_HANG;
                     else
                        icap_nstate_ns    <= ICAP_READ1;
                        hang_status_ns <= '0';
                     end if;
                     size_ns           <= size_cs;
                     rdfifo_wren_ns    <= '0';
                     count_enable_ns      <= '1';    -- This is used to increment timeout counter
                     count_reset_ns <= '0';
                  end if;
                else
                   icap_ce_ns         <= '1';
                   icap_we_ns         <= '1';
                   rdfifo_wren_ns     <= '0';
                   Send_done_ns       <= '1';
                   reset_cr_ns        <= '1';
                   count_enable_ns       <= '0';
                   icap_nstate_ns     <= DONE;
                end if;
             else
                rdfifo_wren_ns     <= '0';
                icap_ce_ns         <= '0'; -- Not aborting, only gating
                icap_we_ns         <= '1';
                count_enable_ns       <= '0';
                icap_nstate_ns     <= ICAP_READ1;
             end if;
            when ICAP_ABORT0    =>
               abort_i_ns          <= '1';
               icap_we_ns          <= '0';
               if Icap_busy = '1' and icap_ce_cs = '0' then
                  icap_nstate_ns     <= ICAP_ABORT2;
               else
                  icap_nstate_ns     <= ICAP_ABORT0;
               end if;

            when ICAP_ABORT_HANG    =>    -- Internally de-locking the ICAP
                  abort_i_ns         <= '0';
                  abort_ns           <= '0';
                  icap_ce_ns         <= '1';
                  icap_we_ns         <= '1';
                  count_reset_ns <= '1';
                  count_enable_ns <= '0';
                  hang_status_ns <= '1';
	          icap_nstate_ns     <= DONE;

            when ICAP_ABORT1    =>
               abort_i_ns             <= '1';
 --              if Icap_busy = '1' and icap_ce_cs = '0' then
                  icap_nstate_ns     <= ICAP_ABORT2;
 --              else
 --                 icap_nstate_ns     <= ICAP_ABORT1;
 --              end if;
            when ICAP_ABORT2    =>
                  abort_i_ns         <= '1';
                  abort_ns           <= '1';
	          icap_nstate_ns     <= ICAP_ABORT3;
	    when ICAP_ABORT3    =>
                  abort_i_ns         <= '1';
                  abort_ns           <= '1';
	          icap_nstate_ns     <= ICAP_ABORT4;
	    when ICAP_ABORT4    =>
                  abort_i_ns         <= '0'; -- Asserted for 4 clocks
                  abort_ns           <= '1';
	          icap_nstate_ns     <= DONE;
            when DONE =>
               if Status_read = '1' then
                  abort_ns   <= '0';
               end if;
               abort_i_ns         <= '0'; -- Asserted for 4 clocks
               icap_ce_ns            <= '1';
	       icap_we_ns            <= '1';
--               tmp_datain_ns    <= (others => '0');
--               icap_datain_ns   <= (others => '0');
	       Send_done_ns          <= '1';
	       reset_cr_ns           <= '1';
               count_reset_ns <= '0';
               count_enable_ns <= '0';
	       if Rnc = "00" and Abort = '0' then
	         icap_nstate_ns        <= ICAP_IDLE;
	       else
	         icap_nstate_ns        <= DONE;
	       end if;

            -- This part of the code never executes, because all of the
            -- combinations are used above. "When others =>" added to
            -- allow the synthesis tool to optimize the design well
            -- coverage off
            when others     =>
               icap_nstate_ns       <= ICAP_IDLE;
            -- coverage on
         end case;
      end process ICAP_FSM_NS;


-------------------------------------------------------------------------------
-- ICAP Timeout reg process
-------------------------------------------------------------------------------
ICAP_TIMEOUT_REG: process (Clk) is
       begin
          if (Clk'event and Clk = '1') then
             if (Rst = '1') then
                count <= (others => '0');
             elsif (count_reset_cs = '1') then
                count <= (others => '0');
             elsif (count_enable_cs = '1' and count < "111" ) then
                count <= count + '1';         
             end if;
        end if;
end process ICAP_TIMEOUT_REG;



-------------------------------------------------------------------------------
-- ICAP FSM reg process
-------------------------------------------------------------------------------
ICAP_FSM_REG: process (Clk) is
       begin
          if (Clk'event and Clk = '1') then
             if (Rst = '1') then
                  icap_nstate_cs            <= ICAP_IDLE;
                  Send_done_cs              <= '1';
                  icap_ce_cs                <= '1';
                  icap_we_cs                <= '1';
                  icap_ce_cs1                <= '1';
                  icap_we_cs1                <= '1';
                  size_cs                   <= (others =>'0');
               --   tmp_datain_cs             <= (others => '0');
                  icap_datain_cs            <= (others =>'0');
                  count_enable_cs             <= '0'; 
                  count_reset_cs             <= '0'; 
                  hang_status_cs             <= '0'; 
                  int1        <= (others => '0');
                  int2        <= (others => '0');
             else          
                  icap_nstate_cs            <= icap_nstate_ns;
                  Send_done_cs              <= Send_done_ns;
                  icap_ce_cs                <= icap_ce_ns;
                  icap_ce_cs1                <= icap_ce_cs;
                  icap_we_cs                <= icap_we_ns;
                  icap_we_cs1                <= icap_we_cs;
                  size_cs                   <= size_ns;
                --  tmp_datain_cs             <= tmp_datain_ns;
                  int1                     <= Wrfifo_dataout;
                  icap_datain_cs            <= int1; --icap_datain_ns;
                  count_enable_cs             <= count_enable_ns; 
                  count_reset_cs             <= count_reset_ns; 
                  hang_status_cs             <= hang_status_ns; 
             end if;
        end if;
end process ICAP_FSM_REG;

       Hang_status <= hang_status_cs;

ICAP_SIG_REG: process (Clk) is
       begin
          if (Clk'event and Clk = '1') then
            abort_cs                  <= abort_ns;
            abort_cs2                  <= abort_cs;
            reset_cr_cs               <= reset_cr_ns;
            abort_i_cs                <= abort_i_ns;
            abort_i_cs2               <= abort_i_cs;
            Wrfifo_empty_r            <= Wrfifo_empty;
            Wrfifo_empty_r1           <= Wrfifo_empty_r;
            rdfifo_wren_cs            <= rdfifo_wren_ns;
        end if;
end process ICAP_SIG_REG;


S1:     Rdfifo_wren           <= rdfifo_wren_cs;
S2:     Wrfifo_rden           <= wrfifo_rden_ns;
S3:     Send_done             <= Send_done_cs;
S4:     Icap_ce               <= icap_ce_cs;
S5:     Icap_we               <= icap_we_cs;
S6:     Reset_cr              <= reset_cr_cs;
S7:     Size_counter          <= size_cs;
S8:     Abort_in_progress     <= abort_cs2;
S9:     Icap_status           <= icap_status_i;
-----------------------------------------------------------------------------
-- Need to do bit swapping within each byte but not for Virtex4 in 32-bit mode
-------------------------------------------------------------------------------
SWAP_BITS: process (icap_datain_cs) is
  begin  -- process Swap_bit_Order
        for byte in 0 to (ICAP_DWIDTH/8-1) loop
          for bit in 0 to 7 loop
            Icap_datain(byte*8 + (7-bit))    <= icap_datain_cs(byte*8 + bit);
--            Rdfifo_datain (byte*8 + (7-bit)) <= icap_dataout_i(byte*8 + bit);
          end loop;  -- Bit
        end loop;  -- Byte
  end process SWAP_BITS;

SWAP_BITS_IN: process (icap_dataout_i) is
  begin  -- process Swap_bit_Order
        for byte in 0 to (ICAP_DWIDTH/8-1) loop
          for bit in 0 to 7 loop
       --     Icap_datain(byte*8 + (7-bit))    <= icap_datain_cs(byte*8 + bit);
            Rdfifo_datain (byte*8 + (7-bit)) <= icap_dataout_i(byte*8 + bit);
          end loop;  -- Bit
        end loop;  -- Byte
  end process SWAP_BITS_IN;


-------------------------------------------------------------------------------
-- UPDATE_STATUS_PROCESS
-------------------------------------------------------------------------------
-- This process loads data from Icap_dataout when abort_i_cs enabled
-------------------------------------------------------------------------------
  UPDATE_STATUS_PROCESS:process (Clk)
  begin
    if Clk'event and Clk = '1' then
      if (Rst = '1') then
         icap_status_i <= (others => '0');
      elsif abort_i_cs2 = '1' then 
         icap_status_i (0 to 7) <= Icap_dataout(ICAP_DWIDTH-8 to ICAP_DWIDTH-1);
         icap_status_i (8 to 15) <= icap_status_i (0 to 7);
         icap_status_i (16 to 23) <= icap_status_i (8 to 15);
         icap_status_i (24 to 31) <= icap_status_i (16 to 23);
      else
         icap_status_i <= icap_status_i;
      end if;
    end if;
  end process UPDATE_STATUS_PROCESS;
  
-------------------------------------------------------------------------------
-- This process registers ICAP data out 
-------------------------------------------------------------------------------

  ICAPDOUT_PROCESS:process (Clk)
  begin
    if Clk'event and Clk = '1' then
      icap_dataout_i <= Icap_dataout;
    end if;
  end process ICAPDOUT_PROCESS;


end architecture imp;
