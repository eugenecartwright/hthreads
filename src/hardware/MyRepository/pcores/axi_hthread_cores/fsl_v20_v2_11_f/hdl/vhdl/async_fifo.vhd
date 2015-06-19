-------------------------------------------------------------------------------
-- $Id: async_fifo.vhd,v 1.1.2.1 2010/10/28 11:17:56 goran Exp $
-------------------------------------------------------------------------------
-- Async_FIFO.vhd - Entity and architecture
-------------------------------------------------------------------------------
--
-- (c) Copyright [2003] - [2010] Xilinx, Inc. All rights reserved.
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
-- PART OF THIS FILE AT ALL TIMES
--
-------------------------------------------------------------------------------
-- Filename:        Async_FIFO.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--              Async_FIFO.vhd
--
-------------------------------------------------------------------------------
-- Author:          goran
-- Revision:        $Revision: 1.1.2.1 $
-- Date:            $Date: 2010/10/28 11:17:56 $
--
-- History:
--   goran  2003-10-27    First Version
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
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity Async_FIFO is
  generic (
    WordSize : Integer := 8;
    MemSize  : Integer := 16;
    Protect  : Boolean := False
    );
  port (
    Reset   : in  Std_Logic;
    -- Clock region WrClk
    WrClk   : in  Std_Logic;
    WE      : in  Std_Logic;
    DataIn  : in  Std_Logic_Vector(WordSize-1 downto 0);
    Full    : out Std_Logic;
    -- Clock region RdClk
    RdClk   : in  Std_Logic;
    RD      : in  Std_Logic;
    DataOut : out Std_Logic_Vector(WordSize-1 downto 0);
    Exists  : out Std_Logic
    );
end Async_FIFO;

architecture VHDL_RTL of ASync_FIFO is

  -----------------------------------------------------------------------------
  -- A function which tries to calculate the best Mem_Size and by that the best
  -- counting scheme
  -----------------------------------------------------------------------------
  function Calculate_Right_Mem_Size (Mem_Size : in Natural) return Integer is
  begin  -- Calculate_Right_Mem_Size
    case Mem_Size is
      when 0 to 3 =>
        assert false report "To small FIFO" severity failure;
        return 0;
      when 4 to 16 => return 16;
      when 17 to 32 => return 32;
      when 33 to 64 => return 64;
      when 65 to 128 =>
        -- Do not yet need to check if to use the up/down counting scheme since
        -- there is not true 7-bit counter implemented yet
        return ((MemSize+15)/16)*16;
      when others =>
        assert false
          report "Unsupported FIFO Depth (Not yet implemented)"
          severity failure;
        return 0;
    end case;
  end Calculate_Right_Mem_Size;

  -----------------------------------------------------------------------------
  -- Create a resolved Boolean type (rboolean)
  -----------------------------------------------------------------------------

  -- Create a Boolean array type
  type boolean_array is array (natural range <>) of boolean;

  -- Function for resolved boolean
  -- If any boolean in the array is false, then the result is false
  function resolve_boolean( values: in boolean_array ) return boolean is
    variable result: boolean := TRUE;
  begin
    if (values'length = 1) then
       result := values(values'low);
    else
    -- coverage off
       for index in values'range loop
          if values(index) = FALSE then
             result := FALSE;
          end if;
       end loop;
    -- coverage on
    end if;
    return result;
  end function resolve_boolean;

  subtype rboolean is resolve_boolean boolean;

  
  -- Convert the FIFO memsize to memsizes in steps of 16
  constant True_Mem_Size : Integer := Calculate_Right_Mem_Size(MemSize);

--   component Gen_DpRAM
--     generic (
--       Use_Muxes : Boolean := False;
--       Mem_Size  : Integer := 36;
--       Addr_Size : Integer := 6;
--       Data_Size : Integer := 16
--       );
--     port (
--       Reset    : in  Std_Logic;
--       -- Read/Write port 1
--       Addr1    : in  Std_Logic_Vector(Addr_Size-1 downto 0);
--       WrClk    : in  Std_Logic;
--       WE       : in  Std_Logic;
--       DataIn   : in  Std_Logic_Vector(Data_Size-1 downto 0);
--       DataOut1 : out Std_Logic_Vector(Data_Size-1 downto 0);
--       -- Read port 2
--       Addr2    : in  Std_Logic_Vector(Addr_Size-1 downto 0);
--       DataOut2 : out Std_Logic_Vector(Data_Size-1 downto 0)
--       );
--   end component;    

  ----------------------------------------------------------------------
  -- Returns the vector size needed to represent the X
  -- The result is > 0
  ----------------------------------------------------------------------
  function Vec_Size( X : in Natural) return Natural is
    variable I : Natural := 1;
  begin
    while (2**I) < X loop
      I := I + 1;
    end loop;
    return I;
  end function Vec_Size;

  -- Declare the types and constant counting schemes
  subtype Count_Word is Std_Logic_Vector(3 downto 0);
  type Count_Array_Type is array (integer range <>) of Count_Word;

  -- Even if there is four bits for the Cnt8, the fourth bit will never be used
  constant Cnt8  : Count_Array_Type(0 to  7) := ( "0000","0001","0011","0010",
                                                  "0110","0111","0101","0100");
  constant Cnt10 : Count_Array_Type(0 to  9) := ( "0000","1000","1001","0001",
                                                  "0011","0010","0110","0111",
                                                  "0101","0100" );
  constant Cnt12 : Count_Array_Type(0 to 11) := ( "0000","1000","1001","1011",
                                                  "1010","0010","0011","0001",
                                                  "0101","0111","0110","0100" );
  constant Cnt14 : Count_Array_Type(0 to 13) := ( "0000","1000","1100","1101",
                                                  "1001","1011","1010","0010",
                                                  "0011","0001","0101","0111",
                                                  "0110","0100");
  constant Cnt16 : Count_Array_Type(0 to 15) := ( "0000","0001","0011","0010",
                                                  "0110","0100","0101","0111",
                                                  "1111","1110","1100","1101",
                                                  "1001","1011","1010","1000");

  -----------------------------------------------------------------------------
  -- A function that do all the boolean equations for a counting scheme
  -- given as a parameter
  -- The synthesis tool will unroll the loops and then do the boolean equation
  -- minimization (hopefully the optimimal).
  -- At present it only handles counting scheme with 4 bits due to the
  -- Count_Array_Type definition
  -----------------------------------------------------------------------------
  function Gen_Counter(Count_Scheme : in Count_Array_Type;
                       Up           : in Boolean;
                       Count        : in Std_Logic_Vector)
          return Std_Logic_Vector is
    variable Temp   : Std_Logic;
    variable L      : Integer range Count_Scheme'Range;
    variable Q      : Std_Logic_Vector(Count'Length-1 downto 0);
    variable Q_Temp : Std_Logic_Vector(Count'Length-1 downto 0);
  begin  -- Gen_Counter
    Q := Count;
    for G in Q'Range loop
      Q_Temp(G) := '0';
      for I in Count_Scheme'range loop
        if Count_Scheme(I)(G) = '1' then
          if Up then 
            L := I - 1;
          else
            if I /= Count_Scheme'High then
              L := I + 1;
            else
              L := Count_Scheme'Low;
            end if;
          end if;
          Temp := '1';
          for J in Q'Range loop
            if Count_Scheme(L)(J) = '1' then
              Temp := Temp and Q(J);
            else
              Temp := Temp and  not Q(J);                  
            end if;
          end loop;
          Q_Temp(G) := Q_Temp(G) or Temp;
        end if;
      end loop;  -- I
    end loop;  -- G
    return Q_Temp;
  end Gen_Counter;
 
  ----------------------------------------------------------------------
  -- Generate the Address counter for FIFO handling
  -- generates different counters depending of the counter size
  ----------------------------------------------------------------------
  Procedure FIFO_Count( Count : inout Std_Logic_Vector;
                        Incr  : in    Boolean;
                        Up    : inout Boolean;
                        Change : inout Boolean) is
    variable Cnt : Std_Logic_Vector(Count'Left-Count'Right downto 0) := Count;
    variable Res : Std_Logic_Vector(Count'Left-Count'Right downto 0) := Count;
  begin
    if True_Mem_Size = 16 then
      if Incr then
        Res := Gen_Counter(Cnt16,True,Cnt);
      end if;
    elsif True_Mem_Size = 32 then
      if Incr then
        if not Change and
          (( (Cnt(2 downto 0) = "100") and Up) or
           ( (Cnt(2 downto 0) = "000") and not Up)) then
          Res(4)          := Cnt(3);
          Res(3)          := not Cnt(4);
          Res(2 downto 0) := Cnt(2 downto 0);
          Up              := not Up;
          Change          := True;
        else
          Change          := False;
          Res(4 downto 3) := Cnt(4 downto 3);
          Res(2 downto 0) := Gen_Counter(Cnt8,Up,Cnt(2 downto 0));
        end if;
      end if;
    elsif True_Mem_Size = 64 then
      if Incr then
        if not Change and
          (( (Cnt(3 downto 0) = Cnt16(Cnt16'High)) and Up) or
           ( (Cnt(3 downto 0) = Cnt16(Cnt16'Low)) and not Up)) then
          Res(5)          := Cnt(4);
          Res(4)          := not Cnt(5);
          Res(3 downto 0) := Cnt(3 downto 0);
          Up              := not Up;
          Change          := True;
        else
          Change          := False;
          Res(5 downto 4) := Cnt(5 downto 4);
          Res(3 downto 0) := Gen_Counter(Cnt16,Up,Cnt(3 downto 0));
        end if;
      end if;
    elsif True_Mem_Size = 128 then
      -- Do a 3-bit grey counter + a 4-bit grey counter
      if Incr then
        if not Change and
          (( (Cnt(3 downto 0) = Cnt16(Cnt16'High)) and Up) or
           ( (Cnt(3 downto 0) = Cnt16(Cnt16'Low)) and not Up)) then
          Res(6 downto 4) := Gen_Counter(Cnt8,True,Cnt(6 downto 4));
          Res(3 downto 0) := Cnt(3 downto 0);
          Up              := not Up;
          Change          := True;
        else
          Change          := False;
          Res(6 downto 4) := Cnt(6 downto 4);
          Res(3 downto 0) := Gen_Counter(Cnt16,Up,Cnt(3 downto 0));
        end if;
      end if;      
    else
      assert false
        report "To BIG FIFO (not yet supported)"
        severity failure;
    end if;
    Count := Res;
  end FIFO_Count;

  Procedure FIFO_Counter( signal Count : inout Std_Logic_Vector;
                        Incr  : in    Boolean;
                        Up    : inout Boolean;
                        Change : inout Boolean) is 
    variable Res : Std_Logic_Vector(Count'Left-Count'Right downto 0) := Count;   
  begin 
     FIFO_Count(Res,Incr,Up,Change);   
     Count <= Res;
  end FIFO_Counter;

  constant Log2_Mem_Size : Integer := Vec_Size(True_Mem_Size);
  
  -- The read and write pointers
  subtype Pointer_Type is Std_Logic_Vector(Log2_Mem_Size-1 downto 0);
  signal Write_Ptr       : Pointer_Type;
  signal Read_Ptr        : Pointer_Type;
  signal Write_Addr      : Pointer_Type;
  signal Read_Addr       : Pointer_Type;

  signal DataOut1 : Std_Logic_Vector(WordSize-1 downto 0); -- NOT USED

  signal Dir_Latched : Boolean;
  signal Direction   : Boolean;
  signal Equal       : Boolean;
  signal Full_I      : Boolean;
  signal Empty_I     : Boolean;
  signal Full_Out    : Boolean;
  signal Empty_Out   : Boolean;

  signal Read  : rboolean;
  signal Write : rboolean;

  -----------------------------------------------------------------------------
  -- Implement the RAM with pure RTL
  -----------------------------------------------------------------------------
  type RAM_TYPE is array (natural range 0 to MemSize-1) of std_logic_vector(WordSize-1 downto 0);
  signal Memory : RAM_TYPE := (others => (others => '0'));
  
begin

  -----------------------------------------------------------------------------
  -- Change the Read and Write pointer to get the FIFO addresses
  -- This will get the four lowest bits from the Read/Write pointers to be the
  -- higest bits in FIFO addresses. This assures that when the FIFO depth is
  -- not a power of 2, that the FIFO addresses is within the FIFO depth range
  -----------------------------------------------------------------------------
  Do_FIFO_Addr : process (Write_Ptr, Read_Ptr)
  begin  -- process Do_FIFO_Addr
    Write_Addr(Write_Addr'High downto Write_Addr'High-3) <=
      Write_Ptr(3 downto 0);
    if Write_Ptr'Length > 4 then
      Write_Addr(Write_Addr'High-4 downto Write_Addr'Low) <=
        Write_Ptr(Write_Ptr'High downto 4);
    end if;
    Read_Addr(Read_Addr'High downto Read_Addr'High-3) <=
      Read_Ptr(3 downto 0);
    if Read_Ptr'Length > 4 then
      Read_Addr(Read_Addr'High-4 downto Read_Addr'Low) <=
        Read_Ptr(Read_Ptr'High downto 4);
    end if;
  end process Do_FIFO_Addr;
  
  ----------------------------------------------------------------------
  -- Instansiate the Dual Port memory
  ----------------------------------------------------------------------
  Write_To_Memory: process (WrClk) is
  begin  -- process Write_To_Memory
    if WrClk'event and WrClk = '1' then     -- rising clock edge
      if WE = '1' then
        Memory(to_integer(unsigned(Write_Addr))) <= DataIn;
      end if;
    end if;
  end process Write_To_Memory;

  DataOut1 <= Memory(to_integer(unsigned(Write_Addr)));
  DataOut  <= Memory(to_integer(unsigned(Read_Addr)));
  
--  FIFO_MEM :  Gen_DpRAM 
--    generic map(
--      Use_Muxes => true,
--      Mem_Size  => MemSize,
--      Addr_Size => Log2_Mem_Size,
--      Data_Size => WordSize
--      )
--    port map (
--      Reset    => Reset,
--      Addr1    => Write_Addr,
--      WrClk    => WrClk,
--      WE       => WE,
--      DataIn   => DataIn,
--      DataOut1 => DataOut1,
--      Addr2    => Read_Addr,
--      DataOut2 => DataOut
--      );

  Protect_FIFO : if Protect generate
    Read  <= (Rd = '1') and not Empty_Out;
    Write <= (We = '1') and not Full_Out;
  end generate Protect_FIFO;

  Non_Protect_FIFO : if not Protect generate
    Read  <= (Rd = '1');
    Write <= (We = '1');
  end generate Non_Protect_FIFO;
  ----------------------------------------------------------------------
  -- Read Pointer
  ----------------------------------------------------------------------
  Read_Ptr_Counter : process(Reset,RdClk)
    variable Up     : Boolean;
    variable Change : Boolean;
  begin
    if (Reset = '1') then
      Read_Ptr <= (others => '0');
      Up       := True;
      Change   := False;
    elsif RdClk'Event and RdClk = '1' then
      FIFO_Counter(Read_Ptr,Read,Up,Change);
    end if;
  end process Read_Ptr_Counter;
  
  ----------------------------------------------------------------------
  -- Write Pointer
  ----------------------------------------------------------------------
  Write_Ptr_Counter : process(Reset,WrClk)
    variable Up     : Boolean;
    variable Change : Boolean;
  begin
    if (Reset = '1') then
      Write_Ptr <= (others => '0');
      Up        := True;
      Change   := False;
    elsif WrClk'Event and WrClk = '1' then
      FIFO_Counter(Write_Ptr,Write,Up,Change);
    end if;
  end process Write_Ptr_Counter;
  
  ----------------------------------------------------------------------
  -- Flag handling
  ----------------------------------------------------------------------

  -------------------------------------------------------------------------
  -- Dir_Latched is false after reset and then true after the first write
  ---------------------------------------------------------------------------
  Direction_Latch : process(Reset,WE,WrClk)
  begin
    if (Reset = '1') then
      Dir_Latched <= False;
    elsif WrClk'Event and WrClk = '1' then
      Dir_Latched <= Dir_Latched or (WE = '1');
    end if;
  end process Direction_Latch;

  -----------------------------------------------------------------------------
  -- Trying to see if the read pointer is catching up the write pointer or
  -- vice verse
  -- The top two bits of the pointers always counts as follows
  -- 00
  -- 01
  -- 11
  -- 10
  -- 00
  -- ..
  -- So if read pointer is one step behind the write pointer => Reset = True
  -- And if write pointer is one step behind the read pointer => Set = True
  -----------------------------------------------------------------------------
  Direction_Proc : process(Read_Ptr, Write_Ptr, Dir_Latched, Direction)
    variable Set       : Boolean;
    variable Clear     : Boolean;
    variable Read_MSB  : Std_Logic_Vector(1 downto 0);
    variable Write_MSB : Std_Logic_Vector(1 downto 0);
  begin
   Read_MSB  := Read_Ptr(Read_Ptr'Left) & Read_Ptr(Read_Ptr'Left-1);
   Write_MSB := Write_Ptr(Write_Ptr'Left) & Write_Ptr(Write_Ptr'Left-1);
   if (Read_MSB = "00" and Write_MSB = "01") or
      (Read_MSB = "01" and Write_MSB = "11") or
      (Read_MSB = "11" and Write_MSB = "10") or
      (Read_MSB = "10" and Write_MSB = "00") then
     Clear := True;
   else
     Clear := False;
   end if;
   if (Write_MSB = "00" and Read_MSB = "01") or
      (Write_MSB = "01" and Read_MSB = "11") or
      (Write_MSB = "11" and Read_MSB = "10") or
      (Write_MSB = "10" and Read_MSB = "00") then
     Set := True;
   else
     Set := False;
   end if;
   Direction <= not ((not Dir_Latched) or Clear or not(Set or Direction));
  end process Direction_Proc;

  Equal   <= (Read_Ptr = Write_Ptr);
  Full_I  <= Equal and Direction;
  Empty_I <= Equal and not Direction;
             
  -- Allow Empty to go active directly since the change is due to a read
  -- which means that the Empty_I is synchronized with RdClk.
  -- But is only allow to go inactive when RdClk is High since the transaction
  -- is due to a Write and Empty_I is NOT synchronized with RdClk.
  -- By this way the Empty is not changed state just before rising edge of RdClk
  Empty_DFF : process(Empty_I,RdClk)
  begin
    if Empty_I then
      Empty_Out <= True;
    elsif RdClk'Event and RdClk = '1' then
      Empty_Out <= Empty_I;
    end if;
  end process Empty_DFF;

  Exists <= '0' when Empty_Out else '1';

  -- See above but for Full and WrClk
  Full_DFF : process(Full_I,WrClk)
  begin
    if Full_I then
      Full_Out <= True;
    elsif WrClk'Event and WrClk = '1' then
      Full_Out <= Full_I;
    end if;
  end process Full_DFF;

  Full <= '1' when Full_Out else '0';
  
end VHDL_RTL;


