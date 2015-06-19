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
-- Date:              Thu May  7 14:29:05 2009 (by Create and Import Peripheral Wizard)
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

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.srl_fifo_f;

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
--   Bus2IP_CS                    -- Bus to IP chip select
--   Bus2IP_RNW                   -- Bus to IP read/not write
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
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to 31);
    Bus2IP_CS                      : in  std_logic_vector(0 to 1);
    Bus2IP_RNW                     : in  std_logic;
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

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";
  attribute SIGIS of IP2Bus_Mst_Reset: signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg_write_sel              : std_logic_vector(0 to 0);
  signal slv_reg_read_sel               : std_logic_vector(0 to 0);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

  ------------------------------------------
  -- Signals for user logic master model example
  ------------------------------------------
  -- signals for master model control/status registers write/read
  signal mst_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mst_reg_write_req              : std_logic;
  signal mst_reg_read_req               : std_logic;
  signal mst_reg_write_sel              : std_logic_vector(0 to 3);
  signal mst_reg_read_sel               : std_logic_vector(0 to 3);
  signal mst_write_ack                  : std_logic;
  signal mst_read_ack                   : std_logic;
  -- signals for master model control/status registers
  type BYTE_REG_TYPE is array(0 to 15) of std_logic_vector(0 to 7);
  signal mst_reg                        : BYTE_REG_TYPE;
  signal mst_byte_we                    : std_logic_vector(0 to 15);
  signal mst_cntl_rd_req                : std_logic;
  signal mst_cntl_wr_req                : std_logic;
  signal mst_cntl_bus_lock              : std_logic;
  signal mst_cntl_burst                 : std_logic;
  signal mst_ip2bus_addr                : std_logic_vector(0 to C_MST_AWIDTH-1);
  signal mst_xfer_length                : std_logic_vector(0 to 11);
  signal mst_ip2bus_be                  : std_logic_vector(0 to 15);
  signal mst_go                         : std_logic;
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
  signal mst_cmd_sm_ip2bus_addr         : std_logic_vector(0 to C_MST_AWIDTH-1);
  signal mst_cmd_sm_ip2bus_be           : std_logic_vector(0 to C_MST_DWIDTH/8-1);
  signal mst_fifo_valid_write_xfer      : std_logic;
  signal mst_fifo_valid_read_xfer       : std_logic;

begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(0 to 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(0 to 0);
  slv_write_ack     <= Bus2IP_WrCE(0);
  slv_read_ack      <= Bus2IP_RdCE(0);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        slv_reg0 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "1" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0 ) is
  begin

    case slv_reg_read_sel is
      when "1" => slv_ip2bus_data <= slv_reg0;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to demonstrate user logic master model functionality
  -- 
  -- Note:
  -- The example code presented here is to show you one way of stimulating
  -- the PLBv46 master interface under user control. It is provided for
  -- demonstration purposes only and allows the user to exercise the PLBv46
  -- master interface during test and evaluation of the template.
  -- This user logic master model contains a 16-byte flattened register and
  -- the user is required to initialize the value to desire and then write to
  -- the model's 'Go' port to initiate the user logic master operation.
  -- 
  --    Control Register     (C_BASEADDR + OFFSET + 0x0):
  --       bit 0    - Rd     (Read Request Control)
  --       bit 1    - Wr     (Write Request Control)
  --       bit 2    - BL     (Bus Lock Control)
  --       bit 3    - Brst   (Burst Assertion Control)
  --       bit 4-7  - Spare  (Spare Control Bits)
  --    Status Register      (C_BASEADDR + OFFSET + 0x1):
  --       bit 0    - Done   (Transfer Done Status)
  --       bit 1    - Busy   (User Logic Master is Busy)
  --       bit 2    - Error  (User Logic Master request got error response)
  --       bit 3    - Tmout  (User Logic Master request is timeout)
  --       bit 2-7  - Spare  (Spare Status Bits)
  --    Addrress Register    (C_BASEADDR + OFFSET + 0x4):
  --       bit 0-31 - Target Address (This 32-bit value is used to populate the
  --                  IP2Bus_Mst_Addr(0:31) address bus during a Read or Write
  --                  user logic master operation)
  --    Byte Enable Register (C_BASEADDR + OFFSET + 0x8):
  --       bit 0-15 - Master BE (This 16-bit value is used to populate the
  --                  IP2Bus_Mst_BE byte enable bus during a Read or Write user
  --                  logic master operation for single data beat transfer)
  --    Length Register      (C_BASEADDR + OFFSET + 0xC):
  --       bit 0-3  - Reserved
  --       bit 4-15 - Transfer Length (This 12-bit value is used to populate the
  --                  IP2Bus_Mst_Length(0:11) transfer length bus which specifies
  --                  the number of bytes (1 to 4096) to transfer during user logic
  --                  master Read or Write fixed length burst operations)
  --    Go Register          (C_BASEADDR + OFFSET + 0xF):
  --       bit 0-7  - Go Port (Write to this byte address initiates the user
  --                  logic master transfer, data key value of 0x0A must be used)
  -- 
  --    Note: OFFSET may be different depending on your address space configuration,
  --          by default it's either 0x0 or 0x100. Refer to IPIF address range array
  --          for actual value.
  -- 
  -- Here's an example procedure in your software application to initiate a 4-byte
  -- write operation (single data beat) of this master model:
  --   1. write 0x40 to the control register
  --   2. write the target address to the address register
  --   3. write valid byte lane value to the be register
  --      - note: this value must be aligned with ip2bus address
  --   4. write 0x0004 to the length register
  --   5. write 0x0a to the go register, this will start the master write operation
  -- 
  ------------------------------------------
  mst_reg_write_req <= Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4);
  mst_reg_read_req  <= Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4);
  mst_reg_write_sel <= Bus2IP_WrCE(1 to 4);
  mst_reg_read_sel  <= Bus2IP_RdCE(1 to 4);
  mst_write_ack     <= mst_reg_write_req;
  mst_read_ack      <= mst_reg_read_req;

  -- rip control bits from master model registers
  mst_cntl_rd_req   <= mst_reg(0)(0);
  mst_cntl_wr_req   <= mst_reg(0)(1);
  mst_cntl_bus_lock <= mst_reg(0)(2);
  mst_cntl_burst    <= mst_reg(0)(3);
  mst_ip2bus_addr   <= mst_reg(4) & mst_reg(5) & mst_reg(6) & mst_reg(7);
  mst_ip2bus_be     <= mst_reg(8) & mst_reg(9);
  mst_xfer_length   <= mst_reg(12)(4 to 7) & mst_reg(13);

  -- implement byte write enable for each byte slice of the master model registers
  MASTER_REG_BYTE_WR_EN : process( Bus2IP_BE, mst_reg_write_req, mst_reg_write_sel ) is
    constant BE_WIDTH : integer := C_SLV_DWIDTH/8;
  begin

    for byte_index in 0 to 15 loop
      mst_byte_we(byte_index) <= mst_reg_write_req and
                                 mst_reg_write_sel(byte_index/BE_WIDTH) and
                                 Bus2IP_BE(byte_index-(byte_index/BE_WIDTH)*BE_WIDTH);
    end loop;

  end process MASTER_REG_BYTE_WR_EN;

  -- implement master model registers
  MASTER_REG_WRITE_PROC : process( Bus2IP_Clk ) is
    constant BE_WIDTH : integer := C_SLV_DWIDTH/8;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then
        mst_reg(0 to 14) <= (others => "00000000");
      else
        -- control register (byte 0)
        if ( mst_byte_we(0) = '1' ) then
          mst_reg(0) <= Bus2IP_Data(0 to 7);
        end if;
        -- status register (byte 1)
        mst_reg(1)(1) <= mst_cmd_sm_busy;
        if ( mst_byte_we(1) = '1' ) then
          -- allows a clear of the 'Done'/'error'/'timeout'
          mst_reg(1)(0) <= Bus2IP_Data((1-(1/BE_WIDTH)*BE_WIDTH)*8);
          mst_reg(1)(2) <= Bus2IP_Data((1-(1/BE_WIDTH)*BE_WIDTH)*8+2);
          mst_reg(1)(3) <= Bus2IP_Data((1-(1/BE_WIDTH)*BE_WIDTH)*8+3);
        else
          -- 'Done'/'error'/'timeout' from master control state machine
          mst_reg(1)(0)  <= mst_cmd_sm_set_done or mst_reg(1)(0);
          mst_reg(1)(2)  <= mst_cmd_sm_set_error or mst_reg(1)(2);
          mst_reg(1)(3)  <= mst_cmd_sm_set_timeout or mst_reg(1)(3);
        end if;
        -- byte 2 and 3 are reserved
        -- address register (byte 4 to 7)
        -- be register (byte 8 to 9)
        -- length register (byte 12 to 13)
        -- byte 10, 11 and 14 are reserved
        for byte_index in 4 to 14 loop
          if ( mst_byte_we(byte_index) = '1' ) then
            mst_reg(byte_index) <= Bus2IP_Data(
                                     (byte_index-(byte_index/BE_WIDTH)*BE_WIDTH)*8 to
                                     (byte_index-(byte_index/BE_WIDTH)*BE_WIDTH)*8+7);
          end if;
        end loop;
      end if;
    end if;

  end process MASTER_REG_WRITE_PROC;

  -- implement master model write only 'go' port
  MASTER_WRITE_GO_PORT : process( Bus2IP_Clk ) is
    constant GO_DATA_KEY  : std_logic_vector(0 to 7) := X"0A";
    constant GO_BYTE_LANE : integer := 15;
    constant BE_WIDTH     : integer := C_SLV_DWIDTH/8;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' or mst_cmd_sm_clr_go = '1' ) then
        mst_go   <= '0';
      elsif ( mst_cmd_sm_busy = '0' and mst_byte_we(GO_BYTE_LANE) = '1' and
              Bus2IP_Data((GO_BYTE_LANE-(GO_BYTE_LANE/BE_WIDTH)*BE_WIDTH)*8 to
                          (GO_BYTE_LANE-(GO_BYTE_LANE/BE_WIDTH)*BE_WIDTH)*8+7) = GO_DATA_KEY ) then
        mst_go   <= '1';
      else
        null;
      end if;
    end if;

  end process MASTER_WRITE_GO_PORT;

  -- implement master model register read mux
  MASTER_REG_READ_PROC : process( mst_reg_read_sel, mst_reg ) is
    constant BE_WIDTH : integer := C_SLV_DWIDTH/8;
  begin

    case mst_reg_read_sel is
      when "1000" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= mst_reg(byte_index);
        end loop;
      when "0100" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= mst_reg(BE_WIDTH+byte_index);
        end loop;
      when "0010" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= mst_reg(BE_WIDTH*2+byte_index);
        end loop;
      when "0001" =>
        for byte_index in 0 to BE_WIDTH-1 loop
          if ( byte_index = BE_WIDTH-1 ) then
            -- go port is not readable
            mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= (others => '0');
          else
            mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= mst_reg(BE_WIDTH*3+byte_index);
          end if;
        end loop;
      when others =>
        mst_ip2bus_data <= (others => '0');
    end case;

  end process MASTER_REG_READ_PROC;

  -- user logic master command interface assignments
  IP2Bus_MstRd_Req  <= mst_cmd_sm_rd_req;
  IP2Bus_MstWr_Req  <= mst_cmd_sm_wr_req;
  IP2Bus_Mst_Addr   <= mst_cmd_sm_ip2bus_addr;
  IP2Bus_Mst_BE     <= mst_cmd_sm_ip2bus_be;
  IP2Bus_Mst_Lock   <= mst_cmd_sm_bus_lock;
  IP2Bus_Mst_Reset  <= mst_cmd_sm_reset;

  --implement master command interface state machine
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
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            elsif ( Bus2IP_Mst_Cmplt = '1' ) then
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
              mst_cmd_sm_rd_req      <= mst_cntl_rd_req;
              mst_cmd_sm_wr_req      <= mst_cntl_wr_req;
              mst_cmd_sm_ip2bus_addr <= mst_ip2bus_addr;
              mst_cmd_sm_ip2bus_be   <= mst_ip2bus_be(16-C_MST_DWIDTH/8 to 15);
              mst_cmd_sm_bus_lock    <= mst_cntl_bus_lock;
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

  -- local srl fifo for data storage
  mst_fifo_valid_write_xfer <= not(Bus2IP_MstRd_src_rdy_n);
  mst_fifo_valid_read_xfer  <= not(Bus2IP_MstWr_dst_rdy_n);

  DATA_CAPTURE_FIFO_I : entity proc_common_v3_00_a.srl_fifo_f
    generic map
    (
      C_DWIDTH   => C_MST_DWIDTH,
      C_DEPTH    => 16
    )
    port map
    (
      Clk        => Bus2IP_Clk,
      Reset      => Bus2IP_Reset,
      FIFO_Write => mst_fifo_valid_write_xfer,
      Data_In    => Bus2IP_MstRd_d,
      FIFO_Read  => mst_fifo_valid_read_xfer,
      Data_Out   => IP2Bus_MstWr_d,
      FIFO_Full  => open,
      FIFO_Empty => open,
      Addr       => open
    );

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  mst_ip2bus_data when mst_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack or mst_write_ack;
  IP2Bus_RdAck <= slv_read_ack or mst_read_ack;
  IP2Bus_Error <= '0';

end IMP;
