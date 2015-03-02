library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_AWIDTH                     -- User logic address bus width
--   C_DWIDTH                     -- User logic data bus width
--   C_NUM_CE                     -- User logic chip enable bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_BE                    -- Bus to IP byte enables for user logic
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   Bus2IP_MstError              -- Bus to IP master error
--   Bus2IP_MstLastAck            -- Bus to IP master last acknowledge
--   Bus2IP_MstRdAck              -- Bus to IP master read acknowledge
--   Bus2IP_MstWrAck              -- Bus to IP master write acknowledge
--   Bus2IP_MstRetry              -- Bus to IP master retry
--   Bus2IP_MstTimeOut            -- Bus to IP mster timeout
--   IP2Bus_Addr                  -- IP to Bus address for the master transaction
--   IP2Bus_MstBE                 -- IP to Bus byte-enables qualifiers
--   IP2Bus_MstBurst              -- IP to Bus burst qualifier
--   IP2Bus_MstBusLock            -- IP to Bus bus-lock qualifier
--   IP2Bus_MstNum                -- IP to Bus burst size indicator
--   IP2Bus_MstRdReq              -- IP to Bus master read request
--   IP2Bus_MstWrReq              -- IP to Bus master write request
--   IP2IP_Addr                   -- IP to IP local device address for the master transaction
------------------------------------------------------------------------------
entity user_logic is
  generic
  (
    C_AWIDTH                       : integer              := 32;
    C_DWIDTH                       : integer              := 64;
    C_NUM_CE                       : integer              := 8
  );
  port
  (
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(0 to C_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_DWIDTH/8-1);
    Bus2IP_Burst                   : in  std_logic;
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
    Bus2IP_RdReq                   : in  std_logic;
    Bus2IP_WrReq                   : in  std_logic;
    IP2Bus_Data                    : out std_logic_vector(0 to C_DWIDTH-1);
    IP2Bus_Retry                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    IP2Bus_ToutSup                 : out std_logic;
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    Bus2IP_MstError                : in  std_logic;
    Bus2IP_MstLastAck              : in  std_logic;
    Bus2IP_MstRdAck                : in  std_logic;
    Bus2IP_MstWrAck                : in  std_logic;
    Bus2IP_MstRetry                : in  std_logic;
    Bus2IP_MstTimeOut              : in  std_logic;
    IP2Bus_Addr                    : out std_logic_vector(0 to C_AWIDTH-1);
    IP2Bus_MstBE                   : out std_logic_vector(0 to C_DWIDTH/8-1);
    IP2Bus_MstBurst                : out std_logic;
    IP2Bus_MstBusLock              : out std_logic;
    IP2Bus_MstNum                  : out std_logic_vector(0 to 4);
    IP2Bus_MstRdReq                : out std_logic;
    IP2Bus_MstWrReq                : out std_logic;
    IP2IP_Addr                     : out std_logic_vector(0 to C_AWIDTH-1)
  );
end entity user_logic;

architecture IMP of user_logic is
  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg1                       : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg2                       : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg3                       : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg4                       : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg5                       : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg_write_select           : std_logic_vector(0 to 5);
  signal slv_reg_read_select            : std_logic_vector(0 to 5);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

  ------------------------------------------
  -- Signals for user logic master model example
  ------------------------------------------
  -- signals for write/read data
  signal mst_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
  signal mst_reg_read_request           : std_logic;
  signal mst_reg_write_select           : std_logic_vector(0 to 1);
  signal mst_reg_read_select            : std_logic_vector(0 to 1);
  signal mst_write_ack                  : std_logic;
  signal mst_read_ack                   : std_logic;
  -- signals for master control/status registers
  type BYTE_REG_TYPE is array(0 to 15) of std_logic_vector(0 to 7);
  signal mst_reg                        : BYTE_REG_TYPE;
  signal mst_byte_we                    : std_logic_vector(0 to 15);
  signal mst_cntl_rd_req                : std_logic;
  signal mst_cntl_wr_req                : std_logic;
  signal mst_cntl_bus_lock              : std_logic;
  signal mst_cntl_burst                 : std_logic;
  signal mst_ip2bus_addr                : std_logic_vector(0 to C_AWIDTH-1);
  signal mst_ip2ip_addr                 : std_logic_vector(0 to C_AWIDTH-1);
  signal mst_ip2bus_be                  : std_logic_vector(0 to C_DWIDTH/8-1);
  signal mst_go                         : std_logic;
  -- signals for master control state machine
  type MASTER_CNTL_SM_TYPE is (IDLE, SINGLE, BURST_16, LAST_BURST, CHK_BURST_DONE);
  signal mst_cntl_state                 : MASTER_CNTL_SM_TYPE;
  signal mst_sm_set_done                : std_logic;
  signal mst_sm_busy                    : std_logic;
  signal mst_sm_clr_go                  : std_logic;
  signal mst_sm_rd_req                  : std_logic;
  signal mst_sm_wr_req                  : std_logic;
  signal mst_sm_burst                   : std_logic;
  signal mst_sm_bus_lock                : std_logic;
  signal mst_sm_ip2bus_addr             : std_logic_vector(0 to C_AWIDTH-1);
  signal mst_sm_ip2ip_addr              : std_logic_vector(0 to C_AWIDTH-1);
  signal mst_sm_ip2bus_be               : std_logic_vector(0 to C_DWIDTH/8-1);
  signal mst_sm_ip2bus_mstnum           : std_logic_vector(0 to 4);
  signal mst_xfer_length                : integer;
  signal mst_xfer_count                 : integer;
  signal mst_ip_addr_count              : integer;
  signal mst_bus_addr_count             : integer;

  signal tid_reg  : std_logic_vector(0 to C_DWIDTH-1);
  signal tmr_reg  : std_logic_vector(0 to C_DWIDTH-1);
  signal sta_reg  : std_logic_vector(0 to C_DWIDTH-1);
  signal cmd_reg  : std_logic_vector(0 to C_DWIDTH-1);
  signal arg_reg  : std_logic_vector(0 to C_DWIDTH-1);
  signal res_reg  : std_logic_vector(0 to C_DWIDTH-1);

  alias tid_read  : std_logic is Bus2IP_RdCE(0);
  alias tmr_read  : std_logic is Bus2IP_RdCE(1);
  alias sta_read  : std_logic is Bus2IP_RdCE(2);
  alias cmd_read  : std_logic is Bus2IP_RdCE(3);
  alias arg_read  : std_logic is Bus2IP_RdCE(4);
  alias res_read  : std_logic is Bus2IP_RdCE(5);

  alias tid_write : std_logic is Bus2IP_WrCE(0);
  alias tmr_write : std_logic is Bus2IP_WrCE(1);
  alias sta_write : std_logic is Bus2IP_WrCE(2);
  alias cmd_write : std_logic is Bus2IP_WrCE(3);
  alias arg_write : std_logic is Bus2IP_WrCE(4);
  alias res_write : std_logic is Bus2IP_WrCE(5);
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
  -- if you have four 32 bit software accessible registers in the user logic, you
  -- are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE or   Memory Mapped
  --       Bus2IP_RdCE   Register
  --            "1000"   C_BASEADDR + 0x0
  --            "0100"   C_BASEADDR + 0x4
  --            "0010"   C_BASEADDR + 0x8
  --            "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_select <= Bus2IP_WrCE(0 to 5);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 5);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
      else
        case slv_reg_write_select is
          when "100000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "010000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "001000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000100" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000010" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000001" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5 ) is
  begin

    case slv_reg_read_select is
      when "100000" => slv_ip2bus_data <= slv_reg0;
      when "010000" => slv_ip2bus_data <= slv_reg1;
      when "001000" => slv_ip2bus_data <= slv_reg2;
      when "000100" => slv_ip2bus_data <= slv_reg3;
      when "000010" => slv_ip2bus_data <= slv_reg4;
      when "000001" => slv_ip2bus_data <= slv_reg5;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to demonstrate user logic master model functionality
  -- 
  -- Note:
  -- The example code presented here is to show you one way of stimulating
  -- the IPIF IP master interface under user control. It is provided for
  -- demonstration purposes only and allows the user to exercise the IPIF
  -- IP master interface during test and evaluation of the template.
  -- This user logic master model contains a 16-byte flattened register and
  -- the user is required to initialize the value to desire and then write to
  -- the model's 'Go' port to initiate the user logic master operation.
  -- 
  --    Control Register	(C_BASEADDR + OFFSET + 0x0):
  --       bit 0		- Rd		(Read Request Control)
  --       bit 1		- Wr		(Write Request Control)
  --       bit 2		- BL		(Bus Lock Control)
  --       bit 3		- Brst	(Burst Assertion Control)
  --       bit 4-7	- Spare	(Spare Control Bits)
  --    Status Register	(C_BASEADDR + OFFSET + 0x1):
  --       bit 0		- Done	(Transfer Done Status)
  --       bit 1		- Bsy		(User Logic Master is Busy)
  --       bit 2-7	- Spare	(Spare Status Bits)
  --    IP2IP Register		(C_BASEADDR + OFFSET + 0x4):
  --       bit 0-31	- IP2IP Address (This 32-bit value is used to populate the
  --                  IP2IP_Addr(0:31) address bus during a Read or Write user
  --                  logic master operation)
  --    IP2Bus Register	(C_BASEADDR + OFFSET + 0x8):
  --       bit 0-31	- IP2Bus Address (This 32-bit value is used to populate the
  --                  IP2Bus_Addr(0:31) address bus during a Read or Write user
  --                  logic master operation)
  --    Length Register	(C_BASEADDR + OFFSET + 0xC):
  --       bit 0-15	- Transfer Length (This 16-bit value is used to specify the
  --                  number of bytes (1 to 65,536) to transfer during user logic
  --                  master read or write operations)
  --    BE Register			(C_BASEADDR + OFFSET + 0xE):
  --       bit 0-7	- IP2Bus master BE (This 8-bit value is used to populate the
  --                  IP2Bus_MstBE byte enable bus during user logic master read or
  --                  write operations, only used in single data beat operation)
  --    Go Register			(C_BASEADDR + OFFSET + 0xF):
  --       bit 0-7	- Go Port (A write to this byte address initiates the user
  --                  logic master transfer, data key value of 0x0A must be used)
  -- 
  --    Note: OFFSET may be different depending on your address space configuration,
  --          by default it's either 0x0 or 0x100. Refer to IPIF address range array
  --          for actual value.
  -- 
  -- Here's an example procedure in your software application to initiate a 4-byte
  -- write operation (single data beat) of this master model:
  --   1. write 0x40 to the control register
  --   2. write the source data address (local) to the ip2ip register
  --   3. write the destination address (remote) to the ip2bus register
  --      - note: this address will be put on the target bus address line
  --   4. write 0x0004 to the length register
  --   5. write valid byte lane value to the be register
  --      - note: this value must be aligned with ip2bus address
  --   6. write 0x0a to the go register, this will start the write operation
  -- 
  ------------------------------------------
  mst_reg_read_request <= Bus2IP_RdCE(6) or Bus2IP_RdCE(7);
  mst_reg_write_select <= Bus2IP_WrCE(6 to 7);
  mst_reg_read_select  <= Bus2IP_RdCE(6 to 7);
  mst_write_ack        <= Bus2IP_WrCE(6) or Bus2IP_WrCE(7);
  mst_read_ack         <= Bus2IP_RdCE(6) or Bus2IP_RdCE(7);

  -- user logic master request output assignments
  IP2Bus_Addr          <= mst_sm_ip2bus_addr;
  IP2Bus_MstBE         <= mst_sm_ip2bus_be;
  IP2Bus_MstBurst      <= mst_sm_burst;
  IP2Bus_MstBusLock    <= mst_sm_bus_lock;
  IP2Bus_MstNum        <= mst_sm_ip2bus_mstnum;
  IP2Bus_MstRdReq      <= mst_sm_rd_req;
  IP2Bus_MstWrReq      <= mst_sm_wr_req;
  IP2IP_Addr           <= mst_sm_ip2ip_addr;

  -- rip control bits from master model registers
  mst_cntl_rd_req      <= mst_reg(0)(0);
  mst_cntl_wr_req      <= mst_reg(0)(1);
  mst_cntl_bus_lock    <= mst_reg(0)(2);
  mst_cntl_burst       <= mst_reg(0)(3);
  mst_ip2ip_addr       <= mst_reg(4) & mst_reg(5) & mst_reg(6) & mst_reg(7);
  mst_ip2bus_addr      <= mst_reg(8) & mst_reg(9) & mst_reg(10) & mst_reg(11);
  mst_xfer_length      <= CONV_INTEGER(mst_reg(12) & mst_reg(13));
  mst_ip2bus_be        <= mst_reg(14);

  -- implement byte write enable for each byte slice of the master model registers
  MASTER_REG_BYTE_WR_EN : process( Bus2IP_BE, Bus2IP_WrReq, mst_reg_write_select ) is
  begin

    for byte_index in 0 to 15 loop
      mst_byte_we(byte_index) <= Bus2IP_WrReq and
                                 mst_reg_write_select(byte_index/(C_DWIDTH/8)) and
                                 Bus2IP_BE(byte_index-(byte_index/(C_DWIDTH/8))*(C_DWIDTH/8));
    end loop;

  end process MASTER_REG_BYTE_WR_EN;

  -- implement master model registers
  MASTER_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then
        mst_reg(0 to 14)  <= (others => "00000000");
      else
        -- control register (byte 0)
        if ( mst_byte_we(0) = '1' ) then
          mst_reg(0)      <= Bus2IP_Data(0 to 7);
        end if;
        -- status register (byte 1)
        mst_reg(1)(1)     <= mst_sm_busy;
        if ( mst_byte_we(1) = '1' ) then
          -- allows a clear of the 'Done'
          mst_reg(1)(0)  <= Bus2IP_Data((1-(1/(C_DWIDTH/8))*(C_DWIDTH/8))*8);
        else
          -- 'Done' from master control state machine
          mst_reg(1)(0)  <= mst_sm_set_done or mst_reg(1)(0);
        end if;
        -- ip2ip address register (byte 4 to 7)
        -- ip2bus address register (byte 8 to 11)
        -- length register (byte 12 to 13)
        -- be register (byte 14)
        for byte_index in 4 to 14 loop
          if ( mst_byte_we(byte_index) = '1' ) then
            mst_reg(byte_index) <= Bus2IP_Data(
                                     (byte_index-(byte_index/(C_DWIDTH/8))*(C_DWIDTH/8))*8 to
                                     (byte_index-(byte_index/(C_DWIDTH/8))*(C_DWIDTH/8))*8+7);
          end if;
        end loop;
      end if;
    end if;

  end process MASTER_REG_WRITE_PROC;

  -- implement master model write only 'go' port
  MASTER_WRITE_GO_PORT : process( Bus2IP_Clk ) is
    constant GO_DATA_KEY  : std_logic_vector(0 to 7) := X"0A";
    constant GO_BYTE_LANE : integer := 15;
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' or mst_sm_clr_go = '1' ) then
        mst_go   <= '0';
      elsif ( mst_byte_we(GO_BYTE_LANE) = '1' and
              Bus2IP_Data((GO_BYTE_LANE-(GO_BYTE_LANE/(C_DWIDTH/8))*(C_DWIDTH/8))*8 to
                          (GO_BYTE_LANE-(GO_BYTE_LANE/(C_DWIDTH/8))*(C_DWIDTH/8))*8+7) = GO_DATA_KEY ) then
        mst_go   <= '1';
      else
        null;
      end if;
    end if;

  end process MASTER_WRITE_GO_PORT;

  -- implement master model register read mux
  MASTER_REG_READ_PROC : process( mst_reg_read_select, mst_reg ) is
  begin

    case mst_reg_read_select is
      when "10" =>
        for byte_index in 0 to C_DWIDTH/8-1 loop
          mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= mst_reg(byte_index);
        end loop;
      when "01" =>
        for byte_index in 0 to C_DWIDTH/8-1 loop
          if ( byte_index = C_DWIDTH/8-1 ) then
            -- go port is not readable
            mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= (others => '0');
          else
            mst_ip2bus_data(byte_index*8 to byte_index*8+7) <= mst_reg((C_DWIDTH/8)*1+byte_index);
          end if;
        end loop;
      when others =>
        mst_ip2bus_data <= (others => '0');
    end case;

  end process MASTER_REG_READ_PROC;

  --implement master model control state machine
  MASTER_CNTL_STATE_MACHINE : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then

        mst_cntl_state       <= IDLE;
        mst_sm_clr_go        <= '0';
        mst_sm_rd_req        <= '0';
        mst_sm_wr_req        <= '0';
        mst_sm_burst         <= '0';
        mst_sm_bus_lock      <= '0';
        mst_sm_ip2bus_addr   <= (others => '0');
        mst_sm_ip2bus_be     <= (others => '0');
        mst_sm_ip2ip_addr    <= (others => '0');
        mst_sm_ip2bus_mstnum <= "00000";
        mst_sm_set_done      <= '0';
        mst_sm_busy          <= '0';
        mst_xfer_count       <= 0;
        mst_bus_addr_count   <= 0;
        mst_ip_addr_count    <= 0;

      else

        -- default condition
        mst_sm_clr_go        <= '0';
        mst_sm_rd_req        <= '0';
        mst_sm_wr_req        <= '0';
        mst_sm_burst         <= '0';
        mst_sm_bus_lock      <= '0';
        mst_sm_ip2bus_addr   <= (others => '0');
        mst_sm_ip2bus_be     <= (others => '0');
        mst_sm_ip2ip_addr    <= (others => '0');
        mst_sm_ip2bus_mstnum <= "00000";
        mst_sm_set_done      <= '0';
        mst_sm_busy          <= '1';

        -- state transition
        case mst_cntl_state is

          when IDLE =>
            if ( mst_go = '1' and mst_xfer_length <= 8 ) then
              -- single beat transfer
              mst_cntl_state       <= SINGLE;
              mst_sm_clr_go        <= '1';
              mst_xfer_count       <= CONV_INTEGER(mst_xfer_length);
              mst_bus_addr_count   <= CONV_INTEGER(mst_ip2bus_addr);
              mst_ip_addr_count    <= CONV_INTEGER(mst_ip2ip_addr);
            elsif ( mst_go = '1' and mst_xfer_length < 128 ) then
              -- burst transfer less than 128 bytes
              mst_cntl_state       <= LAST_BURST;
              mst_sm_clr_go        <= '1';
              mst_xfer_count       <= CONV_INTEGER(mst_xfer_length);
              mst_bus_addr_count   <= CONV_INTEGER(mst_ip2bus_addr);
              mst_ip_addr_count    <= CONV_INTEGER(mst_ip2ip_addr);
            elsif ( mst_go = '1' ) then
              -- burst transfer greater than 128 bytes
              mst_cntl_state       <= BURST_16;
              mst_sm_clr_go        <= '1';
              mst_xfer_count       <= CONV_INTEGER(mst_xfer_length);
              mst_bus_addr_count   <= CONV_INTEGER(mst_ip2bus_addr);
              mst_ip_addr_count    <= CONV_INTEGER(mst_ip2ip_addr);
            else
              mst_cntl_state       <= IDLE;
              mst_sm_busy          <= '0';
            end if;

          when SINGLE =>
            if ( Bus2IP_MstLastAck = '1' ) then
              mst_cntl_state       <= IDLE;
              mst_sm_set_done      <= '1';
              mst_sm_busy          <= '0';
            else
              mst_cntl_state       <= SINGLE;
              mst_sm_rd_req        <= mst_cntl_rd_req;
              mst_sm_wr_req        <= mst_cntl_wr_req;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
              mst_sm_ip2bus_addr   <= CONV_STD_LOGIC_VECTOR(mst_bus_addr_count, C_AWIDTH);
              mst_sm_ip2bus_be     <= mst_ip2bus_be;
              mst_sm_ip2ip_addr    <= CONV_STD_LOGIC_VECTOR(mst_ip_addr_count, C_AWIDTH);
              mst_sm_ip2bus_mstnum <= "00001";
            end if;

          when BURST_16 =>
            if ( Bus2IP_MstLastAck = '1' ) then
              mst_cntl_state       <= CHK_BURST_DONE;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
              mst_xfer_count       <= mst_xfer_count-128;
              mst_bus_addr_count   <= mst_bus_addr_count+128;
              mst_ip_addr_count    <= mst_ip_addr_count+128;
            else
              mst_cntl_state       <= BURST_16;
              mst_sm_rd_req        <= mst_cntl_rd_req;
              mst_sm_wr_req        <= mst_cntl_wr_req;
              mst_sm_burst         <= mst_cntl_burst;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
              mst_sm_ip2bus_addr   <= CONV_STD_LOGIC_VECTOR(mst_bus_addr_count, C_AWIDTH);
              mst_sm_ip2bus_be     <= (others => '1');
              mst_sm_ip2ip_addr    <= CONV_STD_LOGIC_VECTOR(mst_ip_addr_count, C_AWIDTH);
              mst_sm_ip2bus_mstnum <= "10000"; -- 16 double words
            end if;

          when LAST_BURST =>
            if ( Bus2IP_MstLastAck = '1' ) then
              mst_cntl_state       <= CHK_BURST_DONE;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
              mst_xfer_count       <= mst_xfer_count-((mst_xfer_count/8)*8);
              mst_bus_addr_count   <= mst_bus_addr_count+(mst_xfer_count/8)*8;
              mst_ip_addr_count    <= mst_ip_addr_count+(mst_xfer_count/8)*8;
            else
              mst_cntl_state       <= LAST_BURST;
              mst_sm_rd_req        <= mst_cntl_rd_req;
              mst_sm_wr_req        <= mst_cntl_wr_req;
              mst_sm_burst         <= mst_cntl_burst;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
              mst_sm_ip2bus_addr   <= CONV_STD_LOGIC_VECTOR(mst_bus_addr_count, C_AWIDTH);
              mst_sm_ip2bus_be     <= (others => '1');
              mst_sm_ip2ip_addr    <= CONV_STD_LOGIC_VECTOR(mst_ip_addr_count, C_AWIDTH);
              mst_sm_ip2bus_mstnum <= CONV_STD_LOGIC_VECTOR((mst_xfer_count/8), 5);
            end if;

          when CHK_BURST_DONE =>
            if ( mst_xfer_count = 0 ) then
              -- transfer done
              mst_cntl_state       <= IDLE;
              mst_sm_set_done      <= '1';
              mst_sm_busy          <= '0';
            elsif ( mst_xfer_count <= 8 ) then
              -- need single beat transfer
              mst_cntl_state       <= SINGLE;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
            elsif ( mst_xfer_count < 128 ) then
              -- need burst transfer less than 128 bytes
              mst_cntl_state       <= LAST_BURST;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
            else
              -- need burst transfer greater than 128 bytes
              mst_cntl_state       <= BURST_16;
              mst_sm_bus_lock      <= mst_cntl_bus_lock;
            end if;

          when others =>
            mst_cntl_state    <= IDLE;
            mst_sm_busy       <= '0';

        end case;

      end if;
    end if;

  end process MASTER_CNTL_STATE_MACHINE;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data        <= mst_ip2bus_data when mst_reg_read_request = '1' else
                        slv_ip2bus_data;

  IP2Bus_WrAck       <= slv_write_ack or mst_write_ack;
  IP2Bus_RdAck       <= slv_read_ack or mst_read_ack;
  IP2Bus_Error       <= '0';
  IP2Bus_Retry       <= '0';
  IP2Bus_ToutSup     <= '0';

end IMP;
