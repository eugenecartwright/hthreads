---------------------------------------------------------------------------
--
--  Title: Hardware Thread Interface
--  Version 3: Subinterfaces for memory, function call, and control
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;

library Unisim;
use Unisim.all;

library opb_SynchManager_v1_00_c;
use opb_SynchManager_v1_00_c.common.all;
---------------------------------------------------------------------------
-- Address Space
---------------------------------------------------------------------------
-- Note: All addresses must be word addressable.  ie the last two bits of
--  each address must be 0b00.
-- BASEADDR +
--   x0000 Thread ID Register
--   x0004 Timer Register (Read Only)
--   x0008 Status Register (Read Only)
--   x000C Command Register
--   x0010 Argument Register
--   x0014 Result Register (Read Only)
--   x0018 Debug System Register (Read Only)
--   x001C Debug User Register (Read Only)
--   x0020 Master Read Register (Read Only)
--   x0024 Master Write Register (Read Only)
--   x0028 Stack Pointer (Read Only)
--   x002C Frame Pointer (Read Only)
--   x0030 Heap Pointer (Read Only)
--   x0034 8B Dynamic Memory Table (Read Only)
--   x0038 32B Dynamic Memory Table (Read Only)
--   x003C 1024B Dynamic Memory Table (Read Only)
--   x0040 Unlimited Dynamic memory Address (Read Only)
--   x0044 Unused
--   x0048 Remote Procedure Call Mutex/Condvar Numbers 
--   x004C Remote Procedure Call Argument Struct Address
--   x0050 Start of global address space
--   .....
--   x7FFC End of global address space

---------------------------------------------------------------------------
-- Port Declarations
---------------------------------------------------------------------------

-- Definition of Ports:
--  IPIC
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_CS                    -- Bus to IP chip select for user logic
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2Bus_PostedWrInh           -- IP to Bus posted write inhibit
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
--   IP2Bus_MstRdReq              -- IP to Bus master read request
--   IP2Bus_MstWrReq              -- IP to Bus master write request
--   IP2IP_Addr                   -- IP to IP local device address for the master transaction
--
--  HWTI to HWTUL interconnect

--  intrfc2thrd_value        32 bits   memory    function
--  intrfc2thrd_function     16 bits                       control
--  intrfc2thrd_goWait        1 bits                       control
--
--  HWTUL to HWTI interconnect
--  thrd2intrfc_address      32 bits   memory    
--  thrd2intrfc_value        32 bits   memory    function
--  thrd2intrfc_function     16 bits             function
--  thrd2intrfc_opcode        6 bits   memory    function

---------------------------------------------------------------------------
-- Hardware Thread Interface Entity
---------------------------------------------------------------------------

entity user_logic_hwti is
  generic (
    C_BASEADDR : std_logic_vector(0 to 31) := x"6300_0000";
    C_HIGHADDR : std_logic_vector(0 to 31) := x"6300_FFFF";
    C_OPB_AWIDTH : integer := 32;
    C_OPB_DWIDTH : integer := 32;
    C_FAMILY : string := "virtex2p";

    C_NUM_THREADS : integer := 256;
    C_NUM_MUTEXES : integer := 64;
    C_THREAD_MANAGER_BADDR : std_logic_vector := x"6000_0000";
    C_MUTEX_MANAGER_BADDR : std_logic_vector := x"7500_0000";
    C_CONVAR_MANAGER_BADDR : std_logic_vector := x"7600_0000"
  );
  port (

    --CONTROL : in STD_LOGIC_VECTOR(35 DOWNTO 0);
    OPBtimer  : out std_logic_vector(0 to 31);

    Bus2IP_Addr : in  std_logic_vector(0 to 31);
    Bus2IP_Clk : in  std_logic;
    Bus2IP_CS : in  std_logic;
    Bus2IP_Data : in  std_logic_vector(0 to 31);
    Bus2IP_RdCE : in  std_logic_vector(0 to 3);
    Bus2IP_Reset : in  std_logic;
    Bus2IP_WrCE : in  std_logic_vector(0 to 3);
    Bus2IP_RdReq : in  std_logic;
    Bus2IP_WrReq : in  std_logic;
	 
    IP2Bus_Ack : out  std_logic;
    IP2Bus_Data : out  std_logic_vector(0 to 31);
    IP2Bus_Error : out  std_logic;
    IP2Bus_PostedWrInh : out  std_logic;
    IP2Bus_Retry : out  std_logic;
    IP2Bus_ToutSup : out  std_logic;
	 
    Bus2IP_MstError : in  std_logic;
    Bus2IP_MstLastAck : in  std_logic;
    Bus2IP_MstRdAck : in  std_logic;
    Bus2IP_MstWrAck : in  std_logic;
    Bus2IP_MstRetry : in  std_logic;
    Bus2IP_MstTimeOut : in  std_logic;
	 
    IP2Bus_MstBE : out std_logic_vector(0 to 3);
    IP2Bus_Addr : out std_logic_vector(0 to 31);
    IP2Bus_MstBurst : out std_logic;
    IP2Bus_MstBusLock : out std_logic;
    IP2Bus_MstRdReq : out std_logic;
    IP2Bus_MstWrReq : out std_logic;
    IP2IP_Addr : out std_logic_vector(0 to 31);

    intrfc2thrd : out std_logic_vector(0 to 63);
    thrd2intrfc : in std_logic_vector( 0 to 95);
    rd          : out std_logic;
    wr          : out std_logic;
    exist       : in  std_logic;
    full        : in  std_logic	 

    
    
  );
end entity user_logic_hwti;

---------------------------------------------------------------------------
-- Architecture Section
---------------------------------------------------------------------------

architecture IMP of user_logic_hwti is


    alias intrfc2thrd_value    :  std_logic_vector(0 to 31) is intrfc2thrd(0 to 31);
    alias intrfc2thrd_function :  std_logic_vector(0 to 15) is intrfc2thrd(32 to 47);
    alias intrfc2thrd_goWait   :  std_logic is intrfc2thrd(48);

    alias thrd2intrfc_address  :  std_logic_vector(0 to 31)  is thrd2intrfc( 32 to 63);
    alias thrd2intrfc_value    :  std_logic_vector(0 to 31)  is thrd2intrfc( 0 to 31);
    alias thrd2intrfc_function :  std_logic_vector(0 to 15)  is thrd2intrfc( 64 to 79);
    alias thrd2intrfc_opcode   :  std_logic_vector(0 to 5)   is thrd2intrfc( 80 to 85) ;






---------------------------------------------------------------------------
-- Bram declaration
---------------------------------------------------------------------------
  component bram_imp_dual is
    port (
      clk: in std_logic;
      addra: in std_logic_vector(0 to 12);
      dia: in std_logic_vector(0 to 31);
      doa: out std_logic_vector(0 to 31);
      ena: in std_logic;
      wea: in std_logic;
      addrb: in std_logic_vector(0 to 12);
      dib: in std_logic_vector(0 to 31);
      dob: out std_logic_vector(0 to 31);
      enb: in std_logic;
      web: in std_logic
    );
  end component;

---------------------------------------------------------------------------
-- Signal Declarations
---------------------------------------------------------------------------
  -- Constants for the number of bits needed to represent certain data
  constant MUTEX_BITS     : integer   := log2(C_NUM_MUTEXES);
  constant THREAD_BITS    : integer   := log2(C_NUM_THREADS);
  constant COUNT_BITS     : integer   := 8;

  -- Constants for conditional variable commands
  constant CONDVAR_CMD_SIGNAL : std_logic_vector(0 to 3) := "0010";
  constant CONDVAR_CMD_WAIT : std_logic_vector(0 to 3) := "0100";
  constant CONDVAR_CMD_BCAST : std_logic_vector(0 to 3) := "0110";
  constant CONDVAR_FAILED : std_logic_vector(0 to 3) := x"E";
  constant CONDVAR_SUCCESS : std_logic_vector(0 to 3) := x"A";

  -- Address Mapped Register Offsets
  -- Please see the address map at the top of this file for further details
  constant REG_THREAD_ID : std_logic_vector(0 to 13) := b"0000_0000_0000_00";
  constant REG_TIMER : std_logic_vector(0 to 13) := b"0000_0000_0000_01";
  constant REG_STATUS : std_logic_vector(0 to 13) := b"0000_0000_0000_10";
  constant REG_COMMAND : std_logic_vector(0 to 13) := b"0000_0000_0000_11";
  constant REG_ARGUMENT : std_logic_vector(0 to 13) := b"0000_0000_0001_00";
  constant REG_RESULT : std_logic_vector(0 to 13) := b"0000_0000_0001_01";
  constant REG_DEBUG_SYSTEM : std_logic_vector(0 to 13) := b"0000_0000_0001_10";
  constant REG_DEBUG_USER : std_logic_vector(0 to 13) := b"0000_0000_0001_11";
  constant REG_MASTER_READ : std_logic_vector(0 to 13) := b"0000_0000_0010_00";
  constant REG_MASTER_WRITE : std_logic_vector(0 to 13) := b"0000_0000_0010_01";
  constant REG_STACKPTR : std_logic_vector(0 to 13) := b"0000_0000_0010_10";
  constant REG_FRAMEPTR : std_logic_vector(0 to 13) := b"0000_0000_0010_11";
  constant REG_HEAPPTR : std_logic_vector(0 to 13) := b"0000_0000_0011_00";
  constant REG_8B_DYNAMIC_TABLE : std_logic_vector(0 to 13) := b"0000_0000_0011_01";
  constant REG_32B_DYNAMIC_TABLE : std_logic_vector(0 to 13) := b"0000_0000_0011_10";
  constant REG_1024B_DYNAMIC_TABLE : std_logic_vector(0 to 13) := b"0000_0000_0011_11";
  constant REG_UNLIMITED_DYNAMIC_TABLE : std_logic_vector(0 to 13) := b"0000_0000_0100_00";
  constant REG_RPC_MUTEXCONVAR : std_logic_vector(0 to 13) := b"0000_0000_0100_10";
  constant REG_RPC_T_ADDRESS : std_logic_vector(0 to 13) := b"0000_0000_0100_11";

  -- I expect these to be derived from generics someday, based on how many instantiated BRAMS
  -- The readable address space is slighly larger, this is due to the dynamic memory tables.
  -- The BRAM is readable from the Dynamic Table entries up, BRAM is writable from the RPC
  -- address and up.  Although, it should only be the system kernel writing to the RPC regs.
  constant GLOBAL_BASE_ADDR : std_logic_vector(0 to 13) := b"0000_0000_0101_00";
  constant GLOBAL_BASE_ADDRREADABLE : std_logic_vector(0 to 13) := b"0000_0000_0011_01";
  constant GLOBAL_HIGH_ADDR : std_logic_vector(0 to 13) := b"0111_1111_1111_11";

  -- Lower half of address range for dynamic memory allocation
  constant BASE_ADDR_MALLOC_8B : std_logic_vector(0 to 15) := x"7FF8";
  constant BASE_ADDR_MALLOC_32B : std_logic_vector(0 to 15) := x"7EE0";
  constant BASE_ADDR_MALLOC_1024B : std_logic_vector(0 to 15) := x"7A00";
  -- Note the base address of the unlimit malloc is the initial heap pointer

  -- Alias to determine which register is being accessed by the system bus
  alias reg_address : std_logic_vector(0 to 13) is Bus2IP_Addr(16 to 29);
  -- Aliases for bus reads and writes responces 
  -- Set to the IP2IP_Addr duing a bus master read
  constant master_read_respond_address : std_logic_vector(0 to 31) := C_BASEADDR(0 to 15) & REG_MASTER_READ & "00";
  -- Set to the IP2IP_Addr duing a bus master write
  constant master_write_respond_address : std_logic_vector(0 to 31) := C_BASEADDR(0 to 15) & REG_MASTER_WRITE & "00";

  -- Function Constants
  -- Unsupported functions are commented out
  -- TODO Is there a way to put this into a seperate file that can be shared with the HWTUL?
  -- Special function codes for user
  constant FUNCTION_RESET                      : std_logic_vector(0 to 15) := x"0000";
  constant FUNCTION_WAIT                       : std_logic_vector(0 to 15) := x"0001";
  constant FUNCTION_USER_SELECT                : std_logic_vector(0 to 15) := x"0002";
  constant FUNCTION_START                      : std_logic_vector(0 to 15) := x"0003";
  -- Range 0003 to 7FFF reserved for user logic's state machine
  -- Range 8000 to 9FFF reserved for system calls
  constant FUNCTION_HTHREAD_ATTR_INIT          : std_logic_vector(0 to 15) := x"8000";
  constant FUNCTION_HTHREAD_ATTR_DESTROY       : std_logic_vector(0 to 15) := x"8001";
  constant FUNCTION_HTHREAD_CREATE             : std_logic_vector(0 to 15) := x"8010";
  constant FUNCTION_HTHREAD_JOIN               : std_logic_vector(0 to 15) := x"8011";
  constant FUNCTION_HTHREAD_SELF               : std_logic_vector(0 to 15) := x"8012";
  constant FUNCTION_HTHREAD_YIELD              : std_logic_vector(0 to 15) := x"8013";
  constant FUNCTION_HTHREAD_EQUAL              : std_logic_vector(0 to 15) := x"8014";
  constant FUNCTION_HTHREAD_EXIT               : std_logic_vector(0 to 15) := x"8015";
  constant FUNCTION_HTHREAD_EXIT_ERROR         : std_logic_vector(0 to 15) := x"8016";
  constant FUNCTION_HTHREAD_MUTEXATTR_INIT     : std_logic_vector(0 to 15) := x"8020";
  constant FUNCTION_HTHREAD_MUTEXATTR_DESTROY  : std_logic_vector(0 to 15) := x"8021";
  constant FUNCTION_HTHREAD_MUTEXATTR_SETNUM   : std_logic_vector(0 to 15) := x"8022";
  constant FUNCTION_HTHREAD_MUTEXATTR_GETNUM   : std_logic_vector(0 to 15) := x"8023";
  constant FUNCTION_HTHREAD_MUTEX_INIT         : std_logic_vector(0 to 15) := x"8030";
  constant FUNCTION_HTHREAD_MUTEX_DESTROY      : std_logic_vector(0 to 15) := x"8031";
  constant FUNCTION_HTHREAD_MUTEX_LOCK         : std_logic_vector(0 to 15) := x"8032";
  constant FUNCTION_HTHREAD_MUTEX_UNLOCK       : std_logic_vector(0 to 15) := x"8033";
  constant FUNCTION_HTHREAD_MUTEX_TRYLOCK      : std_logic_vector(0 to 15) := x"8034";
  constant FUNCTION_HTHREAD_CONDATTR_INIT      : std_logic_vector(0 to 15) := x"8040";
  constant FUNCTION_HTHREAD_CONDATTR_DESTROY   : std_logic_vector(0 to 15) := x"8041";
  constant FUNCTION_HTHREAD_CONDATTR_SETNUM    : std_logic_vector(0 to 15) := x"8042";
  constant FUNCTION_HTHREAD_CONDATTR_GETNUM    : std_logic_vector(0 to 15) := x"8043";
  constant FUNCTION_HTHREAD_COND_INIT          : std_logic_vector(0 to 15) := x"8050";
  constant FUNCTION_HTHREAD_COND_DESTROY       : std_logic_vector(0 to 15) := x"8051";
  constant FUNCTION_HTHREAD_COND_SIGNAL        : std_logic_vector(0 to 15) := x"8052";
  constant FUNCTION_HTHREAD_COND_BROADCAST     : std_logic_vector(0 to 15) := x"8053";
  constant FUNCTION_HTHREAD_COND_WAIT          : std_logic_vector(0 to 15) := x"8054";
  -- Ranged A000 to FFFF reserved for supported library calls
  -- Ranged A000 to A0FF reserved for standard library stdlib.h calls
  constant FUNCTION_MALLOC                     : std_logic_vector(0 to 15) := x"A000";
  constant FUNCTION_CALLOC                     : std_logic_vector(0 to 15) := x"A001";
  constant FUNCTION_FREE                       : std_logic_vector(0 to 15) := x"A002";
  -- Ranged A100 to A1FF reserved for string.h library calls
  constant FUNCTION_MEMCPY                     : std_logic_vector(0 to 15) := x"A100";

  -- Opcode Constants
  constant OPCODE_NOOP                         : std_logic_vector(0 to 5) := "000000";
  -- Memory sub-interface specific opcodes
  constant OPCODE_LOAD                         : std_logic_vector(0 to 5) := "000001";
  constant OPCODE_STORE                        : std_logic_vector(0 to 5) := "000010";
  constant OPCODE_DECLARE                      : std_logic_vector(0 to 5) := "000011";
  constant OPCODE_READ                         : std_logic_vector(0 to 5) := "000100";
  constant OPCODE_WRITE                        : std_logic_vector(0 to 5) := "000101";
  constant OPCODE_ADDRESSOF                    : std_logic_vector(0 to 5) := "000110";
  -- Function sub-interface specific opcodes
  constant OPCODE_PUSH                         : std_logic_vector(0 to 5) := "010000";
  constant OPCODE_POP                          : std_logic_vector(0 to 5) := "010001";
  constant OPCODE_CALL                         : std_logic_vector(0 to 5) := "010010";
  constant OPCODE_RETURN                       : std_logic_vector(0 to 5) := "010011";

  -- system_status Constants
  constant SYSTEM_STATUS_NOT_USED              : std_logic_vector(0 to 7) := x"00";
  constant SYSTEM_STATUS_USED                  : std_logic_vector(0 to 7) := x"01";
  constant SYSTEM_STATUS_RUNNING               : std_logic_vector(0 to 7) := x"02";
  constant SYSTEM_STATUS_BLOCKED               : std_logic_vector(0 to 7) := x"04";
  constant SYSTEM_STATUS_EXITED                : std_logic_vector(0 to 7) := x"08";
  constant SYSTEM_STATUS_EXITED_ERROR          : std_logic_vector(0 to 7) := x"20";
  constant SYSTEM_STATUS_EXITED_OVERFLOW       : std_logic_vector(0 to 7) := x"40";

  -- system_command Constants
  constant SYSTEM_COMMAND_INIT                 : std_logic_vector(0 to 3) := x"0";
  constant SYSTEM_COMMAND_RUN                  : std_logic_vector(0 to 3) := x"1";
  constant SYSTEM_COMMAND_RESET                : std_logic_vector(0 to 3) := x"2";
  constant SYSTEM_COMMAND_COLDBOOT             : std_logic_vector(0 to 3) := x"4";
  constant SYSTEM_COMMAND_NOTUSED              : std_logic_vector(0 to 3) := x"8";

  -- misc constants
  constant Z32 : std_logic_vector(0 to 31) := (others => '0');
  constant TIMEOUT_CYCLES : natural := 4; -- clock cycles to wait before suppressing timeouts

  -- Thread manager commandes
  -- TODO: Thread manager commands should be replaced by an external file
  constant THREAD_MANAGER_EXIT_THREAD : std_logic_vector(0 to 5) := "000111";
  constant THREAD_MANAGER_READ_THREAD : std_logic_vector(0 to 5) := "000011";

  -- bram interface signals
  signal wea : std_logic := '0';
  signal ena : std_logic := '0';
  signal addra : std_logic_vector(0 to 12) := (others => '0');
  signal dia : std_logic_vector(0 to 31) := (others => '0');
  signal doa : std_logic_vector(0 to 31);
  signal web : std_logic := '0';
  signal enb : std_logic := '0';
  signal addrb : std_logic_vector(0 to 12) := (others => '0');
  signal dib : std_logic_vector(0 to 31) := (others => '0');
  signal dob : std_logic_vector(0 to 31);

---------------------------------------------------------------------------
-- State Machine States
---------------------------------------------------------------------------

  type hwti_system_state is (
    START,
    IDLE,
    COMMAND_RESET_INIT,
    COMMAND_RESET_END_BUS_TRANSACTION_WAIT,
    COMMAND_RUN_INIT,
    GLOBAL_READ_WAIT,
    GLOBAL_READ_RESPOND,
    END_BUS_TRANSACTION,
    END_BUS_TRANSACTION_WAIT);

  type hwti_user_state is (
    START,
    NOT_USED,
    RESET_MALLOC_TABLE,
    NOT_USED_WAIT,
    USED,
    USED_WAIT,
    RUNNING,
    SERVICE_NEW_REQUST,
    USER_FUNCTION_CALL,
    USER_FUNCTION_CALL_2,
    USER_FUNCTION_RETURN,
    USER_FUNCTION_RETURN_2,
    USER_FUNCTION_RETURN_3,
    LIB_FUNCTION_MEMCPY,
    LIB_FUNCTION_MEMCPY_2,
    LIB_FUNCTION_MEMCPY_3,
    LIB_FUNCTION_MEMCPY_4,
    LIB_FUNCTION_MEMCPY_5,
    LIB_FUNCTION_MEMCPY_6,
    LIB_FUNCTION_FREE,
    LIB_FUNCTION_FREE_1,
    LIB_FUNCTION_FREE_2,
    LIB_FUNCTION_FREE_3,
    LIB_FUNCTION_CALLOC,
    LIB_FUNCTION_CALLOC_2,
    LIB_FUNCTION_CALLOC_3,
    LIB_FUNCTION_CALLOC_4,
    LIB_FUNCTION_CALLOC_5,
    LIB_FUNCTION_MALLOC,
    LIB_FUNCTION_MALLOC_8a,
    LIB_FUNCTION_MALLOC_8b,
    LIB_FUNCTION_MALLOC_8c,
    LIB_FUNCTION_MALLOC_32a,
    LIB_FUNCTION_MALLOC_32b,
    LIB_FUNCTION_MALLOC_32c,
    LIB_FUNCTION_MALLOC_1024a,
    LIB_FUNCTION_MALLOC_1024b,
    LIB_FUNCTION_MALLOC_1024c,
    LIB_FUNCTION_MALLOC_UNLIMITa,
    LIB_FUNCTION_MALLOC_UNLIMITb,
    LIB_FUNCTION_MALLOC_UNLIMITc,
    OVERFLOW,
    HTHREAD_RPC,
    HTHREAD_RPC_2,
    HTHREAD_RPC_3,
    HTHREAD_RPC_3a,
    HTHREAD_RPC_4,
    HTHREAD_RPC_5,
    HTHREAD_RPC_6,
    HTHREAD_RPC_7,
    HTHREAD_RPC_7a,
    HTHREAD_RPC_8,
    HTHREAD_RPC_8a,
    HTHREAD_RPC_9,
    HTHREAD_RPC_10,
    HTHREAD_RPC_11,
    HTHREAD_RPC_12,
    HTHREAD_RPC_13,
    HTHREAD_RPC_14,
    HTHREAD_RPC_15,
    HTHREAD_RPC_15a,
    HTHREAD_RPC_16,
    HTHREAD_RPC_17,
    HTHREAD_RPC_17a,
    HTHREAD_RPC_18,
    HTHREAD_RPC_19,
    HTHREAD_RPC_19a,
    HTHREAD_RPC_20,
    HTHREAD_RPC_20a,
    HTHREAD_RPC_21,
    HTHREAD_RPC_22,
    HTHREAD_RPC_23,
    HTHREAD_RPC_24,
    HTHREAD_ATTR_INIT,
    HTHREAD_ATTR_INIT_2,
    HTHREAD_ATTR_INIT_3,
    HTHREAD_ATTR_INIT_4,
    HTHREAD_ATTR_INIT_5,
    HTHREAD_ATTR_INIT_6,
    HTHREAD_ATTR_INIT_7,
    HTHREAD_EQUAL,
    HTHREAD_EQUAL_2,
    HTHREAD_MUTEX_INIT,
    HTHREAD_MUTEX_INIT_2,
    HTHREAD_MUTEX_INIT_3,
    HTHREAD_MUTEX_INIT_4,
    HTHREAD_MUTEX_INIT_5,
    HTHREAD_MUTEX_INIT_6,
    HTHREAD_MUTEX_INIT_7,
    HTHREAD_MUTEXATTR_INIT,
    HTHREAD_MUTEXATTR_INIT_2,
    HTHREAD_MUTEXATTR_INIT_3,
    HTHREAD_MUTEXATTR_SETNUM,
    HTHREAD_MUTEXATTR_SETNUM_2,
    HTHREAD_MUTEXATTR_SETNUM_3,
    HTHREAD_MUTEXATTR_GETNUM,
    HTHREAD_MUTEXATTR_GETNUM_2,
    HTHREAD_MUTEXATTR_GETNUM_3,
    HTHREAD_MUTEXATTR_GETNUM_4,
    HTHREAD_MUTEX_UNLOCK,
    HTHREAD_MUTEX_UNLOCK_2,
    HTHREAD_MUTEX_UNLOCK_3,
    HTHREAD_MUTEX_TRYLOCK,
    HTHREAD_MUTEX_TRYLOCK_2,
    HTHREAD_MUTEX_TRYLOCK_3,
    HTHREAD_MUTEX_LOCK,
    HTHREAD_MUTEX_LOCK_2,
    HTHREAD_MUTEX_LOCK_3,
    HTHREAD_MUTEX_LOCK_4,
    HTHREAD_MUTEX_LOCK_5,
    HTHREAD_MUTEX_LOCK_6,
    HTHREAD_CONDATTR_INIT,
    HTHREAD_CONDATTR_INIT_2,
    HTHREAD_COND_WAIT,
    HTHREAD_COND_WAIT_2,
    HTHREAD_COND_WAIT_3,
    HTHREAD_COND_WAIT_4,
    HTHREAD_COND_WAIT_5,
    HTHREAD_COND_WAIT_6,
    HTHREAD_COND_WAIT_7,
    HTHREAD_COND_WAIT_7a,
    HTHREAD_COND_WAIT_8,
    HTHREAD_COND_INIT,
    HTHREAD_COND_INIT_2,
    HTHREAD_COND_INIT_3,
    HTHREAD_COND_INIT_4,
    HTHREAD_COND_INIT_5,
    HTHREAD_COND_INIT_6,
    HTHREAD_COND_SIGNAL,
    HTHREAD_COND_SIGNAL_2,
    HTHREAD_COND_SIGNAL_3,
    HTHREAD_COND_BCAST,
    HTHREAD_COND_BCAST_2,
    HTHREAD_COND_BCAST_3,
    HTHREAD_EXIT,
    HTHREAD_EXIT_2,
    HTHREAD_EXIT_3,
    WAIT_ONE_CYCLE,
    POP_READ_PARAM_COUNT,
    POP_READ_PARAM,
    LOCAL_LOAD_RESPOND,
    LOCAL_PARTIAL_LOAD,
    LOCAL_PARTIAL_LOAD_1,
    GLOBAL_LOAD_RETURN,
    MASTER_LOAD_INIT,
    MASTER_LOAD_WAIT_FOR_ACK,
    MASTER_STORE_INIT,
    MASTER_STORE_WAIT_FOR_ACK);
  
  type system_request_type is (
    NOOP,
    CHANGE_STATUS_TO_USED,
    CHANGE_STATUS_TO_RUN,
    CHANGE_STATUS_TO_EXIT,
    CHANGE_STATUS_TO_EXIT_ERROR,
    CHANGE_STATUS_TO_EXIT_OVERFLOW,
    CHANGE_STATUS_TO_BLOCK);
    
  signal system_state, system_state_next: hwti_system_state := START;
  signal user_state, user_state_next : hwti_user_state := START;

  -- Registers for the System Level API
  signal system_thread_id, system_thread_id_next : std_logic_vector(0 to 7);
  signal system_command, system_command_next : std_logic_vector(0 to 3);
  signal system_status, system_status_next : std_logic_vector(0 to 7);
  signal system_argument, system_argument_next : std_logic_vector(0 to 31);
  signal system_result, system_result_next : std_logic_vector(0 to 31);

  -- Registers for the User Logic Level API
  signal fromUser_address : std_logic_vector(0 to 31);
  signal fromUser_value : std_logic_vector(0 to 31);
  signal fromUser_function : std_logic_vector(0 to 15);
  signal fromUser_opcode : std_logic_vector(0 to 5);
  signal fromUserReg_address, fromUserReg_address_next : std_logic_vector(0 to 31);
  signal fromUserReg_value, fromUserReg_value_next : std_logic_vector(0 to 31);
  signal fromUserReg_function, fromUserReg_function_next : std_logic_vector(0 to 15);
  signal fromUserReg_opcode, fromUserReg_opcode_next : std_logic_vector(0 to 5);
  signal toUser_value, toUser_value_next : std_logic_vector(0 to 31);


  -- Local memory pointers
  signal framePtr, framePtr_next : std_logic_vector(0 to 15);
  signal stackPtr, stackPtr_next : std_logic_vector(0 to 15);
  signal heapPtr, heapPtr_next : std_logic_vector(0 to 15);
  signal paramCount, paramCount_next : std_logic_vector(0 to 7);

  -- Temporary registers
  signal reg1, reg1_next : std_logic_vector(0 to 31);
  signal reg2, reg2_next : std_logic_vector(0 to 31);
  signal reg3, reg3_next : std_logic_vector(0 to 31);
  signal reg4, reg4_next : std_logic_vector(0 to 31);

  -- Signals to help communicate with the system bus
  signal data_address, data_address_next: std_logic_vector(0 to 31);
  signal data_value, data_value_next: std_logic_vector(0 to 31);

  -- Miscelaneous signals
  signal cycle_count : std_logic_vector(0 to 7);
  signal timer : std_logic_vector(0 to 31);
  signal read_ce, write_ce : std_logic;
  signal local_memory_access : std_logic;
  signal stackHeapOverflow : std_logic;
  signal system_request, system_request_next : system_request_type;
  signal user_return_state, user_return_state_next : hwti_user_state;
  signal bus_data_out, bus_data_out_next : std_logic_vector(0 to 31);

  signal debug_system, debug_system_next : std_logic_vector(0 to 31);
  signal debug_user, debug_user_next : std_logic_vector(0 to 31);

------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------
------------------------------------------------------------------------
-- thread_manager_exit_thread
-- calculates the address to read to perform a exit_thread call to TM
-- TODO: move this to a common.vhd file in TM, and include it as a library
------------------------------------------------------------------------
  function thread_manager_exit_thread_address( tm_base_address : in std_logic_vector;
    data_width  : in natural;
    thread_bits : in natural;
    thread_id : in std_logic_vector ) return std_logic_vector is
    variable address : std_logic_vector(0 to data_width-1);
  begin
    address := tm_base_address;
    address( data_width-thread_bits-2 to data_width-3 ) := thread_id;
    address( data_width-thread_bits-8 to data_width-thread_bits-3 ) := THREAD_MANAGER_EXIT_THREAD;
    return address;
  end function;

------------------------------------------------------------------------
-- bit_set()
-- Determine if any bit in the array is set, if so, return 1
------------------------------------------------------------------------
  function bit_set( data : in std_logic_vector ) return std_logic is
  begin
    for i in data'range loop
      if ( data(i) = '1' ) then
        return '1';
      end if;
    end loop;
    return '0';
  end function;

---------------------------------------------------------------------------
-- is_local_memory()
-- Determine if the passed in address lines is a reference to local memory
---------------------------------------------------------------------------
  function is_local_memory( addr_lines : in std_logic_vector(0 to 31) ) return std_logic is
  begin
    if (addr_lines(0 to 15) = C_BASEADDR(0 to 15)
      and addr_lines(16 to 29) >= GLOBAL_BASE_ADDR 
      and addr_lines(16 to 29) <= GLOBAL_HIGH_ADDR) then
      return '1';
    end if;
    return '0';
  end function;
---------------------------------------------------------------------------
-- Begin architecture
---------------------------------------------------------------------------

begin -- architecture implementation


OPBtimer <= timer;
rd     <= exist;




  --bram instanciation
  bram : bram_imp_dual port map(Bus2IP_Clk,addra,dia,doa,ena,wea,addrb,dib,dob,enb,web);
  read_ce <= bit_set(Bus2IP_RdCE);
  write_ce <= bit_set(Bus2IP_WrCE);

  -- The next two processes work in conjunction with each other.
  -- The objective is to raise the time out suppression line, if a bus transaction
  -- will take longer than 8 clock cycles.
  -- The CYCLE_PROC counts the number of cycles a bus transaction takes.
  -- The CYCLE_CONTROL sets the timeout supporession high if going to exceed the 8 cycle count.
  CYCLE_PROC : process ( Bus2IP_Clk, Bus2IP_CS ) is 
  begin
    if ( Bus2IP_Clk'event and  Bus2IP_Clk='1' ) then
      if ( Bus2IP_CS = '0' ) then
        cycle_count <= (others => '0');
      else
        cycle_count <= cycle_count + 1;
      end if;
    end if;
  end process CYCLE_PROC;

  CYCLE_CONTROL : process( cycle_count ) is
  begin
    IP2Bus_MstBE <= (others=> '1');
    IP2Bus_Retry <= '0'; -- no retry
    IP2Bus_Error <= '0'; -- no error
    IP2Bus_PostedWrInh <= '0'; -- inhibit posted write 

    if cycle_count > TIMEOUT_CYCLES then
      IP2Bus_ToutSup <= '1'; -- Suppress timeouts on the bus
    else
      IP2Bus_ToutSup <= '0'; -- Release the timeout suppress line
    end if;
  end process CYCLE_CONTROL;
  
---------------------------------------------------------------------------
-- Register Assignments
---------------------------------------------------------------------------
  HWTI_STATE_PROCESS : process (Bus2IP_Clk) is
  begin
    if (Bus2IP_Clk'event and (Bus2IP_Clk = '1')) then
      system_thread_id <= system_thread_id_next;
      system_command <= system_command_next;
      system_status <= system_status_next;
      system_argument <= system_argument_next;
      system_result <= system_result_next;

      if (exist= '1') then 
         fromUser_address <= thrd2intrfc_address;
         fromUser_value <= thrd2intrfc_value;
         fromUser_function <= thrd2intrfc_function;
         fromUser_opcode <= thrd2intrfc_opcode;
         local_memory_access <= is_local_memory( thrd2intrfc_address );
      end if;
      fromUserReg_address <= fromUserReg_address_next;
      fromUserReg_value <= fromUserReg_value_next;
      fromUserReg_function <= fromUserReg_function_next;
      fromUserReg_opcode <= fromUserReg_opcode_next;
      

      toUser_value <= toUser_value_next;

      bus_data_out <= bus_data_out_next;
      IP2Bus_Data <= bus_data_out_next;

      system_request <= system_request_next;
      user_return_state <= user_return_state_next;
      data_address <= data_address_next;
      data_value <= data_value_next;

      framePtr <= framePtr_next;
      stackPtr <= stackPtr_next;
      heapPtr <= heapPtr_next;
      paramCount <= paramCount_next;

      reg1 <= reg1_next;
      reg2 <= reg2_next;
      reg3 <= reg3_next;
      reg4 <= reg4_next;

      debug_system <= debug_system_next;
      debug_user <= debug_user_next;

      if ( Bus2IP_Reset = '1'
        or system_command_next = SYSTEM_COMMAND_RESET ) then
        system_state <= START;
        user_state <= START;
      else
        system_state <= system_state_next;
        if ( stackHeapOverflow = '1' ) then
          user_state <= OVERFLOW;
        else 
          user_state <= user_state_next;
        end if;
      end if;
    end if;
  end process HWTI_STATE_PROCESS;

-----------------------------------------------------------------------
-- HWTI_TIMER
-- Process to count the number of clock cycles the HWT is running for.
-- Starts counting when a RUN command is issued, ends counting when
-- status changes to exit.
-----------------------------------------------------------------------
  HWTI_TIMER : process (Bus2IP_Clk) is 
  begin

    if ( Bus2IP_Clk'event and (Bus2IP_Clk = '1') ) then
      case system_status is
        when SYSTEM_STATUS_NOT_USED =>
          timer <= Z32;
        when SYSTEM_STATUS_USED =>
          timer <= Z32;
        when SYSTEM_STATUS_RUNNING =>
          timer <= timer + x"00000001";
        when SYSTEM_STATUS_BLOCKED =>
          timer <= timer + x"00000001";
        when others =>
          --do nothing
      end case;
    end if;

  end process HWTI_TIMER;

---------------------------------------------------------------------------
-- Stack and Heap Overflow Detection
-- Check that the stack does not grow larger than the heap
-- or the heap does not grow into the stack
---------------------------------------------------------------------------
  STACK_HEAP_OVERFLOW_DETECTION : process (Bus2IP_Clk) is
  begin

    if ( system_status = SYSTEM_STATUS_RUNNING 
      and stackPtr >= heapPtr ) then
      stackHeapOverflow <= '1';
    else
      stackHeapOverflow <= '0';
    end if;
  end process STACK_HEAP_OVERFLOW_DETECTION;

---------------------------------------------------------------------------
-- System Bus Controller State Machine
---------------------------------------------------------------------------
  HWTI_SYSTEM_STATE_MACHINE : process (Bus2IP_Clk) is
  begin

    -- Default bus output signal assignments
    IP2Bus_Ack <= '0'; -- pulse(010) to end bus transaction

    -- default bram port A signals
    addra <= (others => '0');
    dia <= (others => '0');
    ena <= '0';
    wea <= '0';

    -- Default register assignments
    system_state_next <= system_state;
    system_thread_id_next <= system_thread_id;
    system_command_next <= system_command;
    system_status_next <= system_status;
    system_argument_next <= system_argument;
    bus_data_out_next <= bus_data_out;
    debug_system_next <= debug_system;
   
    -- The state machine
    case system_state is
      when START =>
        --Set initial values for important signals
        system_thread_id_next <= Z32(0 to 7);
        system_command_next <= SYSTEM_COMMAND_INIT;
        system_status_next <= SYSTEM_STATUS_NOT_USED;
        system_argument_next <= Z32;
        system_state_next <= IDLE;
        bus_data_out_next <= Z32;
        debug_system_next <= Z32; 

      when IDLE =>
        if ( write_ce = '1' ) then
          -- System is writing something to HWT
          case reg_address is 
            when REG_THREAD_ID =>
              -- system is trying to set the thread id
              -- may only be written to when status is NOT_USED
              if ( system_status = SYSTEM_STATUS_NOT_USED ) then
                system_thread_id_next <= Bus2IP_Data(24 to 31);
              end if;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_COMMAND =>
              case Bus2IP_Data(28 to 31) is 
                -- Note that you can not write a system command init.
                when SYSTEM_COMMAND_RUN => system_state_next <= COMMAND_RUN_INIT;
                when SYSTEM_COMMAND_RESET => system_state_next <= COMMAND_RESET_INIT;
                when others => system_state_next <= END_BUS_TRANSACTION; -- do nothing if unreconized command
              end case;

            when REG_ARGUMENT =>
              case system_status  is 
                when SYSTEM_STATUS_USED =>
                  --set the argument register
                  system_argument_next <= Bus2IP_Data;
                  --set the value on the stack
                  addra <= GLOBAL_BASE_ADDR(1 to 13);
                  dia <= Bus2IP_Data;
                  ena <= '1';
                  wea <= '1';
                when others =>
                  --do nothing
                end case;
              system_state_next <= END_BUS_TRANSACTION;
              
            when REG_MASTER_READ =>
              -- When the controller is doing a Bus Master Read, the data
              -- from the bus, when its read, will be placed here.  I think,
              -- actually not wholy sure why this state is needed.
              bus_data_out_next <= Z32;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_RPC_MUTEXCONVAR =>
              addra <= REG_RPC_MUTEXCONVAR(1 to 13);
              dia <= Bus2IP_Data;
              ena <= '1';
              wea <= '1';
              system_state_next <= END_BUS_TRANSACTION;

            when REG_RPC_T_ADDRESS =>
              addra <= REG_RPC_T_ADDRESS(1 to 13);
              dia <= Bus2IP_Data;
              ena <= '1';
              wea <= '1';
              system_state_next <= END_BUS_TRANSACTION;
      
            when others => 
              if (reg_address >= GLOBAL_BASE_ADDR and reg_address <= GLOBAL_HIGH_ADDR) then
                -- System is requesting to write to the shard global address space
                -- internal to the HWTI
                addra <= Bus2IP_Addr(17 to 29);
                dia <= Bus2IP_Data;
                ena <= '1';
                wea <= '1';
                system_state_next <= END_BUS_TRANSACTION;
              else
                -- User is requesting to write to a register that can't be written to
                -- Do nothing and ack the bus
                system_state_next <= END_BUS_TRANSACTION;
              end if;
          end case;

        elsif ( read_ce = '1' ) then
          -- System is reading something from HWT
          case reg_address is
            when REG_THREAD_ID =>
              bus_data_out_next <= Z32(0 to 23) & system_thread_id;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_COMMAND =>
              bus_data_out_next <= Z32(0 to 27) & system_command;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_STATUS =>
              bus_data_out_next <= Z32(0 to 23) & system_status;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_ARGUMENT =>
              bus_data_out_next <= system_argument;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_RESULT =>
              bus_data_out_next <= system_result;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_MASTER_WRITE =>
              -- When the controller is doing a Bus Master Write, need to
              -- provide, to the bus, the data to write.
              bus_data_out_next <= data_value;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_DEBUG_SYSTEM =>
              bus_data_out_next <= debug_system;
              system_state_next <= END_BUS_TRANSACTION;
      
            when REG_DEBUG_USER =>
              bus_data_out_next <= debug_user;
              system_state_next <= END_BUS_TRANSACTION;
      
            when REG_TIMER =>
              bus_data_out_next <= timer;
              system_state_next <= END_BUS_TRANSACTION;
      
            when REG_FRAMEPTR =>
              bus_data_out_next <= C_BASEADDR(0 to 15) & framePtr;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_STACKPTR =>
              bus_data_out_next <= C_BASEADDR(0 to 15) & stackPtr;
              system_state_next <= END_BUS_TRANSACTION;

            when REG_HEAPPTR =>
              bus_data_out_next <= C_BASEADDR(0 to 15) & heapPtr;
              system_state_next <= END_BUS_TRANSACTION;

            when others =>
              -- The address space that is readable from the bus is 4 Words larger than
              -- the space that is writable.  This is because, the dynamic memory
              -- allocation tables is readable for debug purposes.
              if (reg_address >= GLOBAL_BASE_ADDRREADABLE and reg_address <= GLOBAL_HIGH_ADDR) then
                --debug_system_next <= --debug_system or x"00000010";
                -- System is requesting to read to the shard global address space
                -- internal to the HWTI
                addra <= Bus2IP_Addr(17 to 29);
                ena <= '1';
                system_state_next <= GLOBAL_READ_WAIT;
              else
                --debug_system_next <= --debug_system or x"00000020";
                -- Theoritically this case shouldn't happen.  But what ever, return all zeros.
                bus_data_out_next <= Z32;
                system_state_next <= END_BUS_TRANSACTION;
              end if;
          end case;
        else
          -- Nothing is coming in off of the bus.  Check to see if the
          -- controller has anything for us to do.
          case system_request is 
            when CHANGE_STATUS_TO_USED =>
              system_status_next <= SYSTEM_STATUS_USED;
              system_state_next <= IDLE;

            when CHANGE_STATUS_TO_RUN =>
              system_status_next <= SYSTEM_STATUS_RUNNING;
              system_state_next <= IDLE;

            when CHANGE_STATUS_TO_EXIT =>
              system_status_next <= SYSTEM_STATUS_EXITED;
              system_state_next <= IDLE;

            when CHANGE_STATUS_TO_EXIT_ERROR =>
              system_status_next <= SYSTEM_STATUS_EXITED_ERROR;
              system_state_next <= IDLE;

            when CHANGE_STATUS_TO_EXIT_OVERFLOW =>
              system_status_next <= SYSTEM_STATUS_EXITED_OVERFLOW;
              system_state_next <= IDLE;

            when CHANGE_STATUS_TO_BLOCK =>
              system_status_next <= SYSTEM_STATUS_BLOCKED;
              system_command_next <= SYSTEM_COMMAND_INIT; -- CHANGE ME ... maybe
              system_state_next <= IDLE;

            when NOOP =>
              system_state_next <= IDLE;
              
           end case;
        end if;
  
      when COMMAND_RESET_INIT =>
        -- A RESET can be issued at anytime.  Although, it should
        -- really only be called once a thread has exited.
        -- NOTE: A reset command has to be handled carefully.  If we reset
        -- immediatly (ie use the regular END_BUS_TRANSACTION), we will
        -- get a OPB bus error, b/c the HWTI would reset before acking the bus
        IP2Bus_Ack <= '1';
        system_state_next <= COMMAND_RESET_END_BUS_TRANSACTION_WAIT;

      when COMMAND_RESET_END_BUS_TRANSACTION_WAIT =>
        -- Wait for the bus to deassert the Rd or Wr chip enable lines
        if ( read_ce='0' and write_ce='0' ) then
          system_command_next <= SYSTEM_COMMAND_RESET;
          system_state_next <= IDLE;
          bus_data_out_next <= Z32;
        else
          system_state_next <= system_state;
        end if;
        
      when COMMAND_RUN_INIT => 
        -- For the system to issue a RUN command, status must be USED or BLOCKED
        -- BLOCKED, or IDLE
        case system_status is 
          when SYSTEM_STATUS_USED => 
            --debug_system_next <= --debug_system or x"00000001";
            system_command_next <= SYSTEM_COMMAND_RUN;
          when SYSTEM_STATUS_BLOCKED => 
            --debug_system_next <= --debug_system or x"00000002";
            system_command_next <= SYSTEM_COMMAND_RUN;
          when others => 
            --debug_system_next <= --debug_system or x"00000004";
            system_state_next <= END_BUS_TRANSACTION; 
        end case;
        system_state_next <= END_BUS_TRANSACTION; 

      when GLOBAL_READ_WAIT =>
        -- wait one clock cycle per the requirements of bram
        system_state_next <= GLOBAL_READ_RESPOND;

      when GLOBAL_READ_RESPOND =>
        -- return to the system the data it requested
        bus_data_out_next <= doa;
        system_state_next <= END_BUS_TRANSACTION;

      when END_BUS_TRANSACTION =>
        -- Put the data on the bus, and 'ack' the bus.
        IP2Bus_Ack <= '1';
        system_state_next <= END_BUS_TRANSACTION_WAIT;

      when END_BUS_TRANSACTION_WAIT =>
        -- Wait for the bus to deassert the Rd or Wr chip enable lines
        if ( read_ce='0' and write_ce='0' ) then
          system_state_next <= IDLE;
          bus_data_out_next <= Z32;
        else
          system_state_next <= system_state;
        end if;
      end case;

  end process HWTI_SYSTEM_STATE_MACHINE;

-----------------------------------------------------------------------
-- The following state machine controls the HWTI, in particular does the bus master things
-----------------------------------------------------------------------
  HWTI_USER_STATE_MACHINE : process (Bus2IP_clk) is
  begin

     wr <= '0'; --write into FSL
    -- Default register assignments for bus master signals
    IP2Bus_Retry <= '0';
    IP2Bus_Error <= '0';
    IP2Bus_MstRdReq <= '0';
    IP2Bus_MstWrReq <= '0';
    IP2Bus_MstBusLock <= '0';
    IP2Bus_MstBurst <= '0';
    IP2Bus_Addr <= (others => '0');
    IP2IP_Addr <= (others => '0');

    -- Default register assignments for internal signals
    user_state_next <= user_state;
    system_request_next <= system_request;
    system_result_next <= system_result;
    user_return_state_next <= user_return_state;
    data_address_next <= data_address;
    data_value_next <= data_value;
    debug_user_next <= debug_user;

    -- Default register assignments for user interface registers
    fromUserReg_address_next <= fromUserReg_address;
    fromUserReg_value_next <= fromUserReg_value;
    fromUserReg_opcode_next <= fromUserReg_opcode;
    fromUserReg_function_next <= fromUserReg_function;

    
    intrfc2thrd_value <= toUser_value;
    intrfc2thrd_function <= FUNCTION_USER_SELECT;
    intrfc2thrd_goWait <= '0';
   
    toUser_value_next <= toUser_value;

    -- Default register assignment for memory pointers
    framePtr_next <= framePtr;
    stackPtr_next <= stackPtr;
    heapPtr_next <= heapPtr;
    paramCount_next <= paramCount;

    -- Temporary registers for library functions
    reg1_next <= reg1;
    reg2_next <= reg2;
    reg3_next <= reg3;
    reg4_next <= reg4;

    -- Default assignments for bram port B 
    addrb <= (others => '0');
    enb <= '0';
    web <= '0';
    dib <= (others => '0');

    case user_state is
-----------------------------------------------------------------------
-- States START through USED_WAIT are used to make sure the hthread
-- system sets the thread_id and command register in the correct sequence
-----------------------------------------------------------------------
      when START =>
        user_state_next <= NOT_USED;
        system_request_next <= NOOP;
        system_result_next <= x"FFFFFFFF";
        user_return_state_next <= RUNNING;
        data_address_next <= Z32;
        data_value_next <= Z32;
        intrfc2thrd_value <= Z32;
        intrfc2thrd_function <= FUNCTION_RESET;
        intrfc2thrd_goWait <= '1';
        wr  <= '1';
      
        toUser_value_next <= Z32;
        fromUserReg_address_next <= Z32;
        fromUserReg_value_next <= Z32;
        fromUserReg_function_next <= FUNCTION_RESET;
        fromUserReg_opcode_next <= OPCODE_NOOP;
        debug_user_next <= Z32;
        heapPtr_next <= x"7600"; --The initial heap ptr takes into account the pre-allocated chunks of memory for malloc
        reg1_next <= Z32;
        reg2_next <= Z32;
        reg3_next <= Z32;
        reg4_next <= Z32;

      when NOT_USED =>
        -- Wait for the thread id to be set by the system
        case system_thread_id is
          when x"00" =>
            user_state_next <= NOT_USED;
            --Set up the memory pointers and stack frame for use
            framePtr_next <= (GLOBAL_BASE_ADDR + 4) & "00";
            stackPtr_next <= (GLOBAL_BASE_ADDR + 4) & "00";
            --Base addr + 1 = number of parameters in call, which for thread create is always 1
            addrb <= (GLOBAL_BASE_ADDR(1 to 13) + 1);
            enb <= '1';
            web <= '1';
            dib <= Z32(0 to 30) & '1';
            paramCount_next <= x"00";
            -- Stop the HWTUL's reset state
            intrfc2thrd_goWait <= '0';
          when others =>
            user_state_next <= RESET_MALLOC_TABLE;
            reg1_next <= x"00000001";
            system_request_next <= CHANGE_STATUS_TO_USED;
          end case;

      when RESET_MALLOC_TABLE =>
        -- When a thread starts, need to reset malloc table
        case reg1 is
          when x"00000001" =>
            addrb <= REG_8B_DYNAMIC_TABLE(1 to 13);
            enb <= '1';
            web <= '1';
            dib <= Z32;
            reg1_next <= x"00000002";
            user_state_next <= RESET_MALLOC_TABLE;
          when x"00000002" =>
            addrb <= REG_32B_DYNAMIC_TABLE(1 to 13);
            enb <= '1';
            web <= '1';
            dib <= Z32;
            reg1_next <= x"00000003";
            user_state_next <= RESET_MALLOC_TABLE;
          when x"00000003" =>
            addrb <= REG_1024B_DYNAMIC_TABLE(1 to 13);
            enb <= '1';
            web <= '1';
            dib <= Z32;
            reg1_next <= x"00000004";
            user_state_next <= RESET_MALLOC_TABLE;
          when others =>
            addrb <= REG_UNLIMITED_DYNAMIC_TABLE(1 to 13);
            enb <= '1';
            web <= '1';
            dib <= Z32;
            reg1_next <= Z32;
            user_state_next <= NOT_USED_WAIT;
        end case;

      when NOT_USED_WAIT =>
        -- Wait for the system state machine to change to used status
        case system_status is
          when SYSTEM_STATUS_USED =>
            system_request_next <= NOOP;
            user_state_next <= USED;
            --Continue to set up strack frame
            --base addr + 2 = return address for frame ptr, which for thread create is always, by design, 0000
            addrb <= (GLOBAL_BASE_ADDR(1 to 13) + 2);
            enb <= '1';
            web <= '1';
            dib <= Z32;
          when others =>
            user_state_next <= NOT_USED_WAIT;
          end case;

      when USED =>
        -- Wait for a RUN command
        case system_command is
          when SYSTEM_COMMAND_RUN =>
            system_request_next <= CHANGE_STATUS_TO_RUN;
            user_state_next <= USED_WAIT;
            --Continue (again) to set up the stack frame
            --base addr + 3 = return state, which for thread create is always, by design 0000
            addrb <= (GLOBAL_BASE_ADDR(1 to 13) + 3);
            enb <= '1';
            web <= '1';
            dib <= Z32;
          when others =>
            user_state_next <= USED;
          end case;

      when USED_WAIT =>
        -- Wait for system state machines to update status register
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            system_request_next <= NOOP;
            intrfc2thrd_function <= FUNCTION_START;
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;
          when others =>
            user_state_next <= USED_WAIT;
          end case;

 
    
   when RUNNING => 
      system_request_next <= NOOP;
      --wait untill a new request from user logic arrives
      if (exist='1') then
         user_state_next <= SERVICE_NEW_REQUST;
      else
         user_state_next <= RUNNING;       
      end if;   

-----------------------------------------------------------------------
-- Once the user_state machine reaches RUNNING, the thread has been
-- created and is expected to run.  The RUNNING state waits for the
-- user thread to request an opperation.  Once an opperation is 
-- requested, it starts to act on it.  By default, the HWTI tells the user logic
-- to do its own thing, ie FUNCTION_USER_SELECT.
-----------------------------------------------------------------------
      when SERVICE_NEW_REQUST =>
        fromUserReg_address_next <= fromUser_address;
        fromUserReg_value_next <= fromUser_value;
        fromUserReg_function_next <= fromUser_function;
        fromUserReg_opcode_next <= fromUser_opcode;

        -- Find out what the HWTUL is requesting, if anything
        case fromUser_opcode is
          --------------------------------------------------------------
          -- Memory sub-interface
          --------------------------------------------------------------
          when OPCODE_LOAD =>
            if (fromUser_address(0 to 15) = C_BASEADDR(0 to 15)) then
              -- HWTUL is requesting to read an address in BRAM
              addrb <= fromUser_address(17 to 29);
              enb <= '1';
              user_state_next <= WAIT_ONE_CYCLE;
              -- Check for a non-word-aligned read
              case fromUser_address(30 to 31) is
                when "00" =>
                  user_return_state_next <= LOCAL_LOAD_RESPOND;
                when OTHERS =>
                  user_return_state_next <= LOCAL_PARTIAL_LOAD;
              end case;
            else
              -- HWTUL is requesting to read an address from global address space
              data_address_next <= fromUser_address;
              user_return_state_next <= GLOBAL_LOAD_RETURN;
              user_state_next <= MASTER_LOAD_INIT;
            end if;

          when OPCODE_STORE =>
            if (fromUser_address(0 to 15) = C_BASEADDR(0 to 15)) then
              -- HWTUL is requestiong to write an address in BRAM
              addrb <= fromUser_address(17 to 29);
              dib <= fromUser_value;
              web <= '1';
              enb <= '1';
              intrfc2thrd_goWait <= '1';
              wr  <= '1';
              user_state_next <= RUNNING;
            else
              -- HWTUL is requestiong to write an address in global address space
              data_address_next <= fromUser_address;
              data_value_next <= fromUser_value;
              user_state_next <= MASTER_STORE_INIT;
              user_return_state_next <= GLOBAL_LOAD_RETURN;
            end if;

          when OPCODE_DECLARE =>
            -- increment the stack ptr the number of words the UL is declaring
            -- TODO: check to see that param=0.  If not that means the user has called push and shouldn't be calling declare again until after a function call and return.
            stackPtr_next <= '0' & (stackPtr(1 to 13) + fromUser_value(19 to 31)) & "00";
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;

          when OPCODE_READ =>
            -- read the stack, based on frame ptr offset, provided by user
            addrb <= framePtr(1 to 13) + fromUser_address(19 to 31);
            enb <= '1';
            user_state_next <= WAIT_ONE_CYCLE;
            user_return_state_next <= LOCAL_LOAD_RESPOND;

          when OPCODE_WRITE =>
            -- write to the stack, based on frame ptr offset, provided by user
            addrb <= framePtr(1 to 13) + fromUser_address(19 to 31);
            dib <= fromUser_value;
            web <= '1';
            enb <= '1';
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;

          when OPCODE_ADDRESSOF =>
            -- return to the user frame ptr + offset
            intrfc2thrd_value <= C_BASEADDR(0 to 15) 
              & "00"
              & (framePtr(2 to 13) + fromUser_address(20 to 31))
              & "00";
            toUser_value_next <= C_BASEADDR(0 to 15) 
              & "00"
              & (framePtr(2 to 13) + fromUser_address(20 to 31))
              & "00";
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;

          --------------------------------------------------------------
          -- Function sub-interface
          --------------------------------------------------------------
          when OPCODE_PUSH =>
            -- Place the argument where the stack pointer is now, and then increment sp
            addrb <= stackPtr(1 to 13);
            dib <= fromUser_value;
            enb <= '1';
            web <= '1';
            paramCount_next <= paramCount + 1;
            stackPtr_next <= '0' & (stackPtr(1 to 13) + 1) & "00";
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;

          when OPCODE_POP =>
            -- Read the number of parameters on the stack for the current function
            addrb <= framePtr(1 to 13) - 3 ;
            enb <= '1';
            user_state_next <= WAIT_ONE_CYCLE;
            user_return_state_next <= POP_READ_PARAM_COUNT;

          when OPCODE_CALL =>
            case fromUser_function is
                when FUNCTION_HTHREAD_ATTR_INIT =>
                -- Read the parameter the user passed in
                -- Parameter should be previously allocated thread attr struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_ATTR_INIT;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

                when FUNCTION_HTHREAD_ATTR_DESTROY =>
                -- Read the parameter the user passed in
                -- Parameter should be previously allocated thread attr struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_ATTR_INIT;
                -- Note that I'm reusing the ATTR_INIT state
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_CREATE =>
                -- Need to call the RPC code
                -- Set reg1 to the opcode
                reg1_next <= Z32(0 to 15) & FUNCTION_HTHREAD_CREATE;
                -- Read the value of the mutex and condvar numbers
                addrb <= REG_RPC_MUTEXCONVAR(1 to 13);
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_RPC;

              when FUNCTION_HTHREAD_JOIN =>
                -- Need to call the RPC code
                -- Set reg1 to the opcode
                reg1_next <= Z32(0 to 15) & FUNCTION_HTHREAD_JOIN;
                -- Read the value of the mutex and condvar numbers
                addrb <= REG_RPC_MUTEXCONVAR(1 to 13);
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_RPC;

              when FUNCTION_HTHREAD_SELF =>
                -- return the thread id to the user
                intrfc2thrd_function <= fromUser_value(16 to 31);
                intrfc2thrd_value <= Z32(0 to 23) & system_thread_id;
                toUser_value_next <= Z32(0 to 23) & system_thread_id;
                intrfc2thrd_goWait <= '1';
                wr  <= '1';
                user_state_next <= RUNNING;

              when FUNCTION_HTHREAD_YIELD =>
                -- return to the user immediatly
                intrfc2thrd_function <= fromUser_value(16 to 31);
                intrfc2thrd_goWait <= '1';
                wr  <= '1';
                user_state_next <= RUNNING;

              when FUNCTION_HTHREAD_EQUAL =>
                --read the second paramter the user pushed
                --which should be a hthread_t (which is the same as an int)
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_EQUAL;

              when FUNCTION_HTHREAD_EXIT =>
                system_request_next <= CHANGE_STATUS_TO_EXIT;
                user_state_next <= HTHREAD_EXIT;

              when FUNCTION_HTHREAD_EXIT_ERROR =>
                system_request_next <= CHANGE_STATUS_TO_EXIT_ERROR;
                user_state_next <= HTHREAD_EXIT;

              when FUNCTION_HTHREAD_MUTEXATTR_INIT =>
                -- Read the parameter the user passed in
                -- Parameter should be previously allocated mutexattr struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEXATTR_INIT;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_MUTEXATTR_DESTROY =>
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";
                -- return a SUCCESS to the user
                intrfc2thrd_function <= fromUser_value(16 to 31);
                intrfc2thrd_value <= Z32;
                toUser_value_next <= Z32;
                intrfc2thrd_goWait <= '1';
                wr  <= '1';
                user_state_next <= RUNNING;

              when FUNCTION_HTHREAD_MUTEXATTR_SETNUM =>
                -- Read the second parameter the user pushed in
                -- Parameter should be mutexattr struct address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEXATTR_SETNUM;

              when FUNCTION_HTHREAD_MUTEXATTR_GETNUM =>
                -- Read the second parameter the user pushed in
                -- Parameter should be mutexattr struct address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEXATTR_GETNUM;

              when FUNCTION_HTHREAD_MUTEX_INIT =>
                -- Read the second parameter the user pushed in
                -- Parameter should be mutex struct address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEX_INIT;

              when FUNCTION_HTHREAD_MUTEX_DESTROY =>
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";
                -- return a SUCCESS to the user
                intrfc2thrd_function <= fromUser_value(16 to 31);
                intrfc2thrd_value <= Z32;
                toUser_value_next <= Z32;
                intrfc2thrd_goWait <= '1';
                wr  <= '1';
                user_state_next <= RUNNING;

              when FUNCTION_HTHREAD_MUTEX_LOCK =>
                -- Read the parameter the user passed in
                -- Parameter should be previously initialized mutex struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEX_LOCK;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_MUTEX_UNLOCK =>
                -- Read the parameter the user passed in
                -- Parameter should be previously initialized mutex struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEX_UNLOCK;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_MUTEX_TRYLOCK =>
                -- Read the parameter the user passed in
                -- Parameter should be previously initialized mutex struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_MUTEX_TRYLOCK;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_CONDATTR_INIT =>
                -- Read the parameter the user passed in
                -- Parameter should be previously allocated condattr struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_CONDATTR_INIT;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_CONDATTR_DESTROY =>
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";
                -- return a SUCCESS to the user
                intrfc2thrd_function <= fromUser_value(16 to 31);
                intrfc2thrd_value <= Z32;
                toUser_value_next <= Z32;
                intrfc2thrd_goWait <= '1';
                wr  <= '1';
                user_state_next <= RUNNING;

              when FUNCTION_HTHREAD_CONDATTR_SETNUM =>
                -- Read the second parameter the user pushed in
                -- Parameter should be condattr struct address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                --Note that I am reusing the states for MUTEXATTR_GETNUM
                user_return_state_next <= HTHREAD_MUTEXATTR_SETNUM;

              when FUNCTION_HTHREAD_CONDATTR_GETNUM =>
                -- Read the second parameter the user pushed in
                -- Parameter should be condattr struct address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                --Note that I am reusing the states for MUTEXATTR_GETNUM
                user_return_state_next <= HTHREAD_MUTEXATTR_GETNUM;

              when FUNCTION_HTHREAD_COND_INIT =>
                -- Read the second parameter the user pushed in
                -- Parameter should be mutex struct address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_COND_INIT;

              when FUNCTION_HTHREAD_COND_DESTROY =>
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";
                -- return a SUCCESS to the user
                intrfc2thrd_function <= fromUser_value(16 to 31);
                intrfc2thrd_value <= Z32;
                toUser_value_next <= Z32;
                intrfc2thrd_goWait <= '1';
                wr  <= '1';
                user_state_next <= RUNNING;

              when FUNCTION_HTHREAD_COND_WAIT =>
                -- Read the the first parameter the user passed in
                -- Parameter should be previously initialized cond var struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_COND_WAIT;

              when FUNCTION_HTHREAD_COND_BROADCAST =>
                -- Read the parameter the user passed in
                -- Parameter should be previously initialized cond var struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_COND_BCAST;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_HTHREAD_COND_SIGNAL =>
                -- Read the parameter the user passed in
                -- Parameter should be previously initialized cond var struct's address
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= HTHREAD_COND_SIGNAL;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              ---------------------------------------------------------
              -- stdlib.h functions
              ---------------------------------------------------------
              when FUNCTION_MALLOC =>
                -- User wants to allocate memory on the heap
                -- Read the parameter the user (should have) passed in
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= LIB_FUNCTION_MALLOC;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              when FUNCTION_CALLOC =>
                -- User wants to allocate memory on the heap
                -- Read the first parameter the user passed in
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= LIB_FUNCTION_CALLOC;

              when FUNCTION_FREE =>
                -- User wants to de-allocate memory on the heap
                -- Read the address of the data the user passed in
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= LIB_FUNCTION_FREE;
                -- Reset number of parameters
                paramCount_next <= x"00";
                -- decrement the stack pointer
                stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

              ---------------------------------------------------------
              -- string.h functions
              ---------------------------------------------------------
              when FUNCTION_MEMCPY =>
                -- Copy data from *dest to *src, with size n
                -- read the first parameter *dest
                addrb <= stackPtr(1 to 13) - 1;
                enb <= '1';
                user_state_next <= WAIT_ONE_CYCLE;
                user_return_state_next <= LIB_FUNCTION_MEMCPY;
                -- Reset number of parameters
                paramCount_next <= x"00";

              ---------------------------------------------------------
              -- User defined functions
              ---------------------------------------------------------
              when others =>
                -- first write the number of params to the stack
                addrb <= stackPtr(1 to 13);
                dib <= Z32(0 to 23) & paramCount;
                enb <= '1';
                web <= '1';
                -- update the stack ptr and reset the num of params
                stackPtr_next <= '0' & (stackPtr(1 to 13) + 1) & "00";
                paramCount_next <= x"00";
                user_state_next <= USER_FUNCTION_CALL;

            end case;

          when OPCODE_RETURN =>
            -- user is returning from an internal function
            -- set the return value
            intrfc2thrd_value <= fromUser_value;
            toUser_value_next <= fromUser_value;
            -- read the HWTUL return state 
            addrb <= framePtr(1 to 13) - 1;
            enb <= '1';
            user_state_next <= WAIT_ONE_CYCLE;
            user_return_state_next <= USER_FUNCTION_RETURN;

          when others => -- ie noop
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;
        end case;

-----------------------------------------------------------------------
-- LIB FUNCTION MEMCPY
-- memcpy( void *dest, const void *src, size_t n )
-- Copy memory from dest to src, with size n
-- TODO use burst transacations instead of single transactions
-----------------------------------------------------------------------
        when LIB_FUNCTION_MEMCPY =>
          -- reg1 is the destination pointer
          reg1_next <= dob;
          -- read the source pointer from the stack
          addrb <= stackPtr(1 to 13) - 2;
          enb <= '1';
          user_state_next <= WAIT_ONE_CYCLE;
          user_return_state_next <= LIB_FUNCTION_MEMCPY_2;

        when LIB_FUNCTION_MEMCPY_2 =>
          -- reg2 is the source pointer
          reg2_next <= dob;
          -- read the size n from the stack
          addrb <= stackPtr(1 to 13) - 3;
          enb <= '1';
          user_state_next <= WAIT_ONE_CYCLE;
          user_return_state_next <= LIB_FUNCTION_MEMCPY_3;

        when LIB_FUNCTION_MEMCPY_3 =>
          -- reg3 is the number of bytes to copy
          -- force the number of bytes to copy to be increment of 4
          reg3_next <= dob(0 to 29) & "00";
          -- decrement the stack pointer 3 words
          stackPtr_next <= '0' & (stackPtr(1 to 13) - 3) & "00";
          -- reg4 will track if the to and from address are local or global
          -- specifically reg4(0) is source, reg4(1) is destination
          -- a 1 means the address is local, 0 means global
          if ( reg2(0 to 15) = C_BASEADDR(0 to 15) ) then
            reg4_next(0) <= '1';
          else
            reg4_next(0) <= '0';
          end if;
          if ( reg1(0 to 15) = C_BASEADDR(0 to 15) ) then
            reg4_next(1) <= '1';
          else
            reg4_next(1) <= '0';
          end if;
          user_state_next <= LIB_FUNCTION_MEMCPY_4;

        when LIB_FUNCTION_MEMCPY_4 =>
          case reg3 is
          when Z32 =>
            -- all data is copied, return to user
            intrfc2thrd_function <= fromUserReg_value(16 to 31);
            intrfc2thrd_goWait <= '1';
                wr  <= '1';
            user_state_next <= RUNNING;
          when others =>
            -- there is more to read
            -- initiate read of address stored in reg2, source of data
            -- Determine if the address is local
            case reg4(0) is 
            when '1' =>
              -- read from local
              enb <= '1';
              addrb <= reg2(17 to 29);
              user_state_next <= WAIT_ONE_CYCLE;
              user_return_state_next <= LIB_FUNCTION_MEMCPY_5;
            when others =>
              -- read from local
              data_address_next <= reg2;
              user_return_state_next <= LIB_FUNCTION_MEMCPY_5;
              user_state_next <= MASTER_LOAD_INIT;
            end case;
          end case;
--
        when LIB_FUNCTION_MEMCPY_5 =>
          -- initiate write of data to address stored in reg1
          -- Determine if the address is local
          case reg4(1) is
          when '1' =>
            -- write to local 
            enb <= '1';
            web <= '1';
            addrb <= reg1(17 to 29);
            -- if the previous read was local pull from dob, instead of data_value
            case reg4(0) is
            when '1' =>
              dib <= dob;
            when others =>
              dib <= data_value;
            end case;
            user_state_next <= LIB_FUNCTION_MEMCPY_6;
          when others =>
            -- write to global 
            data_address_next <= reg1;
            -- if the previous read was local pull from dob, instead of data_value
            case reg4(0) is
            when '1' =>
              data_value_next <= dob;
            when others =>
              data_value_next <= data_value;
            end case;
            user_return_state_next <= LIB_FUNCTION_MEMCPY_6;
            user_state_next <= MASTER_STORE_INIT;
          end case;

        when LIB_FUNCTION_MEMCPY_6 =>
          -- increment the pointers
          reg1_next <= reg1 + 4;
          reg2_next <= reg2 + 4;
          -- decrement the count one word
          reg3_next <= reg3 - 4;
          user_state_next <= LIB_FUNCTION_MEMCPY_4;

-----------------------------------------------------------------------
-- LIB FUNCTION FREE
-- free(void * address);
-- de-allocates space on the heap, specified by passed in parameter
-----------------------------------------------------------------------
       when LIB_FUNCTION_FREE =>
         -- Record the address of the data to deallocate
         reg1_next <= dob;
         user_state_next <= LIB_FUNCTION_FREE_1;

        when LIB_FUNCTION_FREE_1 =>
          -- The following is a lookup table for determine which mask to use
          user_state_next <= LIB_FUNCTION_FREE_2;
          case reg1(16 to 31) is
            when x"7FF8" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"7FFFFFFF";
            when x"7FF0" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"BFFFFFFF";
            when x"7FE8" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"DFFFFFFF";
            when x"7FE0" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"EFFFFFFF";
            when x"7FD8" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"F7FFFFFF";
            when x"7FD0" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FBFFFFFF";
            when x"7FC8" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FDFFFFFF";
            when x"7FC0" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FEFFFFFF";
            when x"7FB8" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FF7FFFFF";
            when x"7FB0" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFBFFFFF";
            when x"7FA8" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFDFFFFF";
            when x"7FA0" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFEFFFFF";
            when x"7F98" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFF7FFFF";
            when x"7F90" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFBFFFF";
            when x"7F88" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFDFFFF";
            when x"7F80" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFEFFFF";
            when x"7F78" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFF7FFF";
            when x"7F70" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFBFFF";
            when x"7F68" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFDFFF";
            when x"7F60" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFEFFF";
            when x"7F58" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFF7FF";
            when x"7F50" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFBFF";
            when x"7F48" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFDFF";
            when x"7F40" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFEFF";
            when x"7F38" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFF7F";
            when x"7F30" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFBF";
            when x"7F28" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFDF";
            when x"7F20" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFEF";
            when x"7F18" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFF7";
            when x"7F10" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFFB";
            when x"7F08" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFFD";
            when x"7F00" =>
              reg2_next <= Z32(0 to 15) & REG_8B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FFFFFFFE";
            when x"7EE0" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"7FFFFFFF";
            when x"7EC0" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"BFFFFFFF";
            when x"7EA0" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"DFFFFFFF";
            when x"7E80" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"EFFFFFFF";
            when x"7E60" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"F7FFFFFF";
            when x"7E40" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FBFFFFFF";
            when x"7E20" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FDFFFFFF";
            when x"7E00" =>
              reg2_next <= Z32(0 to 15) & REG_32B_DYNAMIC_TABLE & "00";
              reg3_next <= x"FEFFFFFF";
            when x"7A00" =>
              reg2_next <= Z32(0 to 15) & REG_1024B_DYNAMIC_TABLE & "00";
              reg3_next <= x"7FFFFFFF";
            when x"7600" =>
              reg2_next <= Z32(0 to 15) & REG_1024B_DYNAMIC_TABLE & "00";
              reg3_next <= x"BFFFFFFF";
            when others =>
              -- should be the unlimited case
              -- TODO check to make sure the user is de allocating this space
              -- and not some random address
              reg2_next <= Z32(0 to 15) & REG_UNLIMITED_DYNAMIC_TABLE & "00";
              reg3_next <= Z32;
              -- deallocate the space on the heap
              heapPtr_next <= x"7600";
            end case;

        when LIB_FUNCTION_FREE_2 =>
          enb <= '1';
          addrb <= reg2(17 to 29);
          user_state_next <= WAIT_ONE_CYCLE;
          user_return_state_next <= LIB_FUNCTION_FREE_3;

        when LIB_FUNCTION_FREE_3 =>
          -- Mark the space as deallocated
          enb <= '1';
          web <= '1';
          addrb <= reg2(17 to 29);
          dib <= dob and reg3;
          -- Return to the user
          intrfc2thrd_goWait <= '1';
                wr  <= '1';
          intrfc2thrd_function <= fromUserReg_value(16 to 31);
          user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- LIB FUNCTION CALLOC
-- malloc(size_t numBytes, size_t size);
-- Allocate space on the heap, specified by passed in parameters size*size_t
-----------------------------------------------------------------------
      when LIB_FUNCTION_CALLOC =>
        -- Record the first parameter in reg3
        reg3_next <= dob;
        -- Read the second parameter 
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= LIB_FUNCTION_CALLOC_2;
        -- Reset number of parameters
        paramCount_next <= x"00";
        -- decrement the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";

      when LIB_FUNCTION_CALLOC_2 =>
        reg2_next <= dob;
        user_state_next <= LIB_FUNCTION_CALLOC_3;

      when LIB_FUNCTION_CALLOC_3 =>
        -- Step 1: Multiply reg2 and reg 3, storing result in reg1
        reg4_next <= std_logic_vector(conv_signed(signed("00"&reg2(16 to 31)) * signed("00"&reg3(16 to 31)), 32));
        reg1_next <= std_logic_vector(conv_signed(signed("00"&reg2(0 to 15)) * signed("00"&reg3(0 to 15)), 32));
        user_state_next <= LIB_FUNCTION_CALLOC_4;

      when LIB_FUNCTION_CALLOC_4 =>
        -- Step 2: Multiply reg2 and reg 3, storing result in reg1
        reg4_next <= std_logic_vector(conv_signed(signed("00"&reg2(16 to 31)) * signed("00"&reg3(0 to 15)), 32));
        reg1_next <= reg4 + (reg1(16 to 31)&x"0000");
        user_state_next <= LIB_FUNCTION_CALLOC_5;
      
      when LIB_FUNCTION_CALLOC_5 =>
        -- Step 3: Multiply reg2 and reg 3, storing result in reg1
        reg1_next <= reg4(16 to 31)&x"0000" + reg1;
        user_state_next <= LIB_FUNCTION_MALLOC_8a;

-----------------------------------------------------------------------
-- LIB FUNCTION MALLOC
-- malloc(size_t size);
-- Allocate space on the heap, specified by passed in parameter
-----------------------------------------------------------------------
       when LIB_FUNCTION_MALLOC =>
         -- Record the size of the bytes to allocate in reg 1
         reg1_next <= dob;
         user_state_next <= LIB_FUNCTION_MALLOC_8a;

       when LIB_FUNCTION_MALLOC_8a =>
         -- Test to see if we should read the 8B dynamic memory table
         if ( reg1 <= x"00000008" ) then
           -- size of data to allocate is less than/equal to 8B
           -- Read the dynmic memory table for 8B
           enb <= '1';
           addrb <= REG_8B_DYNAMIC_TABLE (1 to 13);
           user_state_next <= WAIT_ONE_CYCLE;
           user_return_state_next <= LIB_FUNCTION_MALLOC_8b;
         else 
           -- size of data to allocate is greater than 8B
           user_state_next <= LIB_FUNCTION_MALLOC_32a;
         end if;
         -- Initialize reg2, the loop iterator
         reg2_next <= x"80000000";

       when LIB_FUNCTION_MALLOC_8b =>
         -- reg 3 is the value of the dynamic memory table
         reg3_next <= dob;
         -- reg 4 is the address to send back to the user once an open chunk is found
         -- start with the highest possible value, then decrement as we search
         reg4_next <= C_BASEADDR(0 to 15) & BASE_ADDR_MALLOC_8B;
         user_state_next <= LIB_FUNCTION_MALLOC_8c;

       when LIB_FUNCTION_MALLOC_8c =>
         -- iterate through memory table until we find an open chunk of memory
         if ( (reg2 or reg3) /= reg3 ) then
           -- we have found an open chunk of memory
           -- mark this chunk of memory as allocated
           enb <= '1';
           web <= '1';
           addrb <= REG_8B_DYNAMIC_TABLE(1 to 13);
           dib <= reg2 or reg3;
           -- return to the user pointer to allocated memory
           intrfc2thrd_value <= reg4;
           toUser_value_next <= reg4;
           intrfc2thrd_goWait <= '1';
                wr  <= '1';
           intrfc2thrd_function <= fromUserReg_value(16 to 31);
           user_state_next <= RUNNING;
         else
           -- need to keep looking
           if ( reg2 = x"00000001" ) then
             -- we reached the end of the 8B block table, and all spaces 
             -- are used, try the 32B block table
              user_state_next <= LIB_FUNCTION_MALLOC_32a;
           else
             -- decrement the return address
             reg4_next <= reg4 - 8;
             -- shift the loop iterator
             reg2_next <= '0' & reg2(0 to 30);
             -- try again 
             user_state_next <= LIB_FUNCTION_MALLOC_8c;
           end if;
         end if;

       when LIB_FUNCTION_MALLOC_32a =>
         -- Test to see if we should read the 32B dynamic memory table
         if ( reg1 <= x"00000020" ) then
           -- size of data to allocate is less than/equal to 32B
           -- Read the dynmic memory table for 32B
           enb <= '1';
           addrb <= REG_32B_DYNAMIC_TABLE (1 to 13);
           user_state_next <= WAIT_ONE_CYCLE;
           user_return_state_next <= LIB_FUNCTION_MALLOC_32b;
         else 
           -- size of data to allocate is greater than 32B
           user_state_next <= LIB_FUNCTION_MALLOC_1024a;
         end if;

       when LIB_FUNCTION_MALLOC_32b =>
         -- reg 3 is the value of the dynamic memory table
         reg3_next <= dob;
         -- reg 4 is the address to send back to the user once an open chunk is found
         -- start with the highest possible value, then decrement as we search
         reg4_next <= C_BASEADDR(0 to 15) & BASE_ADDR_MALLOC_32B;
         user_state_next <= LIB_FUNCTION_MALLOC_32c;

       when LIB_FUNCTION_MALLOC_32c =>
         -- iterate through memory table until we find an open chunk of memory
         if ( (reg2 or reg3) /= reg3 ) then
           -- we have found an open chunk of memory
           -- mark this chunk of memory as allocated
           enb <= '1';
           web <= '1';
           addrb <= REG_32B_DYNAMIC_TABLE(1 to 13);
           dib <= reg2 or reg3;
           -- return to the user pointer to allocated memory
           intrfc2thrd_value <= reg4;
           toUser_value_next <= reg4;
           intrfc2thrd_goWait <= '1';
                wr  <= '1';
           intrfc2thrd_function <= fromUserReg_value(16 to 31);
           user_state_next <= RUNNING;
         else
           -- need to keep looking
           if ( reg2 = x"01000000" ) then
             -- we reached the end of the 32B block table, and all spaces 
             -- are used, try the 1024B block table
             user_state_next <= LIB_FUNCTION_MALLOC_1024a;
           else
             -- decrement the return address
             reg4_next <= reg4 - 32;
             -- shift the loop iterator
             reg2_next <= '0' & reg2(0 to 30);
             -- try again 
             user_state_next <= LIB_FUNCTION_MALLOC_32c;
           end if;
         end if;

       when LIB_FUNCTION_MALLOC_1024a => 
         -- Test to see if we should read the 1024B dynamic memory table
         if ( reg1 <= x"00000400" ) then
           -- size of data to allocate is less than/equal to 1024B
           -- Read the dynmic memory table for 1024B
           enb <= '1';
           addrb <= REG_1024B_DYNAMIC_TABLE (1 to 13);
           user_state_next <= WAIT_ONE_CYCLE;
           user_return_state_next <= LIB_FUNCTION_MALLOC_1024b;
         else 
           -- size of data to allocate is greater than 1024B
           user_state_next <= LIB_FUNCTION_MALLOC_UNLIMITa;
         end if;

       when LIB_FUNCTION_MALLOC_1024b =>
         -- reg 3 is the value of the dynamic memory table
         reg3_next <= dob;
         -- reg 4 is the address to send back to the user once an open chunk is found
         -- start with the highest possible value, then decrement as we search
         reg4_next <= C_BASEADDR(0 to 15) & BASE_ADDR_MALLOC_1024B;
         user_state_next <= LIB_FUNCTION_MALLOC_1024c;

       when LIB_FUNCTION_MALLOC_1024c =>
         -- iterate through memory table until we find an open chunk of memory
         if ( (reg2 or reg3) /= reg3 ) then
           -- we have found an open chunk of memory
           -- mark this chunk of memory as allocated
           enb <= '1';
           web <= '1';
           addrb <= REG_1024B_DYNAMIC_TABLE(1 to 13);
           dib <= reg2 or reg3;
           -- return to the user pointer to allocated memory
           intrfc2thrd_value <= reg4;
           toUser_value_next <= reg4;
           intrfc2thrd_goWait <= '1';
           wr  <= '1';
           intrfc2thrd_function <= fromUserReg_value(16 to 31);
           user_state_next <= RUNNING;
         else
           -- need to keep looking
           if ( reg2 = x"40000000" ) then
             -- we reached the end of the 1024B block table, and all spaces 
             -- are used, try the UNLIMIT block table
             user_state_next <= LIB_FUNCTION_MALLOC_UNLIMITa;
           else
             -- decrement the return address
             reg4_next <= reg4 - 1024;
             -- shift the loop iterator
             reg2_next <= '0' & reg2(0 to 30);
             -- try again 
             user_state_next <= LIB_FUNCTION_MALLOC_1024c;
           end if;
         end if;

       when LIB_FUNCTION_MALLOC_UNLIMITa =>
         -- Test to see if we should read the UNLIMITED dynamic memory table
         if ( reg1 <= x"00007000" ) then
           -- size of data to allocate is less than/equal to x3000B
           -- Read the dynmic memory table for UNLIMITED 
           enb <= '1';
           addrb <= REG_UNLIMITED_DYNAMIC_TABLE (1 to 13);
           user_state_next <= WAIT_ONE_CYCLE;
           user_return_state_next <= LIB_FUNCTION_MALLOC_UNLIMITb;
         else 
           -- size of data is too big, return NULL pointer
           intrfc2thrd_value <= Z32;
           toUser_value_next <= Z32;
           intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
           intrfc2thrd_goWait <= '1';
           wr  <= '1';
           user_state_next <= RUNNING;
         end if;

       when LIB_FUNCTION_MALLOC_UNLIMITb =>
         if ( dob = Z32 ) then
           -- decrement the heapPtr specifed number of parameters
           heapPtr_next <= '0' & (heapPtr(1 to 13) - reg1(18 to 29)) & "00";
           user_state_next <= LIB_FUNCTION_MALLOC_UNLIMITc;
         else 
           -- already allocated unlimited data, return NULL pointer
           intrfc2thrd_value <= Z32;
           toUser_value_next <= Z32;
           intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
           intrfc2thrd_goWait <= '1';
           wr  <= '1';
           user_state_next <= RUNNING;
         end if;

       when LIB_FUNCTION_MALLOC_UNLIMITc =>
         -- Write the address to the UNLIMTIED table
         enb <= '1';
         web <= '1';
         addrb <= REG_UNLIMITED_DYNAMIC_TABLE (1 to 13);
         dib <= C_BASEADDR(0 to 15) & heapPtr;
         -- Tell the user to start executing again, telling it the pointer to allocated space
         intrfc2thrd_value <= C_BASEADDR(0 to 15) & heapPtr;
         toUser_value_next <= C_BASEADDR(0 to 15) & heapPtr;
         intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
         intrfc2thrd_goWait <= '1';
           wr  <= '1';
         user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- USER FUNCTION RETURN
-- These states are used  when the HWTUL is returning from a user
-- defined function
-----------------------------------------------------------------------
      when USER_FUNCTION_RETURN =>
        -- check the return state address to make sure it is not 0000, 
        -- if it is 0000 then this is the main thread function returning
        -- and we should do a hthread_exit instead.
        case dob(16 to 31) is
        when x"0000" =>
          -- This is the return call for the main thread function
          -- Need to set up the stack and state as it would appear 
          -- if the user called hthread_exit directly.
          enb <= '1';
          web <= '1';
          dib <= fromUserReg_value;
          addrb <= stackPtr(1 to 13);
          paramCount_next <= paramCount + 1;
          stackPtr_next <= '0' & (stackPtr(1 to 13) + 1) & "00";
          system_request_next <= CHANGE_STATUS_TO_EXIT;
          user_state_next <= HTHREAD_EXIT;
        when others =>
          -- This is an user defined function returning
          -- set the return state of the HWTUL
          reg1_next <= dob; -- store return address temp in reg1
          -- read the number of parameters that were involved in this function
          addrb <= framePtr(1 to 13) - 3;
          enb <= '1';
          user_state_next <= WAIT_ONE_CYCLE;
          user_return_state_next <= USER_FUNCTION_RETURN_2;
        end case;

      when USER_FUNCTION_RETURN_2 =>
        -- set the stack pointer
        -- data coming off of the BRAM is number of params from previous function
        stackPtr_next <= '0' & ((framePtr(1 to 13) - 3) - dob(19 to 31)) & "00";
        -- read the frame pointer return address
        addrb <= framePtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= USER_FUNCTION_RETURN_3;

      when USER_FUNCTION_RETURN_3 =>
        -- set the frame pointer
        framePtr_next <= dob(16 to 31);
        -- tell the user to start running again.
        intrfc2thrd_function <= reg1(16 to 31);
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- USER FUNCTION_CALL
-- States are used when the HWTUL calls a function it has defined
-- or indirectly for a remote procedural call
-----------------------------------------------------------------------
      when USER_FUNCTION_CALL =>
        -- write the frame pointer to the stack
        addrb <= stackPtr(1 to 13);
        dib <= C_BASEADDR(0 to 15) & framePtr;
        web <= '1';
        enb <= '1';
        -- increment the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) + 1) & "00";
        user_state_next <= USER_FUNCTION_CALL_2;

      when USER_FUNCTION_CALL_2 =>
        -- write the return state, for the HWTUL, to the stack
        addrb <= stackPtr(1 to 13);
        dib <= Z32(0 to 15) & fromUserReg_value(16 to 31);
        web <= '1';
        enb <= '1';
        -- update the stack and frame ptr
        stackPtr_next <= '0' & (stackPtr(1 to 13) + 1) & "00";
        framePtr_next <= '0' & (stackPtr(1 to 13) + 1) & "00";
        -- Tell the HWTUL to run again, starting at the new function address
        intrfc2thrd_function <= fromUserReg_function;
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- Remote Procedural Call
-- May perform any action the software rpc thread is set up to accept
-- An RPC is a function call that the HWTI can not implement directly,
-- instead it has to call a software thread to do the work for it.
-- The SW thread is called through mutex & condition variable signalling.
-- reg1 = opcode
-- reg2 = mutex and condvar numbers, held in REG_RPC_MUTEXCONVAR
--        0 to 0   unused
--        8 to 15  rpc_mutex, protects the rpc thread
--        16 to 23 rpc_signal_mutex, protects the rpc condvar
--        24 to 31 rpc_signal, condvar
-- reg3 = rpc struct address, held in REG_RPC_T_ADDRESS
-- reg4 = temp
-----------------------------------------------------------------------
      when HTHREAD_RPC =>
        -- Store the value of the rpc mutexconvar to reg2
        reg2_next <= dob;
        -- Read the value of the rpc struct address
        addrb <= REG_RPC_T_ADDRESS(1 to 13);
        dib <= Z32(0 to 15) & fromUserReg_value(16 to 31);
        enb <= '1';
        -- Set up reg4 to hold the the rpc_mutex number
        reg4_next <= Z32(0 to 23) & dob(8 to 15);
        user_return_state_next <= HTHREAD_RPC_2;
        user_state_next <= WAIT_ONE_CYCLE;

      -- hthread_mutex_lock( rpc_mutex );
      when HTHREAD_RPC_2 =>
        -- Store the value of rpc struct address to reg3
        reg3_next <= dob;
        -- Read the register, on the mutex manager, to lock rpc_mutex
        data_address_next <= synch_lockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_RPC_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_3 =>
        -- Determine if we got the lock or not
        -- Possible return values are
        -- if bit(0)==1 then deadlock
        -- if bit(1)==1 then another thread has the lock
        -- else we have the lock
        case data_value(0 to 1) is
          when "10" =>
            --Return an error code to the user
            intrfc2thrd_value <= x"00000001";
            toUser_value_next <= x"00000001";
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
           wr  <= '1';
            user_state_next <= RUNNING;
          when "01" =>
            system_request_next <= CHANGE_STATUS_TO_BLOCK;
            user_state_next <= HTHREAD_RPC_3a;
          when others =>
            --The Lock is ours
            user_state_next <= HTHREAD_RPC_5;
        end case;

      when HTHREAD_RPC_3a =>
        --Wait for the system_stutus to change to BLOCKED
        case system_status is
          when SYSTEM_STATUS_BLOCKED =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_RPC_4;
          when others =>
            user_state_next <= HTHREAD_RPC_3a;
        end case;

      when HTHREAD_RPC_4 =>
        --Wait for a run command
        case system_command is
          when SYSTEM_COMMAND_RUN =>
            user_state_next <= HTHREAD_RPC_5;
            system_request_next <= CHANGE_STATUS_TO_RUN;
          when others =>
            user_state_next <= HTHREAD_RPC_4;
        end case;

      when HTHREAD_RPC_5 =>
        --Wait till status is RUNNING 
        --NOTE: status should already be running if we got the lock in RPC_3
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            user_state_next <= HTHREAD_RPC_6;
            system_request_next <= NOOP;
            -- Set up reg4 to hold the the rpc_signal_mutex number
            reg4_next <= Z32(0 to 23) & reg2(16 to 23);
          when others =>
            user_state_next <= HTHREAD_RPC_5;
        end case;

      -- hthread_mutex_lock( rpc_signal_mutex );
      when HTHREAD_RPC_6 =>
        -- Read the register, on the mutex manager, to lock rpc_signal_mutex
        data_address_next <= synch_lockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_RPC_7;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_7 =>
        -- Determine if we got the lock or not
        -- Possible return values are
        -- if bit(0)==1 then deadlock
        -- if bit(1)==1 then another thread has the lock
        -- else we have the lock
        case data_value(0 to 1) is
          when "10" =>
            --Return an error code to the user
            intrfc2thrd_value <= x"00000001";
            toUser_value_next <= x"00000001";
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
           wr  <= '1';
            user_state_next <= RUNNING;
          when "01" =>
            user_state_next <= HTHREAD_RPC_7a;
            system_request_next <= CHANGE_STATUS_TO_BLOCK;
          when others =>
            --The Lock is ours
            user_state_next <= HTHREAD_RPC_9;
        end case;

      when HTHREAD_RPC_7a =>
        --Wait for the system_stutus to change to BLOCKED
        case system_status is
          when SYSTEM_STATUS_BLOCKED =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_RPC_8;
          when others =>
            user_state_next <= HTHREAD_RPC_7a;
        end case;

      when HTHREAD_RPC_8 =>
        --Wait for a run command
        case system_command is
          when SYSTEM_COMMAND_RUN =>
            user_state_next <= HTHREAD_RPC_8a;
            system_request_next <= CHANGE_STATUS_TO_RUN;
          when others =>
            user_state_next <= HTHREAD_RPC_8;
        end case;

      when HTHREAD_RPC_8a =>
        --Wait till status is RUNNING 
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            user_state_next <= HTHREAD_RPC_9;
            system_request_next <= NOOP;
          when others =>
            user_state_next <= HTHREAD_RPC_8a;
        end case;

      --rpc->opcode = opcode
      when HTHREAD_RPC_9 =>
        --When we get to this point, the lock on rpc_mutex and rpc_signal_mutex is now ours
        --Write the value of the opcode to the struct
        data_address_next <= reg3;
        data_value_next <= reg1;
        user_return_state_next <= HTHREAD_RPC_10;
        user_state_next <= MASTER_STORE_INIT;
        --Set up reg4, for the next sequence of events.  Namely set it to 8, which is the
        --offset, from the base address of the rpc argument struct, to place the first parameter
        reg4_next <= x"00000008";

    --for( i=0; i<5; i++ ) rpc->args[i] = args[i]
      when HTHREAD_RPC_10 =>
        case paramCount is
          when x"00" =>
            -- have transfered all of the parameters to the rpc struct
            -- Set up reg4 to hold the the rpc_signal number
            reg4_next <= Z32(0 to 23) & reg2(24 to 31);
            user_state_next <= HTHREAD_RPC_12;
          when others =>
            -- have one or more parameters than need to be transfered
            -- read the parameter from the stack
            addrb <= stackPtr(1 to 13) - 1;
            enb <= '1';
            user_state_next <= WAIT_ONE_CYCLE;
            user_return_state_next <= HTHREAD_RPC_11;
            -- decrement the stackPtr
            stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";
        end case;

      when HTHREAD_RPC_11 =>
        -- store the parameter to the rpc struct
        data_address_next <= reg3(0 to 23) & (reg3(24 to 31) + reg4(24 to 31));
        data_value_next <= dob;
        user_return_state_next <= HTHREAD_RPC_10;
        user_state_next <= MASTER_STORE_INIT;
        -- increment reg4 by one word, ie 4 bytes
        reg4_next <= reg4 + 4;
        -- decrment paramCount
        paramCount_next <= paramCount - 1;

      when HTHREAD_RPC_12 =>
        -- hthread_cond_signal( rpc_signal );
        -- Read the register, on the cond var manager, to signal the next thread
        data_address_next <= C_CONVAR_MANAGER_BADDR or (   --base addr of cond var mgr
          "000000000000" &
          CONDVAR_CMD_SIGNAL &                             --bits(12 to 15) signal command
          "00000000" &                                     --bits(16 to 23) thread id
          reg4(26 to 31) &                                 --bits(24 to 29) con var number
          "00");                                           --bits(30 to 31) word addressing
        user_return_state_next <= HTHREAD_RPC_13;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_13 =>
        --Check the return status, repeat if attempt failed
        if ( data_value(28 to 31) = CONDVAR_FAILED ) then
          --repeat step 2
          user_state_next <= HTHREAD_RPC_12;
        else
          --The cond var, rpc_signal, is signaled
          -- Set up reg4 to hold condvar rpc_signal number
          reg4_next <= Z32(0 to 23) & reg2(24 to 31);
          user_state_next <= HTHREAD_RPC_14;
        end if;

      when HTHREAD_RPC_14 =>
        -- hthread_cond_wait( rpc_signal, rpc_signal_mutex)
        -- First step in waiting is to signal the wait
        -- Call to wait for cond variable signal
        data_address_next <= C_CONVAR_MANAGER_BADDR or (   --base addr of cond var mgr
          "000000000000" &
          CONDVAR_CMD_WAIT &                               --bits(12 to 15) broadcast command
          system_thread_id &                               --bits(16 to 23) thread id
          reg4(26 to 31) &                                 --bits(24 to 29) con var number
          "00");                                           --bits(30 to 31) word addressing
        user_return_state_next <= HTHREAD_RPC_15;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_15 =>
        -- Check return value, repeat if nessessary
        case data_value(28 to 31) is
          when CONDVAR_FAILED =>
            --repeat previous step
            user_state_next <= HTHREAD_RPC_14;
          when others =>
            system_request_next <= CHANGE_STATUS_TO_BLOCK;
            user_state_next <= HTHREAD_RPC_15a;
        end case;

      when HTHREAD_RPC_15a =>
        --Wait for the system_stutus to change to BLOCKED
        case system_status is
          when SYSTEM_STATUS_BLOCKED =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_RPC_16;
            --Set up reg4 to hold mutex rpc_signal_mutex number
            reg4_next <= Z32(0 to 23) & reg2(16 to 23);
          when others =>
            user_state_next <= HTHREAD_RPC_15a;
        end case;

      when HTHREAD_RPC_16 =>
        -- Second step in waiting is to release the mutex, this is the signal to the
        -- rest of the system that it is safe to issue hthread_signal or hthread_broadcast
        data_address_next <= synch_unlockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_RPC_17;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_17 =>
        --Wait for a run command, which is the signal that the rpc is done
        case system_command is
          when SYSTEM_COMMAND_RUN =>
            system_request_next <= CHANGE_STATUS_TO_RUN;
            user_state_next <= HTHREAD_RPC_17a;
          when others =>
            user_state_next <= HTHREAD_RPC_17;
        end case;

      when HTHREAD_RPC_17a =>
        --Wait till status is RUNNING 
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            user_state_next <= HTHREAD_RPC_18;
            system_request_next <= NOOP;
            --Set up reg4 to hold mutex rpc_signal_mutex number
            reg4_next <= Z32(0 to 23) & reg2(16 to 23);
          when others =>
            user_state_next <= HTHREAD_RPC_17a;
        end case;

      when HTHREAD_RPC_18 =>
        -- Last step in waiting is to relock the rpc_signal_mutex
        -- Read the register, on the mutex manager, to lock rpc_signal_mutex
        data_address_next <= synch_lockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_RPC_19;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_19 =>
        -- Determine if we got the lock or not
        -- Possible return values are
        -- if bit(0)==1 then deadlock
        -- if bit(1)==1 then another thread has the lock
        -- else we have the lock
        case data_value(0 to 1) is
          when "10" =>
            --Return an error code to the user
            intrfc2thrd_value <= x"00000001";
            toUser_value_next <= x"00000001";
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
           wr  <= '1';
            user_state_next <= RUNNING;
          when "01" =>
            system_request_next <= CHANGE_STATUS_TO_BLOCK;
            user_state_next <= HTHREAD_RPC_19a;
          when others =>
            --The Lock is ours
            user_state_next <= HTHREAD_RPC_21;
        end case;

      when HTHREAD_RPC_19a =>
        --Wait for the system_stutus to change to BLOCKED
        case system_status is
          when SYSTEM_STATUS_BLOCKED =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_RPC_20;
          when others =>
            user_state_next <= HTHREAD_RPC_19a;
        end case;

      when HTHREAD_RPC_20 =>
        --Wait for a run command, which is the signal that the lock is ours
        case system_command is
          when SYSTEM_COMMAND_RUN =>
            system_request_next <= CHANGE_STATUS_TO_RUN;
            user_state_next <= HTHREAD_RPC_20a;
          when others =>
            user_state_next <= HTHREAD_RPC_20;
        end case;

      when HTHREAD_RPC_20a =>
        --Wait for the system_stutus to change to BLOCKED
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_RPC_21;
          when others =>
            user_state_next <= HTHREAD_RPC_20a;
        end case;

      when HTHREAD_RPC_21 =>
        --read the result from the rpc struct
        data_address_next <= reg3 + 4;
        user_return_state_next <= HTHREAD_RPC_22;
        user_state_next <= MASTER_LOAD_INIT;
        --set up reg4 to hold the rpc_signal_mutex
        reg4_next <= Z32(0 to 23) & reg2(16 to 23);
        --change status to RUNNING
        system_request_next <= CHANGE_STATUS_TO_RUN;

      when HTHREAD_RPC_22 =>
        --store the result in reg1
        reg1_next <= data_value;
        -- hthread_mutex_unlock( rpc_signal_mutex );
        -- Read the register, on the mutex manager, to unlock the specified mutex
        data_address_next <= synch_unlockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_RPC_23;
        user_state_next <= MASTER_LOAD_INIT;
        --set up reg4 to hold the rpc_mutex
        reg4_next <= Z32(0 to 23) & reg2(8 to 15);

      when HTHREAD_RPC_23 =>
        -- hthread_mutex_unlock( rpc_mutex );
        -- Read the register, on the mutex manager, to unlock the specified mutex
        data_address_next <= synch_unlockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_RPC_24;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_RPC_24 =>
        system_request_next <= NOOP;
        -- Return the results to the user
        intrfc2thrd_value <= reg1;
        toUser_value_next <= reg1;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- HTHREAD_ATTR_INIT
-- Hint hthread_attr_init( hthread_attr_t * attr )
-- Hint hthread_attr_destroy( hthread_attr_t * attr )
-- sets the attributes, of the passed in pointer to a thread attribute
--  to their default values.  Both the init and destroy functions
--  work the same
-- Always returns an SUCCESS
-- reg1 will hold address of attr
-----------------------------------------------------------------------
      when HTHREAD_ATTR_INIT =>
        reg1_next <= dob;
        --write a Hfalse, a 0, to attr->detached
        data_address_next <= dob;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_ATTR_INIT_2;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_ATTR_INIT_2 =>
        --write a Hfalse, a 0, to attr->hardware
        data_address_next <= reg1 + 4;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_ATTR_INIT_3;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_ATTR_INIT_3 =>
        --write a 0, to attr->hardware_addr
        data_address_next <= reg1 + 8;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_ATTR_INIT_4;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_ATTR_INIT_4 =>
        --write a HT_DEFAULT_STACK_SIZE, 16 * 1024,, to attr->stack_size
        data_address_next <= reg1 + 12;
        data_value_next <= x"00004000";
        user_return_state_next <= HTHREAD_ATTR_INIT_5;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_ATTR_INIT_5 =>
        --write a NULL, a 0, to attr->stack_addr
        data_address_next <= reg1 + 16;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_ATTR_INIT_6;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_ATTR_INIT_6 =>
        --write a 64 priority, to attr->sched_param
        data_address_next <= reg1 + 20;
        data_value_next <= x"00000020";
        user_return_state_next <= HTHREAD_ATTR_INIT_7;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_ATTR_INIT_7 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;
          
-----------------------------------------------------------------------
-- HTHREAD_EQUAL
-- Hint hthread_equal( hthread_t t1, hthread_2 t2 )
-- tests to see if t1 is equal to t2
-- return values are 1 if t1 == t2, else 0
-- reg1 will hold t1
-----------------------------------------------------------------------
      when HTHREAD_EQUAL =>
        reg1_next <= dob;
        -- Read the value of t2
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= HTHREAD_EQUAL_2;
        -- Reset the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 2) & "00";        
        -- Reset number of parameters
        paramCount_next <= x"00";

      when HTHREAD_EQUAL_2 =>
        --Check to see if the two thread ids are equal
        if ( dob(24 to 31) = reg1(24 to 31) ) then
          intrfc2thrd_value <= Z32(0 to 30) & '1';
          toUser_value_next <= Z32(0 to 30) & '1';
        else
          intrfc2thrd_value <= Z32;
          toUser_value_next <= Z32;
        end if;
        -- Tell the HWTUL to run again, starting at the new function address
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- HTHREAD_CONDATTR_INIT
-- hthread_condattr_init( condattr_t * )
-- Initializes the condattr struct to default values
-----------------------------------------------------------------------
      when HTHREAD_CONDATTR_INIT =>
        reg1_next <= dob;
        -- Write a 0, the default condvar number, to the condattr_t.num
        data_address_next <= dob;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_CONDATTR_INIT_2;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_CONDATTR_INIT_2 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- HTHREAD_COND_INIT
-- hthread_cond_init( cond_t *, hthread_condattr_t*)
-- Creates a condition variable based on either the default attributes, 
--  if condattr_t is NULL, or on condattr_t.
-----------------------------------------------------------------------
      when HTHREAD_COND_INIT =>
        -- Store the address of the condvar in reg1;
        reg1_next <= dob;
        -- Read the address, that the use passed in, of condattr_t
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= HTHREAD_COND_INIT_2;
        -- Reset the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 2) & "00";        
        -- Reset number of parameters
        paramCount_next <= x"00";

      when HTHREAD_COND_INIT_2 =>
        -- Store the address of condattr in reg2;
        reg2_next <= dob;
        -- Determine if the attributes are NULL or not
        case dob is
          when Z32 =>
            -- Create a condition variable with default attributes
            reg3_next <= Z32; --condvar number 0
            user_state_next <= HTHREAD_COND_INIT_5;
          when OTHERS =>
            user_state_next <= HTHREAD_COND_INIT_3;
        end case;

      when HTHREAD_COND_INIT_3 =>
        -- Read the value of the attr's num
        data_address_next <= reg2;
        user_return_state_next <= HTHREAD_COND_INIT_4;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_INIT_4 =>
        -- Store the value of attr's num in reg3
        reg3_next <= data_value;
        user_state_next <= HTHREAD_COND_INIT_5;

      when HTHREAD_COND_INIT_5 =>
        -- Write the condvar's num
        data_address_next <= reg1;
        data_value_next <= reg3;
        user_return_state_next <= HTHREAD_COND_INIT_6;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_COND_INIT_6 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- FUNCTION_HTHREAD_COND_WAIT
-- hthread_cond_broadcast( hthread_cond_t *cond, hthread_mutex_t *mutex )
-- Unlocks *mutex, waits for a signal from *cond, relocks *mutex
-----------------------------------------------------------------------
      when HTHREAD_COND_WAIT =>
        -- reg1 will hold address of condition variable
        reg1_next <= dob;
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= HTHREAD_COND_WAIT_2;
        -- Reset number of parameters
        paramCount_next <= x"00";
        -- decrement the stack pointer 
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 2) & "00";

      when HTHREAD_COND_WAIT_2 =>
        -- reg2 will hold address of mutex 
        reg2_next <= dob;
        -- Initiate read of the cond var number
        data_address_next <= reg1;
        user_return_state_next <= HTHREAD_COND_WAIT_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_WAIT_3 =>
        -- reg3 will hold cond var number
        reg3_next <= data_value;
        -- Initiate read of the mutex number
        data_address_next <= reg2;
        user_return_state_next <= HTHREAD_COND_WAIT_4;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_WAIT_4 =>
        -- reg4 will hold mutex number
        reg4_next <= data_value;
        -- Call to wait for cond variable signal
        data_address_next <= C_CONVAR_MANAGER_BADDR or (   --base addr of cond var mgr
          "000000000000" &
          CONDVAR_CMD_WAIT &                               --bits(12 to 15) broadcast command
          system_thread_id &                               --bits(16 to 23) thread id
          reg3(26 to 31) &                                 --bits(24 to 29) con var number
          "00");                                           --bits(30 to 31) word addressing
        user_return_state_next <= HTHREAD_COND_WAIT_5;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_WAIT_5 =>
        -- Check return value, if successful unlock the mutex
        if ( data_value(28 to 31) = CONDVAR_FAILED ) then
          --repeat previous step
          user_state_next <= HTHREAD_COND_WAIT_4;
        else
          user_state_next <= HTHREAD_COND_WAIT_6;
		  -- Change status to BLOCKED while waiting on condvar
          system_request_next <= CHANGE_STATUS_TO_BLOCK;
        end if;

      when HTHREAD_COND_WAIT_6 =>
        -- Wait till status changes to blocked
        case system_status is
          when SYSTEM_STATUS_BLOCKED =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_COND_WAIT_7;
          when others =>
            user_state_next <= HTHREAD_COND_WAIT_6;
        end case;

      when HTHREAD_COND_WAIT_7 =>
        -- Call to unlock the mutex
        data_address_next <= synch_unlockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          reg4(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_COND_WAIT_7a;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_WAIT_7a =>
        --Wait for a run command, which is the signal another thread sent to us
        case system_command is
          when SYSTEM_COMMAND_RUN =>
            system_request_next <= CHANGE_STATUS_TO_RUN;
            user_state_next <= HTHREAD_COND_WAIT_8;
          when others =>
            user_state_next <= HTHREAD_COND_WAIT_7a;
        end case;

      when HTHREAD_COND_WAIT_8=>
        --Wait for the system state machine to update the status
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            --We've been signaled to continue, before returning, relock the mutex
            --Note that I'm tranfering control to the mutex lock state machine
            data_address_next <= synch_lockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
              C_OPB_DWIDTH,                                    -- number of bits for data bus
              MUTEX_BITS,                                      -- number of bits for mutex id
              THREAD_BITS,
              COUNT_BITS,
              system_thread_id(8 - THREAD_BITS to 7),
              data_value(32 - MUTEX_BITS to 31) );
            user_return_state_next <= HTHREAD_MUTEX_LOCK_3;
            user_state_next <= MASTER_LOAD_INIT;
          when others =>
            user_state_next <= HTHREAD_COND_WAIT_8;
        end case;

-----------------------------------------------------------------------
-- FUNCTION_HTHREAD_COND_BCAST
-- hthread_cond_broadcast( hthread_cond_t *cond )
-- Broadcasts, via the condition varable manager, all
-- threads waiting on cond
-----------------------------------------------------------------------
      when HTHREAD_COND_BCAST =>
        data_address_next <= dob;
        -- Read the value of the cond var number
        user_return_state_next <= HTHREAD_COND_BCAST_2;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_BCAST_2 =>
        -- Store the cond variable in reg1
        reg1_next <= data_value;
        -- Read the register, on the cond var manager, to signal the next thread
        data_address_next <= C_CONVAR_MANAGER_BADDR or (   --base addr of cond var mgr
          "000000000000" &
          CONDVAR_CMD_BCAST &                              --bits(12 to 15) broadcast command
          "00000000" &                                     --bits(16 to 23) thread id
          data_value(26 to 31) &                           --bits(24 to 29) con var number
          "00");                                           --bits(30 to 31) word addressing
        user_return_state_next <= HTHREAD_COND_BCAST_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_BCAST_3 =>
        --Check the return status, repeat of attempt failed
        if ( data_value(28 to 31) = CONDVAR_FAILED ) then
          --restore value of the data value register
          data_value_next <= reg1;
          --repeat step 2
          user_state_next <= HTHREAD_COND_BCAST_2;
        else
          --The cond var is signaled, return a SUCCESS to the user
          intrfc2thrd_value <= Z32;
          toUser_value_next <= Z32;
          intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
          intrfc2thrd_goWait <= '1';
           wr  <= '1';
          user_state_next <= RUNNING;
        end if;

-----------------------------------------------------------------------
-- FUNCTION_HTHREAD_COND_SIGNAL
-- hthread_cond_signal( hthread_cond_t *cond )
-- Signals, via the condition varable manager, the highest priority
-- thread waiting on cond
-----------------------------------------------------------------------
      when HTHREAD_COND_SIGNAL =>
        data_address_next <= dob;
        -- Read the value of the cond var number
        user_return_state_next <= HTHREAD_COND_SIGNAL_2;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_SIGNAL_2 =>
        -- Store the cond variable in reg1
        reg1_next <= data_value;
        -- Read the register, on the cond var manager, to signal the next thread
        data_address_next <= C_CONVAR_MANAGER_BADDR or (   --base addr of cond var mgr
          "000000000000" &
          CONDVAR_CMD_SIGNAL &                             --bits(12 to 15) signal command
          "00000000" &                                     --bits(16 to 23) thread id
          data_value(26 to 31) &                           --bits(24 to 29) con var number
          "00");                                           --bits(30 to 31) word addressing
        user_return_state_next <= HTHREAD_COND_SIGNAL_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_COND_SIGNAL_3 =>
        --Check the return status, repeat of attempt failed
        if ( data_value(28 to 31) = CONDVAR_FAILED ) then
          --restore value of the data value register
          data_value_next <= reg1;
          --repeat step 2
          user_state_next <= HTHREAD_COND_SIGNAL_2;
        else
          --The cond var is signaled, return a SUCCESS to the user
          intrfc2thrd_value <= Z32;
          toUser_value_next <= Z32;
          intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
          intrfc2thrd_goWait <= '1';
           wr  <= '1';
          user_state_next <= RUNNING;
        end if;

-----------------------------------------------------------------------
-- HTHREAD_MUTEXATTR_SETNUM and HTHREAD_CONDATTR_SETNUM
-- hthread_mutexattr_getnum( mutexattr_t *, int num)
-- hthread_condattr_setnum( condattr_t *, int num)
-- Sets the value of mutexattr number to num
--  or sets the value of condattr number to num
-- Reusing these states work, because in both the case for the mutexattr
-- and the condattr struct, the first element in the struct is the 
-- mutex/condvariable number.
-----------------------------------------------------------------------
      when HTHREAD_MUTEXATTR_SETNUM =>
        -- store the value of the address of mutexattr_t in reg1
        reg1_next <= dob;
        -- Read the second parameter the user pushed, the new value of the mutex number
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= HTHREAD_MUTEXATTR_SETNUM_2;
        -- Reset the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 2) & "00";        
        -- Reset number of parameters
        paramCount_next <= x"00"; 

      when HTHREAD_MUTEXATTR_SETNUM_2 =>
        -- Store the dob (value of num) to mutexattr
        data_value_next <= dob;
        data_address_next <= reg1;
        user_return_state_next <= HTHREAD_MUTEXATTR_SETNUM_3;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_MUTEXATTR_SETNUM_3 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- HTHREAD_MUTEXATTR_GETNUM and HTHREAD_CONDATTR_GETNUM
-- hthread_mutexattr_getnum( mutexattr_t *, int* num)
-- hthread_condattr_getnum( condattr_t *, int* num)
-- Gets the value of *num to the value of the mutexattr number
--  or gets the value of condattr number to num
-- Reusing these states work, because in both the case for the mutexattr
-- and the condattr struct, the first element in the struct is the 
-- mutex/condvariable number.
-----------------------------------------------------------------------
      when HTHREAD_MUTEXATTR_GETNUM =>
        -- store the value of the address of mutexattr_t in reg1
        reg1_next <= dob;
        -- Read the second parameter the user pushed, address to store the mutex number to
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= HTHREAD_MUTEXATTR_GETNUM_2;
        -- Reset the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 2) & "00";        
        -- Reset number of parameters
        paramCount_next <= x"00";        

      when HTHREAD_MUTEXATTR_GETNUM_2 =>
        -- store the value of the address of num in reg2
        reg2_next <= dob;
        -- Load the value of the mutex number
        data_address_next <= reg1;
        user_return_state_next <= HTHREAD_MUTEXATTR_GETNUM_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEXATTR_GETNUM_3 =>
        -- Store the value we just read, to the num passed by the user
        data_value_next <= data_value;
        data_address_next <= reg2;
        user_return_state_next <= HTHREAD_MUTEXATTR_GETNUM_4;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_MUTEXATTR_GETNUM_4 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;        

-----------------------------------------------------------------------
-- HTHREAD_MUTEXATTR_INIT
-- hthread_mutexattr_init( mutexattr_t * )
-- Initializes the mutexattr struct to default values
-----------------------------------------------------------------------
      when HTHREAD_MUTEXATTR_INIT =>
        reg1_next <= dob;
        -- Write a 0, the default mutex number, to the mutexattr_t.num
        data_address_next <= dob;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_MUTEXATTR_INIT_2;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_MUTEXATTR_INIT_2 =>
        -- Write a HTHREAD_MUTEX_DEFAULT, the default mutex type, to the mutexattr_t.type
        data_address_next <= reg1 + 4;
        data_value_next <= Z32;
        user_return_state_next <= HTHREAD_MUTEXATTR_INIT_3;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_MUTEXATTR_INIT_3 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- HTHREAD_MUTEX_INIT
-- hthread_mutex_init( mutex_t *, hthread_mutexattr_t*)
-- Creates a mutex based on either the default attributes, if mutexattr_t
--  is NULL, or on mutexattr_t.
-----------------------------------------------------------------------
      when HTHREAD_MUTEX_INIT =>
        -- Store the address of the mutex in reg1;
        reg1_next <= dob;
        -- Read the address, that the use passed in, of mutexattr_t
        addrb <= stackPtr(1 to 13) - 2;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= HTHREAD_MUTEX_INIT_2;
        -- Reset the stack pointer
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 2) & "00";        
        -- Reset number of parameters
        paramCount_next <= x"00";

      when HTHREAD_MUTEX_INIT_2 =>
        -- Store the address of mutexattr in reg2;
        reg2_next <= dob;
        -- Determine if the attributes are NULL or not
        case dob is
          when Z32 =>
            -- Create a mutex with default attributes
            reg3_next <= Z32; --mutex number 0
            reg4_next <= Z32; --HTHREAD_MUTEX_DEFAULT
            data_value_next <= Z32; --to conserve a state, i'm cheating and setting 
            -- data_value here.  reg4 gets overwriten in MUTEX_INIT_5
            user_state_next <= HTHREAD_MUTEX_INIT_5;
          when OTHERS =>
            user_state_next <= HTHREAD_MUTEX_INIT_3;
        end case;

      when HTHREAD_MUTEX_INIT_3 =>
        -- Read the value of the attr's num
        data_address_next <= reg2;
        user_return_state_next <= HTHREAD_MUTEX_INIT_4;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_INIT_4 =>
        -- Store the value of attr's num in reg3
        reg3_next <= data_value;
        -- Read the value of the attr's type
        data_address_next <= reg2 + 4;
        user_return_state_next <= HTHREAD_MUTEX_INIT_5;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_INIT_5 =>
        -- Store the value of the attr's type in reg4
        reg4_next <= data_value;
        -- Write the mutex's num
        data_address_next <= reg1;
        data_value_next <= reg3;
        user_return_state_next <= HTHREAD_MUTEX_INIT_6;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_MUTEX_INIT_6 =>
        -- Write the mutex's type
        data_address_next <= reg1 + 4;
        data_value_next <= reg4;
        user_return_state_next <= HTHREAD_MUTEX_INIT_7;
        user_state_next <= MASTER_STORE_INIT;

      when HTHREAD_MUTEX_INIT_7 =>
        -- Return a SUCCESS to the user;
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- HTHREAD_MUTEX_UNLOCK
-- hthread_mutex_unlock( mutex_t * )
-- Locks the mutex specified by *mutex_t
-----------------------------------------------------------------------
      when HTHREAD_MUTEX_UNLOCK =>
        data_address_next <= dob;
        -- Read the value of the mutex number
        user_return_state_next <= HTHREAD_MUTEX_UNLOCK_2;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_UNLOCK_2 =>
        -- Read the register, on the mutex manager, to unlock the specified mutex
        data_address_next <= synch_unlockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          data_value(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_MUTEX_UNLOCK_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_UNLOCK_3 =>
        --The Lock is released, return a SUCCESS to the user
        intrfc2thrd_value <= Z32;
        toUser_value_next <= Z32;
        intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- FUNCTION_HTHREAD_MUTEX_TRYLOCK
-- hthread_mutex_trylock( mutex_t * )
-- Locks the mutex specified by *mutex_t
-----------------------------------------------------------------------
      when HTHREAD_MUTEX_TRYLOCK =>
        data_address_next <= dob;
        -- Read the value of the mutex number
        user_return_state_next <= HTHREAD_MUTEX_TRYLOCK_2;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_TRYLOCK_2 =>
        -- Read the register, on the mutex manager, to lock the specified mutex
        data_address_next <= synch_trylockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          data_value(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_MUTEX_TRYLOCK_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_TRYLOCK_3 =>
        -- Determine if we got the lock or not
        -- Possible return values are
        -- if bit(0)==1 then deadlock
        -- if bit(1)==1 then another thread has the lock
        -- else we have the lock
        case data_value(0 to 1) is
          when "10" =>
            --Return an error code to the user
            intrfc2thrd_value <= x"00000001";
            toUser_value_next <= x"00000001";
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
           wr  <= '1';
            user_state_next <= RUNNING;
          when "01" =>
            --Did not get the LOCK, 
            intrfc2thrd_value <= x"00000001";
            toUser_value_next <= x"00000001";
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
           wr  <= '1';
            user_state_next <= RUNNING;
          when others =>
            --The Lock is ours, return a SUCCESS to the user
            intrfc2thrd_value <= Z32;
            toUser_value_next <= Z32;
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
           wr  <= '1';
            user_state_next <= RUNNING;
        end case;

-----------------------------------------------------------------------
-- FUNCTION_HTHREAD_MUTEX_LOCK
-- hthread_mutex_lock( mutex_t * )
-- Locks the mutex specified by *mutex_t
-----------------------------------------------------------------------
      when HTHREAD_MUTEX_LOCK =>
        data_address_next <= dob;
        -- Read the value of the mutex number
        user_return_state_next <= HTHREAD_MUTEX_LOCK_2;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_LOCK_2 =>
        -- Read the register, on the mutex manager, to lock the specified mutex
        data_address_next <= synch_lockcmd( C_MUTEX_MANAGER_BADDR,--base address of synch manager
          C_OPB_DWIDTH,                                    -- number of bits for data bus
          MUTEX_BITS,                                      -- number of bits for mutex id
          THREAD_BITS,
          COUNT_BITS,
          system_thread_id(8 - THREAD_BITS to 7),
          data_value(32 - MUTEX_BITS to 31) );
        user_return_state_next <= HTHREAD_MUTEX_LOCK_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_MUTEX_LOCK_3 =>
        -- Determine if we got the lock or not
        -- Possible return values are
        -- if bit(0)==1 then deadlock
        -- if bit(1)==1 then another thread has the lock
        -- else we have the lock
        case data_value(0 to 1) is
          when "10" =>
            --Return an error code to the user
            intrfc2thrd_value <= x"00000001";
            toUser_value_next <= x"00000001";
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;
          when "01" =>
            --Change status to block, then wait for a RUN command
            system_request_next <= CHANGE_STATUS_TO_BLOCK;
            user_state_next <= HTHREAD_MUTEX_LOCK_4;
          when others =>
            --The Lock is ours, return a SUCCESS to the user
            intrfc2thrd_value <= Z32;
            toUser_value_next <= Z32;
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;
        end case;

      when HTHREAD_MUTEX_LOCK_4 =>
        --Wait for the system_stutus to change to BLOCKED
        case system_status is
          when SYSTEM_STATUS_BLOCKED =>
            system_request_next <= NOOP;
            user_state_next <= HTHREAD_MUTEX_LOCK_5;
          when others =>
            user_state_next <= HTHREAD_MUTEX_LOCK_4;
        end case;

      when HTHREAD_MUTEX_LOCK_5 =>
        --Wait for a run command
        case system_command is
          when SYSTEM_COMMAND_RUN =>
          --TODO check to see if the lock is ours, or if this was a random RUN command
            system_request_next <= CHANGE_STATUS_TO_RUN;
            user_state_next <= HTHREAD_MUTEX_LOCK_6;
          when others =>
            user_state_next <= HTHREAD_MUTEX_LOCK_5;
        end case;

      when HTHREAD_MUTEX_LOCK_6 =>
        case system_status is
          when SYSTEM_STATUS_RUNNING =>
            system_request_next <= NOOP;
            --The lock is now ours, return a SUCCESS to the user
            intrfc2thrd_value <= Z32;
            toUser_value_next <= Z32;
            intrfc2thrd_function <= fromUserReg_value( 16 to 31 );
            intrfc2thrd_goWait <= '1';
            wr  <= '1';
            user_state_next <= RUNNING;
          when others =>
            user_state_next <= HTHREAD_MUTEX_LOCK_6;
        end case;

-----------------------------------------------------------------------
-- FUNCTION_HTHREAD_EXIT, EXIT_ERROR, OVERFLOW
-- Calls the exit_thread API on the thread manager.  Once the thread
-- manager returns, wait until the HWTI receives a RESET signal.
-----------------------------------------------------------------------
      when HTHREAD_EXIT =>
        -- Initiate the call to the thread manager
        data_address_next <= thread_manager_exit_thread_address( C_THREAD_MANAGER_BADDR, C_OPB_AWIDTH, THREAD_BITS, system_thread_id );
        user_return_state_next <= HTHREAD_EXIT_2;
        user_state_next <= MASTER_LOAD_INIT;
        -- Simotaneously, read the parameter that the user pushed to the stack
        addrb <= stackPtr(1 to 13) - 1;
        enb <= '1';

      when OVERFLOW =>
        -- Stack and heap overflow was detected
        data_address_next <= thread_manager_exit_thread_address( C_THREAD_MANAGER_BADDR, C_OPB_AWIDTH, THREAD_BITS, system_thread_id );
        system_request_next <= CHANGE_STATUS_TO_EXIT_OVERFLOW;
        user_return_state_next <= HTHREAD_EXIT_3;
        user_state_next <= MASTER_LOAD_INIT;

      when HTHREAD_EXIT_2 =>
        -- Read the argument
        system_result_next <= dob;
        -- Decrement the stack for good measure
        paramCount_next <= x"00";
        stackPtr_next <= '0' & (stackPtr(1 to 13) - 1) & "00";
        user_state_next <= HTHREAD_EXIT_3;

      when HTHREAD_EXIT_3 =>
        case system_status is
          when SYSTEM_STATUS_EXITED =>
            system_request_next <= NOOP;
          when SYSTEM_STATUS_EXITED_ERROR =>
            system_request_next <= NOOP;
          when SYSTEM_STATUS_EXITED_OVERFLOW =>
            system_request_next <= NOOP;
          when others =>
            -- do nothing
        end case;
        user_state_next <= HTHREAD_EXIT_3;

-----------------------------------------------------------------------
-- Read the function call parameter from the stack, and return value
-- to user.
-----------------------------------------------------------------------
      when POP_READ_PARAM_COUNT =>
        -- Learn the number of parameters in the function call
        -- Make sure the user is not trying to exceed this number
        -- Start the read for the parameter
        if ( dob(24 to 31) > fromUserReg_value(24 to 31) ) then
          -- pop parameter is within known parameter count
          addrb <= ( framePtr(1 to 13) - fromUserReg_value(19 to 31) ) - 4 ;
          dib <= fromUser_value;
          enb <= '1';
          user_state_next <= WAIT_ONE_CYCLE;
          user_return_state_next <= POP_READ_PARAM;
        else
          -- pop parameter is outside known parameter count
          intrfc2thrd_value <= Z32;
          toUser_value_next <= Z32;
          intrfc2thrd_goWait <= '1';
           wr  <= '1';
          user_state_next <= RUNNING;
        end if;

      when POP_READ_PARAM =>
        -- return the value, and control, to the user thread
        intrfc2thrd_value <= dob;
        toUser_value_next <= dob;
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- Helper function to wait one clock cycle.  Returns to state
-- specified in return_state
-----------------------------------------------------------------------
      when WAIT_ONE_CYCLE =>
        -- Wait one clock cycle
        user_state_next <= user_return_state;

-----------------------------------------------------------------------
-- If the user is requesting a read that is not word-aligned, need
-- to do two reads, and return a concatenation of both.
-----------------------------------------------------------------------
      when LOCAL_PARTIAL_LOAD =>
        reg1_next <= dob;
        addrb <= fromUserReg_address(17 to 29) + 1;
        enb <= '1';
        user_state_next <= WAIT_ONE_CYCLE;
        user_return_state_next <= LOCAL_PARTIAL_LOAD_1;

      when LOCAL_PARTIAL_LOAD_1 =>
        case fromUserReg_address(30 to 31) is
          when "01" =>
            intrfc2thrd_value <= reg1(8 to 31) & dob(0 to 7);
            toUser_value_next <= reg1(8 to 31) & dob(0 to 7);
          when "10" =>
            intrfc2thrd_value <= reg1(16 to 31) & dob(0 to 15);
            toUser_value_next <= reg1(16 to 31) & dob(0 to 15);
          when OTHERS =>
            intrfc2thrd_value <= reg1(24 to 31) & dob(0 to 23);
            toUser_value_next <= reg1(24 to 31) & dob(0 to 23);
        end case;
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        user_state_next <= RUNNING;
        
        
-----------------------------------------------------------------------
-- Perform the remaning steps to read from BRAM.  Since we are trying
-- to make the operation as fast as possible, it has its own special
-- states.  And yes, I get to use this for both LOCAL_LOAD and 
-- LOCAL_READ.
-----------------------------------------------------------------------
      when LOCAL_LOAD_RESPOND =>
        -- Return the data from BRAM and tell HWTUL to GO
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        intrfc2thrd_value <= dob;
        toUser_value_next <= dob;
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- After the Read helper returns, this state is called, to return the
-- HWTUL to a running state.  Also note that this state is being used
-- as the return state for GLOBAL_STORE. why? because I can.
-----------------------------------------------------------------------
      when GLOBAL_LOAD_RETURN =>
        intrfc2thrd_goWait <= '1';
           wr  <= '1';
        intrfc2thrd_value <= data_value;
        toUser_value_next <= data_value;
        user_state_next <= RUNNING;

-----------------------------------------------------------------------
-- Read/load helper states
-- Performs a bus master read to data_address
-- After completion, returns to state user_return_state, data is in
-- data_value;
-----------------------------------------------------------------------
      when MASTER_LOAD_INIT =>
        -- Initiate read opperation
        IP2Bus_Addr <= data_address;
        IP2Bus_MstRdReq <= '1';
        IP2IP_Addr <= master_read_respond_address;
        user_state_next <= MASTER_LOAD_WAIT_FOR_ACK;

      when MASTER_LOAD_WAIT_FOR_ACK =>
        -- Persist with read operation until ACKed
        if ( Bus2IP_MstLastAck = '1'
          or Bus2IP_MstError = '1'
          or Bus2IP_MstTimeOut = '1' ) then
          IP2Bus_Addr <= (others=>'0');
          IP2Bus_MstRdReq <= '0';
          IP2IP_Addr <= (others=>'0');
          data_value_next <= Bus2IP_Data;
          --TODO catch an error and set a status to indicate error
          user_state_next <= user_return_state;
        else --ABA commented these
          IP2Bus_Addr <= data_address;
          IP2Bus_MstRdReq <= '1';
          IP2IP_Addr <= master_read_respond_address;
          user_state_next <= MASTER_LOAD_WAIT_FOR_ACK;
        end if;

---------------------------------------------------------
-- Write/store helper states
-- Perform a bus master write to data_address with data_value
---------------------------------------------------------
      when MASTER_STORE_INIT =>
        -- Initiate write opperation
        -- Note that the data_value gets set in the RUNNING state
        IP2Bus_Addr <= data_address;
        IP2Bus_MstWrReq <= '1';
        IP2IP_Addr <= master_write_respond_address;
        user_state_next <= MASTER_STORE_WAIT_FOR_ACK;

      when MASTER_STORE_WAIT_FOR_ACK =>
       -- Persist with write opperation until ACKed by bus
        if ( Bus2IP_MstLastAck = '1'
          or Bus2IP_MstError = '1'
          or Bus2IP_MstTimeOut = '1') then
          IP2Bus_Addr <= (others=>'0');
          IP2Bus_MstWrReq <= '0';
          IP2IP_Addr <= (others=>'0');
          user_state_next <= user_return_state;
        else
          IP2Bus_Addr <= data_address;
          IP2Bus_MstWrReq <= '1';
          IP2IP_Addr <= master_write_respond_address;
          user_state_next <= MASTER_STORE_WAIT_FOR_ACK;
        end if;

    end case;
  end process HWTI_USER_STATE_MACHINE;
end architecture IMP;
