------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Mon Apr  6 14:20:46 2009 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library fsl_v20_v2_11_a;
use fsl_v20_v2_11_a.all;


--library proc_common_v2_00_a;
--use proc_common_v2_00_a.proc_common_pkg.all;
--use proc_common_v2_00_a.srl_fifo_f;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_MST_AWIDTH                 -- Master interface address bus width
--   C_MST_DWIDTH                 -- Master interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_MstRd_Req             -- IP to Bus master read request
--   IP2Bus_MstWr_Req             -- IP to Bus master write request
--   IP2Bus_Mst_Addr              -- IP to Bus master address bus
--   IP2Bus_Mst_BE                -- IP to Bus master byte enables
--   IP2Bus_Mst_Lock              -- IP to Bus master lock
--   IP2Bus_Mst_Reset             -- IP to Bus master reset
--   Bus2IP_Mst_CmdAck            -- Bus to IP master command acknowledgement
--   Bus2IP_Mst_Cmplt             -- Bus to IP master transfer completion
--   Bus2IP_Mst_Error             -- Bus to IP master error response
--   Bus2IP_Mst_Rearbitrate       -- Bus to IP master re-arbitrate
--   Bus2IP_Mst_Cmd_Timeout       -- Bus to IP master command timeout
--   Bus2IP_MstRd_d               -- Bus to IP master read data bus
--   Bus2IP_MstRd_src_rdy_n       -- Bus to IP master read source ready
--   IP2Bus_MstWr_d               -- IP to Bus master write data bus
--   Bus2IP_MstWr_dst_rdy_n       -- Bus to IP master write destination ready
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    C_TM_BASE : std_logic_vector := x"11000000";
    C_IID_WIDTH                   : integer := 3;
    C_REG_SIZE                    : integer := 9;
    C_CMD_WIDTH                   : integer := 4;
    C_NUM_INTERRUPTS              : integer := 8;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_DWIDTH                   : integer              := 32;
    C_MST_AWIDTH                   : integer              := 32;
    C_MST_DWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 5
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    Soft_Reset      : in  std_logic;
    Reset_Done      : out std_logic;
    --interrupts_in   : in std_logic_vector(0 to 2**C_IID_WIDTH-1);
    interrupts_in   : in std_logic_vector(0 to C_NUM_INTERRUPTS-1);
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to 31);
    Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    IP2Bus_MstRd_Req               : out std_logic;
    IP2Bus_MstWr_Req               : out std_logic;
    IP2Bus_Mst_Addr                : out std_logic_vector(0 to C_MST_AWIDTH-1);
    IP2Bus_Mst_BE                  : out std_logic_vector(0 to C_MST_DWIDTH/8-1);
    IP2Bus_Mst_Lock                : out std_logic;
    IP2Bus_Mst_Reset               : out std_logic;
    Bus2IP_Mst_CmdAck              : in  std_logic;
    Bus2IP_Mst_Cmplt               : in  std_logic;
    Bus2IP_Mst_Error               : in  std_logic;
    Bus2IP_Mst_Rearbitrate         : in  std_logic;
    Bus2IP_Mst_Cmd_Timeout         : in  std_logic;
    Bus2IP_MstRd_d                 : in  std_logic_vector(0 to C_MST_DWIDTH-1);
    Bus2IP_MstRd_src_rdy_n         : in  std_logic;
    IP2Bus_MstWr_d                 : out std_logic_vector(0 to C_MST_DWIDTH-1);
    Bus2IP_MstWr_dst_rdy_n         : in  std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

    -- Added in by Xilinx even though XST doesn't even recognize these attributes
  --attribute SIGIS : string;
  --attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  --attribute SIGIS of Bus2IP_Reset  : signal is "RST";
  --attribute SIGIS of IP2Bus_Mst_Reset: signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

--USER signal declarations added here, as needed for user logic

--  Define the memory map for each command register, Address[13 to 14]
--  This value is the offset from the base address assigned to this module
constant OPCODE_READ : std_logic_vector(0 to 4-1) := x"0";
constant OPCODE_WRITE : std_logic_vector(0 to 4-1) := x"1";
constant OPCODE_CLEAR : std_logic_vector(0 to 4-1) := x"2";
constant OPCODE_MANUAL_RESET : std_logic_vector(0 to 4-1) := x"3";

-- ACK signal
signal IP2Bus_Ack : std_logic;

-- CE concatenation signals
signal Bus2IP_RdCE_concat : std_logic;
signal Bus2IP_WrCE_concat : std_logic;

-- Bus Output Controller signals
signal bus_data_ready : std_logic;
signal bus_ack_ready : std_logic;
signal bus_data_out   : std_logic_vector (0 to 31);

-- Reset Signals
-- FIXME: It would be nice to eliminate the default values here
signal inside_reset			: std_logic := '0';
signal inside_reset_next	: std_logic := '0';

-- Signals for each event type
signal OPWrite_Request				: std_logic;
signal OPRead_Request				: std_logic;
signal OPClear_Request			: std_logic;
signal OPManualReset_Request			: std_logic;
signal Error_Request 				: std_logic;


-- signal and type for MASTER FSM
type master_state_type is
(
  idle,					-- idle states
  wait_trans_done,		-- wait for bus transaction to complete

  reset,				-- reset states
  reset_core,
  reset_wait_4_ack,

  opwrite_begin,
  opwrite_wait_4_busy,
  opwrite_finish, 

  opread_begin,
  opread_wait_4_busy,
  opread_finish, 

  manual_reset_begin,
  manual_reset_wait,
  manual_reset_finish,


  opclear_begin,
  opclear_wait_4_busy,
  opclear_finish 
);
signal current_state, next_state : master_state_type := idle;

--Core Inputs
signal msg_chan_channelDataOut : std_logic_vector(0 to 7) := (others => '0');
signal msg_chan_exists : std_logic := '0';
signal msg_chan_full : std_logic := '0';
signal cmd : std_logic := '0';
signal opcode : std_logic_vector(0 to C_CMD_WIDTH-1) := (others => '0');
signal iid : std_logic_vector(0 to C_IID_WIDTH-1) := (others => '0');
signal tid : std_logic_vector(0 to 7) := (others => '0');
signal core_reset, reset_sig : std_logic := '0';

-- Core Outputs
signal msg_chan_channelDataIn : std_logic_vector(0 to 7);
signal msg_chan_channelRead : std_logic;
signal msg_chan_channelWrite : std_logic;
signal ack : std_logic;
signal ret_out: std_logic_vector(0 to 7);
signal tid_out : std_logic_vector(0 to 7);

-- Message channels signals

signal FSL_S_Read : std_logic;
signal FSL_S_Exists : std_logic;
signal FSL_Has_Data : std_logic;
signal FSL_Data : std_logic_vector(0 to 7);

------------------------------------------
-- Signals for user logic master model example
------------------------------------------
-- signals for master model control/status registers write/read
signal mst_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
-- signals for master model control/status registers
type BYTE_REG_TYPE is array(0 to 15) of std_logic_vector(0 to 7);
signal mst_go, IP2Bus_MstRdReq                         : std_logic;
-- signals for master model command interface state machine
type CMD_CNTL_SM_TYPE is (CMD_IDLE, CMD_RUN, CMD_WAIT_FOR_DATA, CMD_DONE);
signal mst_cmd_sm_state               : CMD_CNTL_SM_TYPE;
signal mst_cmd_sm_set_done            : std_logic;
signal mst_cmd_sm_set_error           : std_logic;
signal mst_cmd_sm_set_timeout         : std_logic;
signal mst_cmd_sm_busy                : std_logic;
signal mst_cmd_sm_clr_go              : std_logic;
signal mst_cmd_sm_rd_req              : std_logic;
signal mst_cmd_sm_wr_req              : std_logic;
signal mst_cmd_sm_reset               : std_logic;
signal mst_cmd_sm_bus_lock            : std_logic;
signal IP2Bus_Addr, mst_cmd_sm_ip2bus_addr         : std_logic_vector(0 to C_MST_AWIDTH-1);
signal mst_cmd_sm_ip2bus_be           : std_logic_vector(0 to C_MST_DWIDTH/8-1);
signal mst_fifo_valid_write_xfer      : std_logic;
signal mst_fifo_valid_read_xfer       : std_logic;

    COMPONENT complete_pic
generic(
  IID_WIDTH : integer := 3;
  REG_SIZE : integer := 9;
  CMD_WIDTH : integer := 4;
  C_NUM_INTERRUPTS  : integer := 8
);
    PORT(
         msg_chan_channelDataIn : OUT  std_logic_vector(0 to 7);
         msg_chan_channelDataOut : IN  std_logic_vector(0 to 7);
         msg_chan_exists : IN  std_logic;
         msg_chan_full : IN  std_logic;
         msg_chan_channelRead : OUT  std_logic;
         msg_chan_channelWrite : OUT  std_logic;
         go : IN  std_logic;
         ack : OUT  std_logic;
         TID_IN : IN  std_logic_vector(0 to 7);
         IID_IN : in std_logic_vector(0 to IID_WIDTH - 1);
         CMD_IN : in std_logic_vector(0 to CMD_WIDTH - 1);
         RET_OUT : OUT  std_logic_vector(0 to 7);
         TID_OUT : OUT  std_logic_vector(0 to 7);
         -- interrupts_in : in std_logic_vector(0 to 2**IID_WIDTH - 1);
         -- TODO: Fix files to handle variable number and not exactly 8!
         interrupts_in : in std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         clock_sig : IN  std_logic;
         reset_sig : IN  std_logic
        );
    END COMPONENT;

   component fsl_v20 is
     generic (
       C_EXT_RESET_HIGH : integer;
       C_ASYNC_CLKS : integer;
       C_IMPL_STYLE : integer;
       C_USE_CONTROL : integer;
       C_FSL_DWIDTH : integer;
       C_FSL_DEPTH : integer;
       C_READ_CLOCK_PERIOD : integer
     );
     port (
       FSL_Clk : in std_logic;
       SYS_Rst : in std_logic;
       FSL_Rst : out std_logic;
       FSL_M_Clk : in std_logic;
       FSL_M_Data : in std_logic_vector(0 to C_FSL_DWIDTH-1);
       FSL_M_Control : in std_logic;
       FSL_M_Write : in std_logic;
       FSL_M_Full : out std_logic;
       FSL_S_Clk : in std_logic;
       FSL_S_Data : out std_logic_vector(0 to C_FSL_DWIDTH-1);
       FSL_S_Control : out std_logic;
       FSL_S_Read : in std_logic;
       FSL_S_Exists : out std_logic;
       FSL_Full : out std_logic;
       FSL_Has_Data : out std_logic;
       FSL_Control_IRQ : out std_logic
     );
   end component;

-- ***************************
-- ChipScope Cores
-- ***************************
-- ChipScope signals
-- signal CONTROL0 : std_logic_vector(35 downto 0);
-- signal TRIG0 : std_logic_vector(15 downto 0);
-- signal TRIG1 : std_logic_vector(31 downto 0);
-- signal TRIG2 : std_logic_vector(3 downto 0);
-- 
-- component chipscope_icon_v1_03_a
--   PORT (
--     CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
-- 
-- end component;
-- 
-- component chipscope_ila_ul_v1_02_a
--   PORT (
--     CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
--     CLK : IN STD_LOGIC;
--     TRIG0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--     TRIG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--     TRIG2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
-- 
-- end component;


---------------------------------------------------
-- bit_set()
-- *******************
-- Determine if any bit in the array is set.
-- If any of the bits are set then '1' is returned,
-- otherwise '0' is returned.
---------------------------------------------------
  function bit_set( data : in std_logic_vector ) return std_logic is
  begin
    for i in data'range loop
      if( data(i) = '1' ) then
        return '1';
      end if;
    end loop;

    return '0';
  end function;
---------------------------------------------------

function getIID( addr : in std_logic_vector(0 to 31)) return std_logic_vector is
begin
	--return "00" & addr(24 to 29);
	return addr( 24 to (24+C_IID_WIDTH-1) );
end function;

function getTID( addr : in std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return addr(16 to 23);
end function;

function form_tm_addr( tid : in std_logic_vector(0 to 7)) return std_logic_vector is
    variable mask : std_logic_vector(0 to 31);
begin
   mask := x"00001" & "00" & tid & "00";
   return C_TM_BASE or mask;
end function;




--*************************************************
-- Beginning of user_logic ARCHITECTURE
--*************************************************

begin

    core_reset  <= reset_sig; -- or Bus2IP_Reset;

    -- Instantiate the Core
   internalCore: complete_pic
--    internalCore : entity plb_fsmlang_special_pic_v1_00_a.complete_pic
--    internalCore : entity complete_pic
    GENERIC MAP (
        IID_WIDTH   => C_IID_WIDTH,
        REG_SIZE    => C_REG_SIZE,
        CMD_WIDTH   => C_CMD_WIDTH, 
        C_NUM_INTERRUPTS => C_NUM_INTERRUPTS
     )
    PORT MAP (
          msg_chan_channelDataIn => msg_chan_channelDataIn,
          msg_chan_channelDataOut => msg_chan_channelDataOut,
          msg_chan_exists => msg_chan_exists,
          msg_chan_full => msg_chan_full,
          msg_chan_channelRead => msg_chan_channelRead,
          msg_chan_channelWrite => msg_chan_channelWrite,
          go => cmd,
          ack => ack,
          TID_IN => tid,
          IID_IN => iid,
          CMD_IN => opcode,
          RET_OUT => ret_out,
          TID_OUT => tid_out,
          interrupts_in => interrupts_in,
          clock_sig => Bus2IP_Clk,
          reset_sig => core_reset
        );

-- ChipScope Instantiations

-- pic_icon : chipscope_icon_v1_03_a
--   port map (
--     CONTROL0 => CONTROL0);
-- 
-- pic_ila_ul : chipscope_ila_ul_v1_02_a
--   port map (
--     CONTROL => CONTROL0,
--     CLK => Bus2IP_Clk,
--     TRIG0 => TRIG0,
--     TRIG1 => TRIG1,
--     TRIG2 => TRIG2);
-- 
-- TRIG0   <= FSL_S_Exists & FSL_S_Read & mst_go & mst_cmd_sm_rd_req &  Bus2IP_Mst_CmdAck & Bus2IP_Mst_Cmplt & Bus2IP_Mst_Cmd_Timeout & Bus2IP_Mst_Error & FSL_Data;
-- TRIG1   <= mst_cmd_sm_ip2bus_addr;
-- TRIG2   <= interrupts_in;
 


  message_channel : fsl_v20
     generic map (
       C_EXT_RESET_HIGH => 1,
       C_ASYNC_CLKS => 0,
       C_IMPL_STYLE => 1,
       C_USE_CONTROL => 0,
       C_FSL_DWIDTH => 8,
       C_FSL_DEPTH => 256, 
       C_READ_CLOCK_PERIOD => 0
     )
     port map (
       FSL_Clk => Bus2IP_Clk,
       SYS_Rst => Bus2IP_Reset,
       FSL_Rst => open,
       FSL_M_Clk => Bus2IP_Clk,
       FSL_M_Data => msg_chan_channelDataIn,
       FSL_M_Control => '0',
       FSL_M_Write => msg_chan_channelWrite,
       FSL_M_Full => msg_chan_full,
       FSL_S_Clk => Bus2IP_Clk,
       FSL_S_Data => FSL_Data,
       FSL_S_Control => open,
       FSL_S_Read => FSL_S_Read,
       FSL_S_Exists => FSL_S_Exists,
       FSL_Full => open,
       FSL_Has_Data => FSL_Has_Data,
       FSL_Control_IRQ => open
     );


  -- user logic master command interface assignments
  IP2Bus_MstRd_Req  <= mst_cmd_sm_rd_req;
  IP2Bus_MstWr_Req  <= mst_cmd_sm_wr_req;
  IP2Bus_Mst_Addr   <= mst_cmd_sm_ip2bus_addr;
  IP2Bus_Mst_BE     <= mst_cmd_sm_ip2bus_be;
  IP2Bus_Mst_Lock   <= mst_cmd_sm_bus_lock;
  IP2Bus_Mst_Reset  <= mst_cmd_sm_reset;

  --implement master command interface state machine
  mst_go <= FSL_S_Exists;   -- Start master transaction when data exists in the FSL

  MASTER_CMD_SM_PROC : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then

        -- reset condition
        mst_cmd_sm_state          <= CMD_IDLE;
        mst_cmd_sm_clr_go         <= '0';
        mst_cmd_sm_rd_req         <= '0';
        mst_cmd_sm_wr_req         <= '0';
        mst_cmd_sm_bus_lock       <= '0';
        mst_cmd_sm_reset          <= '0';
        mst_cmd_sm_ip2bus_addr    <= (others => '0');
        mst_cmd_sm_ip2bus_be      <= (others => '0');
        mst_cmd_sm_set_done       <= '0';
        mst_cmd_sm_set_error      <= '0';
        mst_cmd_sm_set_timeout    <= '0';
        mst_cmd_sm_busy           <= '0';

        FSL_S_Read                <= '0';
                
      else

        -- default condition
        mst_cmd_sm_clr_go         <= '0';
        mst_cmd_sm_rd_req         <= '0';
        mst_cmd_sm_wr_req         <= '0';
        mst_cmd_sm_bus_lock       <= '0';
        mst_cmd_sm_reset          <= '0';
        mst_cmd_sm_ip2bus_addr    <= (others => '0');
        mst_cmd_sm_ip2bus_be      <= (others => '0');
        mst_cmd_sm_set_done       <= '0';
        mst_cmd_sm_set_error      <= '0';
        mst_cmd_sm_set_timeout    <= '0';
        mst_cmd_sm_busy           <= '1';

        FSL_S_Read                <= '0';
                
        -- state transition
        case mst_cmd_sm_state is

          when CMD_IDLE =>
            if ( mst_go = '1' ) then
              mst_cmd_sm_state  <= CMD_RUN;
              mst_cmd_sm_clr_go <= '1';
            else
              mst_cmd_sm_state  <= CMD_IDLE;
              mst_cmd_sm_busy   <= '0';
            end if;

          when CMD_RUN =>
            if ( Bus2IP_Mst_CmdAck = '1' and Bus2IP_Mst_Cmplt = '0' ) then
              -- Signal a read on the FSL to pop off the element
              FSL_S_Read <= '1';
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            elsif ( Bus2IP_Mst_Cmplt = '1' ) then
              -- Signal a read on the FSL to pop off the element
              FSL_S_Read <= '1';
              mst_cmd_sm_state <= CMD_DONE;
              if ( Bus2IP_Mst_Cmd_Timeout = '1' ) then
                -- PLB address phase timeout
                mst_cmd_sm_set_error   <= '1';
                mst_cmd_sm_set_timeout <= '1';
              elsif ( Bus2IP_Mst_Error = '1' ) then
                -- PLB data transfer error
                mst_cmd_sm_set_error   <= '1';
              end if;
            else
              mst_cmd_sm_state       <= CMD_RUN;
              mst_cmd_sm_rd_req      <= '1';                -- Perform a write (rd = '1', wr = '0')
              mst_cmd_sm_wr_req      <= '0';
              mst_cmd_sm_ip2bus_addr <= form_tm_addr(FSL_Data);        -- Setup address

              mst_cmd_sm_ip2bus_be   <= (others => '1');    -- Use all byte lanes
              mst_cmd_sm_bus_lock    <= '0';                -- De-assert bus lock
            end if;

          when CMD_WAIT_FOR_DATA =>
            if ( Bus2IP_Mst_Cmplt = '1' ) then
              mst_cmd_sm_state <= CMD_DONE;

            else
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            end if;

          when CMD_DONE =>

            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_set_done <= '1';
            mst_cmd_sm_busy     <= '0';

          when others =>
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_busy     <= '0';

        end case;

      end if;
    end if;

  end process MASTER_CMD_SM_PROC;

-- Create concatenation signals
Bus2IP_RdCE_concat		<= bit_set(Bus2IP_RdCE); 
Bus2IP_WrCE_concat		<= bit_set(Bus2IP_WrCE); 

-- *************************************************************************
-- Process:	BUS_OUTPUT_CONTROLLER
-- Purpose:	Control output from IP to Bus
--		*	Can be controlled using bus_data_ready, bus_ack_ready, and bus_data_out signals.
-- *************************************************************************
BUS_OUTPUT_CONTROLLER : process( Bus2IP_Clk, bus_data_ready, bus_ack_ready ) is
begin
	if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
		if( bus_data_ready = '1' and bus_ack_ready = '1' ) then
			IP2Bus_Data	<= bus_data_out;	-- put data on bus
			IP2Bus_Ack	<= '1';				-- ACK bus
		elsif (bus_data_ready = '1' and bus_ack_ready = '0') then
			IP2Bus_Data	<= bus_data_out;	-- put data on bus
			IP2Bus_Ack	<= '0';				-- turn off ACK
		else
			IP2Bus_Data	<= (others => '0');	-- output 0's on bus
			IP2Bus_Ack	<= '0';		        -- turn off ACK
		end if;
	end if;
end process BUS_OUTPUT_CONTROLLER;

ACK_ROUTER : process (IP2Bus_Ack, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat) is
begin
    -- Turn an "ACK" into a specific ACK (read or write ACK)
    if (Bus2IP_RdCE_concat = '1') then
        IP2Bus_RdAck <= IP2Bus_Ack;
        IP2Bus_WrAck <= '0';
    else
        IP2Bus_RdAck <= '0';
        IP2Bus_WrAck <= IP2Bus_Ack;
    end if;    
end process;

-- *************************************************************************
-- Process:	BUS_CMD_PROC
-- Purpose:	Controller and decoder for incoming bus operations (reads and writes)
-- *************************************************************************
BUS_CMD_PROC : process (Bus2IP_Clk, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat, Bus2IP_Addr ) is
begin
	if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
        OPWrite_Request    <= '0';
        OPRead_Request     <= '0';
        OPClear_Request    <= '0';
        OPManualReset_Request    <= '0';
        Error_Request      <= '0';

		if( Bus2IP_WrCE_concat = '1' ) then
			Error_Request	<= '1';
		elsif( Bus2IP_RdCE_concat = '1' ) then
			case Bus2IP_Addr(12 to 15) is
				when OPCODE_WRITE	=> OPWrite_Request	<= '1';
				when OPCODE_READ	=> OPRead_Request	<= '1';
				when OPCODE_CLEAR	=> OPClear_Request 	<= '1';
				when OPCODE_MANUAL_RESET	=> OPManualReset_Request    <= '1';
				when others			=> Error_Request	<= '1';
			end case;
		end if;
	end if;
end process BUS_CMD_PROC;

-- *************************************************************************
-- Process:	MASTER_FSM_STATE_PROC
-- Purpose:	Synchronous FSM controller for the master state machine
-- *************************************************************************
MASTER_FSM_STATE_PROC: process(	
	Bus2IP_Clk,	Soft_Reset, inside_reset, inside_reset_next, next_state) is
begin
	if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
		if( Soft_Reset = '1' and inside_reset = '0' ) then
			-- Initialize all signals...
			current_state		<= reset;
			inside_reset		<= '1';
		else
			-- Assign all signals to their next state...
			current_state		<= next_state;
			inside_reset		<= inside_reset_next;
		end if;
	end if;
end process MASTER_FSM_STATE_PROC;

-- *************************************************************************
-- Process:	MASTER_FSM_LOGIC_PROC
-- Purpose:	Combinational process that contains all state machine logic and
--			state transitions for the master state machine			
-- *************************************************************************
MASTER_FSM_LOGIC_PROC: process (
	current_state, inside_reset, OPWrite_Request, OPRead_Request, OPManualReset_Request,
   OPClear_Request, Error_Request, Bus2IP_Data, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat, Soft_Reset, Bus2IP_Addr, ack ) is

-- Idle Variable, concatenation of all request signals
variable  idle_concat : std_logic_vector(0 to 4);

begin
	IP2Bus_Error		<= '0';	-- no error	
	IP2Bus_Addr			<= (others => '0');
   IP2Bus_MstRdReq     <= '0';
   IP2Bus_MstWr_d      <= (others => '0');

	Reset_Done				<= '0'; -- reset is done unless we override it later
	next_state				<= current_state;
	inside_reset_next		<= inside_reset;
	bus_data_out			<= (others => '0');
	bus_data_ready			<= '0';
	bus_ack_ready			<= '0';

    cmd <= '0';
    opcode <= (others => '0');
    iid <= (others => '0');
    tid <= (others => '0');
    reset_sig <= '0';
  
	case current_state is
		when idle =>

			-- Assign to variable for case statement
			idle_concat :=	(OPWrite_Request & OPRead_Request & OPClear_Request & OPManualReset_Request & Error_Request);

			-- Decode request
			case (idle_concat) is
	
				when "10000"	=>	next_state <= opwrite_begin;			-- OPWrite
				when "01000"	=>	next_state <= opread_begin;			    -- OPRead
				when "00100"	=>	next_state <= opclear_begin;			-- OPReadAll
				when "00010"	=>	next_state <= manual_reset_begin;		-- Manual Reset
				when "00001"	=> bus_data_out <= (others => '1');		    -- Error!!!
									bus_data_ready <= '1';
									bus_ack_ready  <= '1';          
									next_state <= wait_trans_done;
				when others	=>	next_state <= idle;							-- Others, stay in idle state
			end case;
      
		when wait_trans_done =>
			-- Goal of this state is to return to the idle state ONLY (iff) the bus transaction has COMPLETELY ended!
			bus_data_ready <= '0';  -- de-assert bus transaction signals
			bus_ack_ready  <= '0';          
			if( Bus2IP_RdCE_concat = '0' and Bus2IP_WrCE_concat = '0' ) then
				next_state <= idle;
			end if;

		----------------------------
		-- RESET: begin
		----------------------------
		when reset =>
			reset_sig	<= '1';	-- begin reset on cvCore
			Reset_Done	<= '0';	-- De-assert Reset_Done
			next_state <= reset_core;
    
		when reset_core =>
			if (ack = '1') then
				next_state	<= reset_wait_4_ack;
			else
				next_state	<= reset_core;
			end if;

		when reset_wait_4_ack =>
			Reset_Done	<= '1';	-- Assert that reset has completed

			if( Soft_Reset = '0' ) then				-- if reset is complete
				Reset_Done			<= '0';			-- de-assert that reset is complete
				inside_reset_next	<= '0';			-- de-assert to signal that process is no longer in reset
				next_state	<= idle;			    -- return to idle stage
			end if;
		----------------------------
		-- RESET: end
		----------------------------
		----------------------------
		-- MANUAL_RESET: begin
		----------------------------
        when manual_reset_begin =>
			reset_sig	<= '1';	-- begin reset on cvCore
            next_state  <= manual_reset_wait;

        when manual_reset_wait =>
            if (ack = '1') then
				next_state	<= manual_reset_finish;
			else
				next_state	<= manual_reset_wait;
            end if;

        when manual_reset_finish =>
			-- Finish transaction
			bus_data_out	<= x"ABCDABCD";
			bus_data_ready	<= '1';
			bus_ack_ready	<= '1';
			next_state		<= wait_trans_done;

		----------------------------
		-- MANUAL_RESET: end
		----------------------------
 
		----------------------------
		-- WRITE: begin
		----------------------------
		when opwrite_begin =>
			-- Setup Command
			cmd		<= '1';
			opcode 	<= OPCODE_WRITE;
			iid	 	<= getIID(Bus2IP_Addr);
			tid	 	<= getTID(Bus2IP_Addr);
			
			-- Persist with command until busy is received
			if (ack = '1') then
				next_state	<= opwrite_wait_4_busy;
			else
				-- Persist with request and remain
				next_state	<= opwrite_begin;
			end if;

		when opwrite_wait_4_busy =>	
            if (ack = '0') then
                -- Continue on when core is no longer busy
				cmd		<= '0';
				opcode 	<= (others => '0');
				iid	 	<= (others => '0');
				tid	 	<= (others => '0');
			    next_state		<= opwrite_finish;
            else
                -- Persist with request
			    cmd		<= '1';
    			opcode 	<= OPCODE_WRITE;
	    		iid	 	<= getIID(Bus2IP_Addr);
		    	tid	 	<= getTID(Bus2IP_Addr);
			    next_state		<= opwrite_wait_4_busy;
            end if;

		when opwrite_finish =>
			-- Finish transaction
			bus_data_out	<= conv_std_logic_vector(conv_integer(ret_out),32);
			bus_data_ready	<= '1';
			bus_ack_ready	<= '1';
			next_state		<= wait_trans_done;

		----------------------------
		-- READ: begin
		----------------------------
		when opread_begin =>
			-- Setup Command
			cmd		<= '1';
			opcode 	<= OPCODE_READ;
			iid	 	<= getIID(Bus2IP_Addr);
			tid	 	<= getTID(Bus2IP_Addr);
			
			-- Persist with command until busy is received
			if (ack = '1') then
				next_state	<= opread_wait_4_busy;
			else
				-- Persist with request and remain
				next_state	<= opread_begin;
			end if;

		when opread_wait_4_busy =>	
            if (ack = '0') then
                -- Continue on when core is no longer busy
				cmd		<= '0';
				opcode 	<= (others => '0');
				iid	 	<= (others => '0');
				tid	 	<= (others => '0');
			    next_state		<= opread_finish;
            else
                -- Persist with request
    			cmd		<= '1';
	    		opcode 	<= OPCODE_READ;
		    	iid	 	<= getIID(Bus2IP_Addr);
			    tid	 	<= getTID(Bus2IP_Addr);
			    next_state		<= opread_wait_4_busy;
            end if;
			
		when opread_finish =>
			-- Finish transaction
			bus_data_out	<= conv_std_logic_vector(conv_integer(ret_out(7) & tid_out),32);
			bus_data_ready	<= '1';
			bus_ack_ready	<= '1';
			next_state		<= wait_trans_done;


		----------------------------
		-- CLEAR: begin
		----------------------------
		when opclear_begin =>
			-- Setup Command
			cmd		<= '1';
			opcode 	<= OPCODE_CLEAR;
			iid	 	<= getIID(Bus2IP_Addr);
			tid	 	<= getTID(Bus2IP_Addr);
			
			-- Persist with command until busy is received
			if (ack = '1') then
				next_state	<= opclear_wait_4_busy;
			else
				-- Persist with request and remain
				next_state	<= opclear_begin;
			end if;

		when opclear_wait_4_busy =>	
            if (ack = '0') then
                -- Continue on when core is no longer busy
				cmd		<= '0';
				opcode 	<= (others => '0');
				iid	 	<= (others => '0');
				tid	 	<= (others => '0');
			    next_state		<= opclear_finish;
            else
                -- Persist with request
    			cmd		<= '1';
	    		opcode 	<= OPCODE_CLEAR;
		    	iid	 	<= getIID(Bus2IP_Addr);
			    tid	 	<= getTID(Bus2IP_Addr);
			    next_state		<= opclear_wait_4_busy;
            end if;
			
		when opclear_finish =>
			-- Finish transaction
			bus_data_out	<= (others => '0');
			bus_data_ready	<= '1';
			bus_ack_ready	<= '1';
			next_state		<= wait_trans_done;


		when others => 
			next_state <= idle;
	end case;	-- END CASE (current_state)
end process MASTER_FSM_LOGIC_PROC;

end architecture IMP;

