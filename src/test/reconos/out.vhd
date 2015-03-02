library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--use work.common.all;

ENTITY user_logic_hwtul IS
  port (
    clock : in std_logic;
    intrfc2thrd_address : in std_logic_vector(0 to 31);
    intrfc2thrd_value : in std_logic_vector(0 to 31);
    intrfc2thrd_function : in std_logic_vector(0 to 15);
    intrfc2thrd_goWait : in std_logic;

    thrd2intrfc_address : out std_logic_vector(0 to 31);
    thrd2intrfc_value : out std_logic_vector(0 to 31);
    thrd2intrfc_function : out std_logic_vector(0 to 15);
    thrd2intrfc_opcode : out std_logic_vector(0 to 5)
  );
END ENTITY user_logic_hwtul;

ARCHITECTURE IMP OF user_logic_hwtul IS
  -- HWTI Declarations.

  -- Function definitions
  constant U_FUNCTION_RESET                      : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                       : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT                : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                      : std_logic_vector(0 to 15) := x"0003";
  -- Range 0003 to 7999 reserved for user logic's state machine
  -- Range 8000 to 9999 reserved for system calls
  -- constant FUNCTION_HTHREAD_ATTR_INIT          : std_logic_vector(0 to 15) := x"8000";
  -- constant FUNCTION_HTHREAD_ATTR_DESTROY       : std_logic_vector(0 to 15) := x"8001";
  -- constant FUNCTION_HTHREAD_CREATE             : std_logic_vector(0 to 15) := x"8010";
  -- constant FUNCTION_HTHREAD_JOIN               : std_logic_vector(0 to 15) := x"8011";
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
  constant FUNCTION_MALLOC                     : std_logic_vector(0 to 15) := x"A000";
  constant FUNCTION_CALLOC                     : std_logic_vector(0 to 15) := x"A001";
  constant FUNCTION_FREE                       : std_logic_vector(0 to 15) := x"A002";

  -- user_opcode Constants
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


  -- STATE DECLARATIONS
  constant START_STATE : std_logic_vector(0 to 15) := x"0004";
  constant WAIT_STATE : std_logic_vector(0 to 15) := x"0005";
  constant FUNCTCALL_STATE : std_logic_vector(0 to 15) := x"0006";
  constant BOOTSTRAP0 : std_logic_vector(0 to 15) := x"0007";
  constant BOOTSTRAP1 : std_logic_vector(0 to 15) := x"0008";
  constant mailbox_write_start : std_logic_vector(0 to 15) := x"0009";
  constant mailbox_write_save_0 : std_logic_vector(0 to 15) := x"000A";
  constant mailbox_write_save_1 : std_logic_vector(0 to 15) := x"000B";
  constant mailbox_write_save_2 : std_logic_vector(0 to 15) := x"000C";
  constant mailbox_write_save_3 : std_logic_vector(0 to 15) := x"000D";
  constant mailbox_write_save_4 : std_logic_vector(0 to 15) := x"000E";
  constant mailbox_write_15_0_0 : std_logic_vector(0 to 15) := x"000F";
  constant mailbox_write_15_0_1 : std_logic_vector(0 to 15) := x"0010";
  constant mailbox_write_15_1_0 : std_logic_vector(0 to 15) := x"0011";
  constant mailbox_write_15_1_1 : std_logic_vector(0 to 15) := x"0012";
  constant mailbox_write_15_2_0 : std_logic_vector(0 to 15) := x"0013";
  constant mailbox_write_15_3_0 : std_logic_vector(0 to 15) := x"0014";
  constant mailbox_write_15_4_0 : std_logic_vector(0 to 15) := x"0015";
  constant mailbox_write_15_4_1 : std_logic_vector(0 to 15) := x"0016";
  constant mailbox_write_15_4_2 : std_logic_vector(0 to 15) := x"0017";
  constant mailbox_write_15_5_0 : std_logic_vector(0 to 15) := x"0018";
  constant mailbox_write_15_5_1 : std_logic_vector(0 to 15) := x"0019";
  constant mailbox_write_15_6_0 : std_logic_vector(0 to 15) := x"001A";
  constant mailbox_write_15_6_1 : std_logic_vector(0 to 15) := x"001B";
  constant mailbox_write_15_7_0 : std_logic_vector(0 to 15) := x"001C";
  constant mailbox_write_16_0_0 : std_logic_vector(0 to 15) := x"001D";
  constant mailbox_write_17_0_0 : std_logic_vector(0 to 15) := x"001E";
  constant mailbox_write_18_0_0 : std_logic_vector(0 to 15) := x"001F";
  constant mailbox_write_18_1_0 : std_logic_vector(0 to 15) := x"0020";
  constant mailbox_write_18_1_1 : std_logic_vector(0 to 15) := x"0021";
  constant mailbox_write_18_1_2 : std_logic_vector(0 to 15) := x"0022";
  constant mailbox_write_18_1_3 : std_logic_vector(0 to 15) := x"0023";
  constant mailbox_write_18_2_0 : std_logic_vector(0 to 15) := x"0024";
  constant mailbox_write_18_2_1 : std_logic_vector(0 to 15) := x"0025";
  constant mailbox_write_18_3_0 : std_logic_vector(0 to 15) := x"0026";
  constant mailbox_write_18_4_0 : std_logic_vector(0 to 15) := x"0027";
  constant mailbox_write_18_4_1 : std_logic_vector(0 to 15) := x"0028";
  constant mailbox_write_18_5_0 : std_logic_vector(0 to 15) := x"0029";
  constant mailbox_write_19_0_0 : std_logic_vector(0 to 15) := x"002A";
  constant mailbox_write_20_0_0 : std_logic_vector(0 to 15) := x"002B";
  constant mailbox_write_21_0_0 : std_logic_vector(0 to 15) := x"002C";
  constant mailbox_write_21_0_1 : std_logic_vector(0 to 15) := x"002D";
  constant mailbox_write_21_1_0 : std_logic_vector(0 to 15) := x"002E";
  constant mailbox_write_21_2_0 : std_logic_vector(0 to 15) := x"002F";
  constant mailbox_write_21_2_1 : std_logic_vector(0 to 15) := x"0030";
  constant mailbox_write_21_3_0 : std_logic_vector(0 to 15) := x"0031";
  constant mailbox_write_21_3_1 : std_logic_vector(0 to 15) := x"0032";
  constant mailbox_write_21_4_0 : std_logic_vector(0 to 15) := x"0033";
  constant mailbox_write_21_5_0 : std_logic_vector(0 to 15) := x"0034";
  constant mailbox_write_21_6_0 : std_logic_vector(0 to 15) := x"0035";
  constant mailbox_write_21_7_0 : std_logic_vector(0 to 15) := x"0036";
  constant mailbox_write_21_7_1 : std_logic_vector(0 to 15) := x"0037";
  constant mailbox_write_21_8_0 : std_logic_vector(0 to 15) := x"0038";
  constant mailbox_write_21_9_0 : std_logic_vector(0 to 15) := x"0039";
  constant mailbox_write_21_9_1 : std_logic_vector(0 to 15) := x"003A";
  constant mailbox_write_21_10_0 : std_logic_vector(0 to 15) := x"003B";
  constant mailbox_write_21_10_1 : std_logic_vector(0 to 15) := x"003C";
  constant mailbox_write_21_11_0 : std_logic_vector(0 to 15) := x"003D";
  constant mailbox_write_21_12_0 : std_logic_vector(0 to 15) := x"003E";
  constant mailbox_write_21_12_1 : std_logic_vector(0 to 15) := x"003F";
  constant mailbox_write_21_13_0 : std_logic_vector(0 to 15) := x"0040";
  constant mailbox_write_21_14_0 : std_logic_vector(0 to 15) := x"0041";
  constant mailbox_write_21_15_0 : std_logic_vector(0 to 15) := x"0042";
  constant mailbox_write_21_15_1 : std_logic_vector(0 to 15) := x"0043";
  constant mailbox_write_21_15_2 : std_logic_vector(0 to 15) := x"0044";
  constant mailbox_write_21_16_0 : std_logic_vector(0 to 15) := x"0045";
  constant mailbox_write_21_17_0 : std_logic_vector(0 to 15) := x"0046";
  constant mailbox_write_21_17_1 : std_logic_vector(0 to 15) := x"0047";
  constant mailbox_write_21_17_2 : std_logic_vector(0 to 15) := x"0048";
  constant mailbox_write_21_18_0 : std_logic_vector(0 to 15) := x"0049";
  constant mailbox_write_restore_0 : std_logic_vector(0 to 15) := x"004A";
  constant mailbox_write_restore_1 : std_logic_vector(0 to 15) := x"004B";
  constant mailbox_write_restore_2 : std_logic_vector(0 to 15) := x"004C";
  constant mailbox_write_restore_3 : std_logic_vector(0 to 15) := x"004D";
  constant mailbox_write_restore_4 : std_logic_vector(0 to 15) := x"004E";
  constant mailbox_write_end : std_logic_vector(0 to 15) := x"004F";
  constant bubblesort_start : std_logic_vector(0 to 15) := x"0050";
  constant bubblesort_save_0 : std_logic_vector(0 to 15) := x"0051";
  constant bubblesort_save_1 : std_logic_vector(0 to 15) := x"0052";
  constant bubblesort_save_2 : std_logic_vector(0 to 15) := x"0053";
  constant bubblesort_save_3 : std_logic_vector(0 to 15) := x"0054";
  constant bubblesort_save_4 : std_logic_vector(0 to 15) := x"0055";
  constant bubblesort_save_5 : std_logic_vector(0 to 15) := x"0056";
  constant bubblesort_save_6 : std_logic_vector(0 to 15) := x"0057";
  constant bubblesort_save_7 : std_logic_vector(0 to 15) := x"0058";
  constant bubblesort_save_8 : std_logic_vector(0 to 15) := x"0059";
  constant bubblesort_0_0_0 : std_logic_vector(0 to 15) := x"005A";
  constant bubblesort_0_0_1 : std_logic_vector(0 to 15) := x"005B";
  constant bubblesort_0_1_0 : std_logic_vector(0 to 15) := x"005C";
  constant bubblesort_0_1_1 : std_logic_vector(0 to 15) := x"005D";
  constant bubblesort_0_2_0 : std_logic_vector(0 to 15) := x"005E";
  constant bubblesort_0_3_0 : std_logic_vector(0 to 15) := x"005F";
  constant bubblesort_0_4_0 : std_logic_vector(0 to 15) := x"0060";
  constant bubblesort_0_5_0 : std_logic_vector(0 to 15) := x"0061";
  constant bubblesort_0_6_0 : std_logic_vector(0 to 15) := x"0062";
  constant bubblesort_1_0_0 : std_logic_vector(0 to 15) := x"0063";
  constant bubblesort_1_0_1 : std_logic_vector(0 to 15) := x"0064";
  constant bubblesort_1_1_0 : std_logic_vector(0 to 15) := x"0065";
  constant bubblesort_1_2_0 : std_logic_vector(0 to 15) := x"0066";
  constant bubblesort_1_3_0 : std_logic_vector(0 to 15) := x"0067";
  constant bubblesort_1_3_1 : std_logic_vector(0 to 15) := x"0068";
  constant bubblesort_1_4_0 : std_logic_vector(0 to 15) := x"0069";
  constant bubblesort_1_5_0 : std_logic_vector(0 to 15) := x"006A";
  constant bubblesort_1_6_0 : std_logic_vector(0 to 15) := x"006B";
  constant bubblesort_1_7_0 : std_logic_vector(0 to 15) := x"006C";
  constant bubblesort_1_8_0 : std_logic_vector(0 to 15) := x"006D";
  constant bubblesort_1_8_1 : std_logic_vector(0 to 15) := x"006E";
  constant bubblesort_1_9_0 : std_logic_vector(0 to 15) := x"006F";
  constant bubblesort_2_0_0 : std_logic_vector(0 to 15) := x"0070";
  constant bubblesort_3_0_0 : std_logic_vector(0 to 15) := x"0071";
  constant bubblesort_4_0_0 : std_logic_vector(0 to 15) := x"0072";
  constant bubblesort_4_1_0 : std_logic_vector(0 to 15) := x"0073";
  constant bubblesort_4_2_0 : std_logic_vector(0 to 15) := x"0074";
  constant bubblesort_4_3_0 : std_logic_vector(0 to 15) := x"0075";
  constant bubblesort_4_4_0 : std_logic_vector(0 to 15) := x"0076";
  constant bubblesort_5_0_0 : std_logic_vector(0 to 15) := x"0077";
  constant bubblesort_6_0_0 : std_logic_vector(0 to 15) := x"0078";
  constant bubblesort_7_0_0 : std_logic_vector(0 to 15) := x"0079";
  constant bubblesort_8_0_0 : std_logic_vector(0 to 15) := x"007A";
  constant bubblesort_9_0_0 : std_logic_vector(0 to 15) := x"007B";
  constant bubblesort_10_0_0 : std_logic_vector(0 to 15) := x"007C";
  constant bubblesort_11_0_0 : std_logic_vector(0 to 15) := x"007D";
  constant bubblesort_12_0_0 : std_logic_vector(0 to 15) := x"007E";
  constant bubblesort_12_1_0 : std_logic_vector(0 to 15) := x"007F";
  constant bubblesort_12_2_0 : std_logic_vector(0 to 15) := x"0080";
  constant bubblesort_12_3_0 : std_logic_vector(0 to 15) := x"0081";
  constant bubblesort_13_0_0 : std_logic_vector(0 to 15) := x"0082";
  constant bubblesort_restore_0 : std_logic_vector(0 to 15) := x"0083";
  constant bubblesort_restore_1 : std_logic_vector(0 to 15) := x"0084";
  constant bubblesort_restore_2 : std_logic_vector(0 to 15) := x"0085";
  constant bubblesort_restore_3 : std_logic_vector(0 to 15) := x"0086";
  constant bubblesort_restore_4 : std_logic_vector(0 to 15) := x"0087";
  constant bubblesort_restore_5 : std_logic_vector(0 to 15) := x"0088";
  constant bubblesort_restore_6 : std_logic_vector(0 to 15) := x"0089";
  constant bubblesort_restore_7 : std_logic_vector(0 to 15) := x"008A";
  constant bubblesort_restore_8 : std_logic_vector(0 to 15) := x"008B";
  constant bubblesort_end : std_logic_vector(0 to 15) := x"008C";
  constant mailbox_read_start : std_logic_vector(0 to 15) := x"008D";
  constant mailbox_read_save_0 : std_logic_vector(0 to 15) := x"008E";
  constant mailbox_read_save_1 : std_logic_vector(0 to 15) := x"008F";
  constant mailbox_read_save_2 : std_logic_vector(0 to 15) := x"0090";
  constant mailbox_read_save_3 : std_logic_vector(0 to 15) := x"0091";
  constant mailbox_read_save_4 : std_logic_vector(0 to 15) := x"0092";
  constant mailbox_read_23_0_0 : std_logic_vector(0 to 15) := x"0093";
  constant mailbox_read_23_0_1 : std_logic_vector(0 to 15) := x"0094";
  constant mailbox_read_23_1_0 : std_logic_vector(0 to 15) := x"0095";
  constant mailbox_read_23_2_0 : std_logic_vector(0 to 15) := x"0096";
  constant mailbox_read_23_3_0 : std_logic_vector(0 to 15) := x"0097";
  constant mailbox_read_23_3_1 : std_logic_vector(0 to 15) := x"0098";
  constant mailbox_read_23_3_2 : std_logic_vector(0 to 15) := x"0099";
  constant mailbox_read_23_4_0 : std_logic_vector(0 to 15) := x"009A";
  constant mailbox_read_23_4_1 : std_logic_vector(0 to 15) := x"009B";
  constant mailbox_read_23_5_0 : std_logic_vector(0 to 15) := x"009C";
  constant mailbox_read_24_0_0 : std_logic_vector(0 to 15) := x"009D";
  constant mailbox_read_25_0_0 : std_logic_vector(0 to 15) := x"009E";
  constant mailbox_read_26_0_0 : std_logic_vector(0 to 15) := x"009F";
  constant mailbox_read_26_1_0 : std_logic_vector(0 to 15) := x"00A0";
  constant mailbox_read_26_1_1 : std_logic_vector(0 to 15) := x"00A1";
  constant mailbox_read_26_1_2 : std_logic_vector(0 to 15) := x"00A2";
  constant mailbox_read_26_1_3 : std_logic_vector(0 to 15) := x"00A3";
  constant mailbox_read_26_2_0 : std_logic_vector(0 to 15) := x"00A4";
  constant mailbox_read_26_2_1 : std_logic_vector(0 to 15) := x"00A5";
  constant mailbox_read_26_3_0 : std_logic_vector(0 to 15) := x"00A6";
  constant mailbox_read_27_0_0 : std_logic_vector(0 to 15) := x"00A7";
  constant mailbox_read_28_0_0 : std_logic_vector(0 to 15) := x"00A8";
  constant mailbox_read_29_0_0 : std_logic_vector(0 to 15) := x"00A9";
  constant mailbox_read_29_0_1 : std_logic_vector(0 to 15) := x"00AA";
  constant mailbox_read_29_1_0 : std_logic_vector(0 to 15) := x"00AB";
  constant mailbox_read_29_2_0 : std_logic_vector(0 to 15) := x"00AC";
  constant mailbox_read_29_2_1 : std_logic_vector(0 to 15) := x"00AD";
  constant mailbox_read_29_3_0 : std_logic_vector(0 to 15) := x"00AE";
  constant mailbox_read_29_4_0 : std_logic_vector(0 to 15) := x"00AF";
  constant mailbox_read_29_5_0 : std_logic_vector(0 to 15) := x"00B0";
  constant mailbox_read_29_5_1 : std_logic_vector(0 to 15) := x"00B1";
  constant mailbox_read_29_6_0 : std_logic_vector(0 to 15) := x"00B2";
  constant mailbox_read_29_7_0 : std_logic_vector(0 to 15) := x"00B3";
  constant mailbox_read_29_7_1 : std_logic_vector(0 to 15) := x"00B4";
  constant mailbox_read_29_8_0 : std_logic_vector(0 to 15) := x"00B5";
  constant mailbox_read_29_9_0 : std_logic_vector(0 to 15) := x"00B6";
  constant mailbox_read_29_10_0 : std_logic_vector(0 to 15) := x"00B7";
  constant mailbox_read_29_10_1 : std_logic_vector(0 to 15) := x"00B8";
  constant mailbox_read_29_11_0 : std_logic_vector(0 to 15) := x"00B9";
  constant mailbox_read_29_11_1 : std_logic_vector(0 to 15) := x"00BA";
  constant mailbox_read_29_12_0 : std_logic_vector(0 to 15) := x"00BB";
  constant mailbox_read_29_13_0 : std_logic_vector(0 to 15) := x"00BC";
  constant mailbox_read_29_13_1 : std_logic_vector(0 to 15) := x"00BD";
  constant mailbox_read_29_14_0 : std_logic_vector(0 to 15) := x"00BE";
  constant mailbox_read_29_15_0 : std_logic_vector(0 to 15) := x"00BF";
  constant mailbox_read_29_16_0 : std_logic_vector(0 to 15) := x"00C0";
  constant mailbox_read_29_16_1 : std_logic_vector(0 to 15) := x"00C1";
  constant mailbox_read_29_16_2 : std_logic_vector(0 to 15) := x"00C2";
  constant mailbox_read_29_17_0 : std_logic_vector(0 to 15) := x"00C3";
  constant mailbox_read_29_18_0 : std_logic_vector(0 to 15) := x"00C4";
  constant mailbox_read_29_18_1 : std_logic_vector(0 to 15) := x"00C5";
  constant mailbox_read_29_18_2 : std_logic_vector(0 to 15) := x"00C6";
  constant mailbox_read_29_19_0 : std_logic_vector(0 to 15) := x"00C7";
  constant mailbox_read_restore_0 : std_logic_vector(0 to 15) := x"00C8";
  constant mailbox_read_restore_1 : std_logic_vector(0 to 15) := x"00C9";
  constant mailbox_read_restore_2 : std_logic_vector(0 to 15) := x"00CA";
  constant mailbox_read_restore_3 : std_logic_vector(0 to 15) := x"00CB";
  constant mailbox_read_restore_4 : std_logic_vector(0 to 15) := x"00CC";
  constant mailbox_read_end : std_logic_vector(0 to 15) := x"00CD";
  constant sort8k_entry_start : std_logic_vector(0 to 15) := x"00CE";
  constant sort8k_entry_save_0 : std_logic_vector(0 to 15) := x"00CF";
  constant sort8k_entry_save_1 : std_logic_vector(0 to 15) := x"00D0";
  constant sort8k_entry_31_0_0 : std_logic_vector(0 to 15) := x"00D1";
  constant sort8k_entry_31_0_1 : std_logic_vector(0 to 15) := x"00D2";
  constant sort8k_entry_31_1_0 : std_logic_vector(0 to 15) := x"00D3";
  constant sort8k_entry_32_0_0 : std_logic_vector(0 to 15) := x"00D4";
  constant sort8k_entry_32_1_0 : std_logic_vector(0 to 15) := x"00D5";
  constant sort8k_entry_32_1_1 : std_logic_vector(0 to 15) := x"00D6";
  constant sort8k_entry_32_1_2 : std_logic_vector(0 to 15) := x"00D7";
  constant sort8k_entry_32_2_0 : std_logic_vector(0 to 15) := x"00D8";
  constant sort8k_entry_32_2_1 : std_logic_vector(0 to 15) := x"00D9";
  constant sort8k_entry_32_2_2 : std_logic_vector(0 to 15) := x"00DA";
  constant sort8k_entry_32_2_3 : std_logic_vector(0 to 15) := x"00DB";
  constant sort8k_entry_32_3_0 : std_logic_vector(0 to 15) := x"00DC";
  constant sort8k_entry_32_4_0 : std_logic_vector(0 to 15) := x"00DD";
  constant sort8k_entry_32_4_1 : std_logic_vector(0 to 15) := x"00DE";
  constant sort8k_entry_32_4_2 : std_logic_vector(0 to 15) := x"00DF";
  constant sort8k_entry_32_4_3 : std_logic_vector(0 to 15) := x"00E0";
  constant sort8k_entry_32_5_0 : std_logic_vector(0 to 15) := x"00E1";
  constant sort8k_entry_33_0_0 : std_logic_vector(0 to 15) := x"00E2";
  constant sort8k_entry_restore_0 : std_logic_vector(0 to 15) := x"00E3";
  constant sort8k_entry_restore_1 : std_logic_vector(0 to 15) := x"00E4";
  constant sort8k_entry_end : std_logic_vector(0 to 15) := x"00E5";
  constant MULT00 : std_logic_vector(0 to 15) := x"00E6";
  constant MULT01 : std_logic_vector(0 to 15) := x"00E7";
  constant MULT02 : std_logic_vector(0 to 15) := x"00E8";
  constant DIVIDE00 : std_logic_vector(0 to 15) := x"00E9";
  constant DIVIDE01 : std_logic_vector(0 to 15) := x"00EA";
  constant DIVIDE02 : std_logic_vector(0 to 15) := x"00EB";
  constant DIVIDE03 : std_logic_vector(0 to 15) := x"00EC";
  constant DIVIDE04 : std_logic_vector(0 to 15) := x"00ED";
  constant DIVIDE05 : std_logic_vector(0 to 15) := x"00EE";


  -- REGISTER DECLARATIONS
  -- Special purpose registers
  signal curstate : std_logic_vector(0 to 15) := START_STATE;
  signal returnstate : std_logic_vector(0 to 15) := WAIT_STATE;
  signal returnVal : std_logic_vector(0 to 31) := x"00000000";
  signal stack_mem : std_logic_vector(0 to 31) := x"00000000";
  signal params_mem : std_logic_vector(0 to 31) := x"00000000";

  -- Caller save registers
  signal T1 : std_logic_vector(0 to 31) := x"00000000";
  signal T2 : std_logic_vector(0 to 31) := x"00000000";
  signal T3 : std_logic_vector(0 to 31) := x"00000000";
  signal T4 : std_logic_vector(0 to 31) := x"00000000";
  signal T5 : std_logic_vector(0 to 31) := x"00000000";
  signal T6 : std_logic_vector(0 to 31) := x"00000000";
  
  -- Callee save registers
  signal R4 : std_logic_vector(0 to 31) := x"00000000";
  signal R5 : std_logic_vector(0 to 31) := x"00000000";
  signal R6 : std_logic_vector(0 to 31) := x"00000000";
  signal R7 : std_logic_vector(0 to 31) := x"00000000";
  signal R0 : std_logic_vector(0 to 31) := x"00000000";
  signal R1 : std_logic_vector(0 to 31) := x"00000000";
  signal R2 : std_logic_vector(0 to 31) := x"00000000";
  signal R3 : std_logic_vector(0 to 31) := x"00000000";
  signal R8 : std_logic_vector(0 to 31) := x"00000000";


BEGIN
  state_mach : PROCESS
  BEGIN
    WAIT UNTIL rising_edge(clock);
    IF (intrfc2thrd_goWait = '1') and (intrfc2thrd_function = U_FUNCTION_RESET) THEN
      -- Reset event
      thrd2intrfc_address <= x"00000000";
      thrd2intrfc_value <= x"00000000";
      thrd2intrfc_function <= x"0000";
      thrd2intrfc_opcode <= "000000";
      curstate <= START_STATE;
      returnstate <= WAIT_STATE;
      returnVal <= x"00000000";
      stack_mem <= x"00000000";
      params_mem <= x"00000000";
      T1 <= x"00000000";
      T2 <= x"00000000";
      T3 <= x"00000000";
      T4 <= x"00000000";
      T5 <= x"00000000";
      T6 <= x"00000000";
      R4 <= x"00000000";
      R5 <= x"00000000";
      R6 <= x"00000000";
      R7 <= x"00000000";
      R0 <= x"00000000";
      R1 <= x"00000000";
      R2 <= x"00000000";
      R3 <= x"00000000";
      R8 <= x"00000000";


    ELSE
      IF (intrfc2thrd_goWait = '1') THEN

        thrd2intrfc_opcode <= OPCODE_NOOP; --OPCODE IS NOOP BY DEFAULT

        CASE curstate IS

          -- Start loops while function code is "start" 
          WHEN START_STATE =>
            IF intrfc2thrd_function = U_FUNCTION_START THEN
              curstate <= START_STATE;
            ELSE
              curstate <= BOOTSTRAP0;
            END IF;



          WHEN BOOTSTRAP0 =>
            -- Call addressof to get the stack_mem pointer value.
            thrd2intrfc_value <= x"00000000";
            thrd2intrfc_opcode <= OPCODE_ADDRESSOF;
            curstate <= WAIT_STATE;
            returnstate <= BOOTSTRAP1;

          WHEN BOOTSTRAP1 =>
            -- Use the result of the addressof to set stack_mem and params_mem.
            -- Also call the declare opcode to initialize the stack for the thread main function.
            stack_mem <= intrfc2thrd_value;
            params_mem <= intrfc2thrd_value - x"00000010";

            thrd2intrfc_value <= x"00000002";
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_31_0_0;


          -- Begin of function mailbox_write (from mailbox_no_globals.c.hif)

          WHEN mailbox_write_start =>
            -- Declare the number of stack memory words needed for this function.
            thrd2intrfc_value <= x"00000005";
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_save_0;

          WHEN mailbox_write_save_0 =>
            -- Save register R0 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_save_1;

          WHEN mailbox_write_save_1 =>
            -- Save register R1 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_value <= R1;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_save_2;

          WHEN mailbox_write_save_2 =>
            -- Save register R2 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000008";
            thrd2intrfc_value <= R2;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_save_3;

          WHEN mailbox_write_save_3 =>
            -- Save register R3 on the stack.
            thrd2intrfc_address <= stack_mem + x"0000000C";
            thrd2intrfc_value <= R3;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_save_4;

          WHEN mailbox_write_save_4 =>
            -- Save register R4 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000010";
            thrd2intrfc_value <= R4;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_15_0_0;

          WHEN mailbox_write_15_0_0 =>
            -- arith2: @readarg R2 0  (296)
            thrd2intrfc_value <= x"00000001";
            thrd2intrfc_opcode <= OPCODE_POP;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_15_0_1;

          WHEN mailbox_write_15_0_1 =>
            -- Capture result of readarg.
            R2 <= intrfc2thrd_value;
            curstate <= mailbox_write_15_1_0;

          WHEN mailbox_write_15_1_0 =>
            -- arith2: @readarg R4 1  (297)
            thrd2intrfc_value <= x"00000000";
            thrd2intrfc_opcode <= OPCODE_POP;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_15_1_1;

          WHEN mailbox_write_15_1_1 =>
            -- Capture result of readarg.
            R4 <= intrfc2thrd_value;
            curstate <= mailbox_write_15_2_0;

          WHEN mailbox_write_15_2_0 =>
            -- arith3: @add R0 R2 20  (0)
            R0 <= R2 + x"00000014";
            curstate <= mailbox_write_15_3_0;

          WHEN mailbox_write_15_3_0 =>
            -- arith2: @mov R3 R0  (320)
            R3 <= R0;
            curstate <= mailbox_write_15_4_0;

          WHEN mailbox_write_15_4_0 =>
            -- call hthread_mutex_lock R3 @returnVal @none  (321)
            -- Push argument 0
            thrd2intrfc_value <= R3;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_15_4_1;

          WHEN mailbox_write_15_4_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000024";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
            thrd2intrfc_value <= x"0000"&mailbox_write_15_4_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_write_15_4_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000024";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_write_15_5_0;

          WHEN mailbox_write_15_5_0 =>
            -- read R0 R2 12  (322)
            thrd2intrfc_address <= R2 + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_15_5_1;

          WHEN mailbox_write_15_5_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_15_6_0;

          WHEN mailbox_write_15_6_0 =>
            -- read R1 R2 0  (323)
            thrd2intrfc_address <= R2 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_15_6_1;

          WHEN mailbox_write_15_6_1 =>
            -- Capture result of read.
            R1 <= intrfc2thrd_value;
            curstate <= mailbox_write_15_7_0;

          WHEN mailbox_write_15_7_0 =>
            -- if R1 S> R0 goto hif_label0(17)  (324)
            if (R1 > R0) then
              curstate <= mailbox_write_17_0_0;
            else
              curstate <= mailbox_write_16_0_0;
            end if;

          WHEN mailbox_write_16_0_0 =>
            -- goto HIFL0(18)  (325)
            curstate <= mailbox_write_18_0_0;

          WHEN mailbox_write_17_0_0 =>
            -- goto HIFL2(21)  (328)
            curstate <= mailbox_write_21_0_0;

          WHEN mailbox_write_18_0_0 =>
            -- arith3: @add R0 R2 32  (0)
            R0 <= R2 + x"00000020";
            curstate <= mailbox_write_18_1_0;

          WHEN mailbox_write_18_1_0 =>
            -- call hthread_cond_wait R0 R3 @returnVal @none  (333)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_18_1_1;

          WHEN mailbox_write_18_1_1 =>
            -- Push argument 1
            thrd2intrfc_value <= R3;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_18_1_2;

          WHEN mailbox_write_18_1_2 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000028";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_COND_WAIT;
            thrd2intrfc_value <= x"0000"&mailbox_write_18_1_3;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_write_18_1_3 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000028";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_write_18_2_0;

          WHEN mailbox_write_18_2_0 =>
            -- read R0 R2 12  (334)
            thrd2intrfc_address <= R2 + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_18_2_1;

          WHEN mailbox_write_18_2_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_18_3_0;

          WHEN mailbox_write_18_3_0 =>
            -- arith2: @mov R1 R0  (334)
            R1 <= R0;
            curstate <= mailbox_write_18_4_0;

          WHEN mailbox_write_18_4_0 =>
            -- read R0 R2 0  (335)
            thrd2intrfc_address <= R2 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_18_4_1;

          WHEN mailbox_write_18_4_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_18_5_0;

          WHEN mailbox_write_18_5_0 =>
            -- if R1 S< R0 goto hif_label2(20)  (336)
            if (R1 < R0) then
              curstate <= mailbox_write_20_0_0;
            else
              curstate <= mailbox_write_19_0_0;
            end if;

          WHEN mailbox_write_19_0_0 =>
            -- goto HIFL0(18)  (337)
            curstate <= mailbox_write_18_0_0;

          WHEN mailbox_write_20_0_0 =>
            -- goto HIFL2(21)  (340)
            curstate <= mailbox_write_21_0_0;

          WHEN mailbox_write_21_0_0 =>
            -- read R0 R2 16  (344)
            thrd2intrfc_address <= R2 + x"00000010";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_0_1;

          WHEN mailbox_write_21_0_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_1_0;

          WHEN mailbox_write_21_1_0 =>
            -- arith2: @mov R1 R0  (344)
            R1 <= R0;
            curstate <= mailbox_write_21_2_0;

          WHEN mailbox_write_21_2_0 =>
            -- read R0 R2 8  (345)
            thrd2intrfc_address <= R2 + x"00000008";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_2_1;

          WHEN mailbox_write_21_2_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_3_0;

          WHEN mailbox_write_21_3_0 =>
            -- arith3: @mul R0 R0 4  (347)
            --call quick function (will set returnVal)
            T1 <= x"0000"&mailbox_write_21_3_1;    --return address
            T2 <= R0;  --operand 1
            T3 <= x"00000004";  --operand 2
            T4 <= T4;
            curstate <= MULT00;
          WHEN mailbox_write_21_3_1 =>
            R0 <= returnVal;
            curstate <= mailbox_write_21_4_0;

          WHEN mailbox_write_21_4_0 =>
            -- arith3: @add R0 R1 R0  (349)
            R0 <= R1 + R0;
            curstate <= mailbox_write_21_5_0;

          WHEN mailbox_write_21_5_0 =>
            -- arith2: @mov R1 R4  (350)
            R1 <= R4;
            curstate <= mailbox_write_21_6_0;

          WHEN mailbox_write_21_6_0 =>
            -- write R0 0 R1  (350)
            thrd2intrfc_address <= R0 + x"00000000";
            thrd2intrfc_value <= R1;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_7_0;

          WHEN mailbox_write_21_7_0 =>
            -- read R0 R2 8  (351)
            thrd2intrfc_address <= R2 + x"00000008";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_7_1;

          WHEN mailbox_write_21_7_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_8_0;

          WHEN mailbox_write_21_8_0 =>
            -- arith3: @add R1 R0 1  (352)
            R1 <= R0 + x"00000001";
            curstate <= mailbox_write_21_9_0;

          WHEN mailbox_write_21_9_0 =>
            -- read R0 R2 0  (353)
            thrd2intrfc_address <= R2 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_9_1;

          WHEN mailbox_write_21_9_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_10_0;

          WHEN mailbox_write_21_10_0 =>
            -- arith3: @mod R0 R1 R0  (354)
            --call quick function (will set returnVal)
            T1 <= x"0000"&mailbox_write_21_10_1;    --return address
            T2 <= R1;  --operand 1
            T3 <= R0;  --operand 2
            T4 <= T4;
            curstate <= DIVIDE00;
          WHEN mailbox_write_21_10_1 =>
            R0 <= T4;
            curstate <= mailbox_write_21_11_0;

          WHEN mailbox_write_21_11_0 =>
            -- write R2 8 R0  (355)
            thrd2intrfc_address <= R2 + x"00000008";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_12_0;

          WHEN mailbox_write_21_12_0 =>
            -- read R0 R2 12  (356)
            thrd2intrfc_address <= R2 + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_12_1;

          WHEN mailbox_write_21_12_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_13_0;

          WHEN mailbox_write_21_13_0 =>
            -- arith3: @add R0 R0 1  (357)
            R0 <= R0 + x"00000001";
            curstate <= mailbox_write_21_14_0;

          WHEN mailbox_write_21_14_0 =>
            -- write R2 12 R0  (358)
            thrd2intrfc_address <= R2 + x"0000000C";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_15_0;

          WHEN mailbox_write_21_15_0 =>
            -- call hthread_mutex_unlock R3 @returnVal @none  (359)
            -- Push argument 0
            thrd2intrfc_value <= R3;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_15_1;

          WHEN mailbox_write_21_15_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000024";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
            thrd2intrfc_value <= x"0000"&mailbox_write_21_15_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_write_21_15_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000024";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_16_0;

          WHEN mailbox_write_21_16_0 =>
            -- arith3: @add R0 R2 28  (0)
            R0 <= R2 + x"0000001C";
            curstate <= mailbox_write_21_17_0;

          WHEN mailbox_write_21_17_0 =>
            -- call hthread_cond_signal R0 @returnVal @none  (361)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_21_17_1;

          WHEN mailbox_write_21_17_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000024";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_COND_SIGNAL;
            thrd2intrfc_value <= x"0000"&mailbox_write_21_17_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_write_21_17_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000024";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_write_21_18_0;

          WHEN mailbox_write_21_18_0 =>
            -- return 0  (362)
            T1 <= x"00000000";
            curstate <= mailbox_write_restore_0;

          WHEN mailbox_write_restore_0 =>
            -- Restore register R0 from the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_restore_1;

          WHEN mailbox_write_restore_1 =>
            -- Restore register R1 from the stack.
            R0 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_restore_2;

          WHEN mailbox_write_restore_2 =>
            -- Restore register R2 from the stack.
            R1 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000008";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_restore_3;

          WHEN mailbox_write_restore_3 =>
            -- Restore register R3 from the stack.
            R2 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_restore_4;

          WHEN mailbox_write_restore_4 =>
            -- Restore register R4 from the stack.
            R3 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000010";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_write_end;

          WHEN mailbox_write_end =>
            -- Use the return opcode to jump back to the caller.
            R4 <= intrfc2thrd_value;
            thrd2intrfc_value <= T1;
            thrd2intrfc_opcode <= OPCODE_RETURN;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;


          -- Begin of function bubblesort (from bubblesort.c.hif)

          WHEN bubblesort_start =>
            -- Declare the number of stack memory words needed for this function.
            thrd2intrfc_value <= x"00000009";
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_0;

          WHEN bubblesort_save_0 =>
            -- Save register R0 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_1;

          WHEN bubblesort_save_1 =>
            -- Save register R1 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_value <= R1;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_2;

          WHEN bubblesort_save_2 =>
            -- Save register R2 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000008";
            thrd2intrfc_value <= R2;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_3;

          WHEN bubblesort_save_3 =>
            -- Save register R3 on the stack.
            thrd2intrfc_address <= stack_mem + x"0000000C";
            thrd2intrfc_value <= R3;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_4;

          WHEN bubblesort_save_4 =>
            -- Save register R4 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000010";
            thrd2intrfc_value <= R4;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_5;

          WHEN bubblesort_save_5 =>
            -- Save register R5 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000014";
            thrd2intrfc_value <= R5;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_6;

          WHEN bubblesort_save_6 =>
            -- Save register R6 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000018";
            thrd2intrfc_value <= R6;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_7;

          WHEN bubblesort_save_7 =>
            -- Save register R7 on the stack.
            thrd2intrfc_address <= stack_mem + x"0000001C";
            thrd2intrfc_value <= R7;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_save_8;

          WHEN bubblesort_save_8 =>
            -- Save register R8 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000020";
            thrd2intrfc_value <= R8;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_0_0_0;

          WHEN bubblesort_0_0_0 =>
            -- arith2: @readarg R1 0  (7)
            thrd2intrfc_value <= x"00000001";
            thrd2intrfc_opcode <= OPCODE_POP;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_0_0_1;

          WHEN bubblesort_0_0_1 =>
            -- Capture result of readarg.
            R1 <= intrfc2thrd_value;
            curstate <= bubblesort_0_1_0;

          WHEN bubblesort_0_1_0 =>
            -- arith2: @readarg R0 1  (8)
            thrd2intrfc_value <= x"00000000";
            thrd2intrfc_opcode <= OPCODE_POP;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_0_1_1;

          WHEN bubblesort_0_1_1 =>
            -- Capture result of readarg.
            R0 <= intrfc2thrd_value;
            curstate <= bubblesort_0_2_0;

          WHEN bubblesort_0_2_0 =>
            -- arith3: @sub R4 R0 1  (24)
            R4 <= R0 - x"00000001";
            curstate <= bubblesort_0_3_0;

          WHEN bubblesort_0_3_0 =>
            -- arith2: @mov R2 R4  (25)
            R2 <= R4;
            curstate <= bubblesort_0_4_0;

          WHEN bubblesort_0_4_0 =>
            -- arith2: @mov R8 0  (26)
            R8 <= x"00000000";
            curstate <= bubblesort_0_5_0;

          WHEN bubblesort_0_5_0 =>
            -- arith2: @mov R3 0  (27)
            R3 <= x"00000000";
            curstate <= bubblesort_0_6_0;

          WHEN bubblesort_0_6_0 =>
            -- goto HIFL9(6)  (28)
            curstate <= bubblesort_6_0_0;

          WHEN bubblesort_1_0_0 =>
            -- arith3: @mul R7 R3 4  (30)
            --call quick function (will set returnVal)
            T1 <= x"0000"&bubblesort_1_0_1;    --return address
            T2 <= R3;  --operand 1
            T3 <= x"00000004";  --operand 2
            T4 <= T4;
            curstate <= MULT00;
          WHEN bubblesort_1_0_1 =>
            R7 <= returnVal;
            curstate <= bubblesort_1_1_0;

          WHEN bubblesort_1_1_0 =>
            -- arith2: @mov R0 R7  (31)
            R0 <= R7;
            curstate <= bubblesort_1_2_0;

          WHEN bubblesort_1_2_0 =>
            -- arith3: @add R6 R0 R1  (32)
            R6 <= R0 + R1;
            curstate <= bubblesort_1_3_0;

          WHEN bubblesort_1_3_0 =>
            -- read R0 R6 0  (33)
            thrd2intrfc_address <= R6 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_1_3_1;

          WHEN bubblesort_1_3_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= bubblesort_1_4_0;

          WHEN bubblesort_1_4_0 =>
            -- arith2: @mov R5 R0  (33)
            R5 <= R0;
            curstate <= bubblesort_1_5_0;

          WHEN bubblesort_1_5_0 =>
            -- arith2: @mov R0 R7  (34)
            R0 <= R7;
            curstate <= bubblesort_1_6_0;

          WHEN bubblesort_1_6_0 =>
            -- arith3: @add R0 R1 R0  (35)
            R0 <= R1 + R0;
            curstate <= bubblesort_1_7_0;

          WHEN bubblesort_1_7_0 =>
            -- arith3: @add R7 R0 4  (36)
            R7 <= R0 + x"00000004";
            curstate <= bubblesort_1_8_0;

          WHEN bubblesort_1_8_0 =>
            -- read R0 R7 0  (37)
            thrd2intrfc_address <= R7 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_1_8_1;

          WHEN bubblesort_1_8_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= bubblesort_1_9_0;

          WHEN bubblesort_1_9_0 =>
            -- if R5 U<= R0 goto hif_label0(3)  (38)
            if (R5 <= R0) then
              curstate <= bubblesort_3_0_0;
            else
              curstate <= bubblesort_2_0_0;
            end if;

          WHEN bubblesort_2_0_0 =>
            -- goto HIFL2(4)  (39)
            curstate <= bubblesort_4_0_0;

          WHEN bubblesort_3_0_0 =>
            -- goto HIFL3(5)  (42)
            curstate <= bubblesort_5_0_0;

          WHEN bubblesort_4_0_0 =>
            -- write R6 0 R0  (46)
            thrd2intrfc_address <= R6 + x"00000000";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_4_1_0;

          WHEN bubblesort_4_1_0 =>
            -- arith2: @mov R0 R5  (47)
            R0 <= R5;
            curstate <= bubblesort_4_2_0;

          WHEN bubblesort_4_2_0 =>
            -- write R7 0 R0  (47)
            thrd2intrfc_address <= R7 + x"00000000";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_4_3_0;

          WHEN bubblesort_4_3_0 =>
            -- arith2: @mov R2 R3  (48)
            R2 <= R3;
            curstate <= bubblesort_4_4_0;

          WHEN bubblesort_4_4_0 =>
            -- arith2: @mov R8 1  (49)
            R8 <= x"00000001";
            curstate <= bubblesort_5_0_0;

          WHEN bubblesort_5_0_0 =>
            -- arith3: @add R3 R3 1  (51)
            R3 <= R3 + x"00000001";
            curstate <= bubblesort_6_0_0;

          WHEN bubblesort_6_0_0 =>
            -- if R3 U>= R4 goto hif_label2(8)  (53)
            if (R3 >= R4) then
              curstate <= bubblesort_8_0_0;
            else
              curstate <= bubblesort_7_0_0;
            end if;

          WHEN bubblesort_7_0_0 =>
            -- goto HIFL1(1)  (54)
            curstate <= bubblesort_1_0_0;

          WHEN bubblesort_8_0_0 =>
            -- goto HIFL6(9)  (57)
            curstate <= bubblesort_9_0_0;

          WHEN bubblesort_9_0_0 =>
            -- if R8 S== 0 goto hif_label4(11)  (61)
            if (R8 = x"00000000") then
              curstate <= bubblesort_11_0_0;
            else
              curstate <= bubblesort_10_0_0;
            end if;

          WHEN bubblesort_10_0_0 =>
            -- goto HIFL12(12)  (62)
            curstate <= bubblesort_12_0_0;

          WHEN bubblesort_11_0_0 =>
            -- goto HIFL7(13)  (65)
            curstate <= bubblesort_13_0_0;

          WHEN bubblesort_12_0_0 =>
            -- arith2: @mov R4 R2  (69)
            R4 <= R2;
            curstate <= bubblesort_12_1_0;

          WHEN bubblesort_12_1_0 =>
            -- arith2: @mov R8 0  (70)
            R8 <= x"00000000";
            curstate <= bubblesort_12_2_0;

          WHEN bubblesort_12_2_0 =>
            -- arith2: @mov R3 0  (71)
            R3 <= x"00000000";
            curstate <= bubblesort_12_3_0;

          WHEN bubblesort_12_3_0 =>
            -- goto HIFL9(6)  (72)
            curstate <= bubblesort_6_0_0;

          WHEN bubblesort_13_0_0 =>
            -- return @none  (74)
            T1 <= x"00000000";
            curstate <= bubblesort_restore_0;

          WHEN bubblesort_restore_0 =>
            -- Restore register R0 from the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_1;

          WHEN bubblesort_restore_1 =>
            -- Restore register R1 from the stack.
            R0 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_2;

          WHEN bubblesort_restore_2 =>
            -- Restore register R2 from the stack.
            R1 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000008";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_3;

          WHEN bubblesort_restore_3 =>
            -- Restore register R3 from the stack.
            R2 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_4;

          WHEN bubblesort_restore_4 =>
            -- Restore register R4 from the stack.
            R3 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000010";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_5;

          WHEN bubblesort_restore_5 =>
            -- Restore register R5 from the stack.
            R4 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000014";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_6;

          WHEN bubblesort_restore_6 =>
            -- Restore register R6 from the stack.
            R5 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000018";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_7;

          WHEN bubblesort_restore_7 =>
            -- Restore register R7 from the stack.
            R6 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"0000001C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_restore_8;

          WHEN bubblesort_restore_8 =>
            -- Restore register R8 from the stack.
            R7 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000020";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= bubblesort_end;

          WHEN bubblesort_end =>
            -- Use the return opcode to jump back to the caller.
            R8 <= intrfc2thrd_value;
            thrd2intrfc_value <= T1;
            thrd2intrfc_opcode <= OPCODE_RETURN;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;


          -- Begin of function mailbox_read (from mailbox_no_globals.c.hif)

          WHEN mailbox_read_start =>
            -- Declare the number of stack memory words needed for this function.
            thrd2intrfc_value <= x"00000005";
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_save_0;

          WHEN mailbox_read_save_0 =>
            -- Save register R0 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_save_1;

          WHEN mailbox_read_save_1 =>
            -- Save register R1 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_value <= R1;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_save_2;

          WHEN mailbox_read_save_2 =>
            -- Save register R2 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000008";
            thrd2intrfc_value <= R2;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_save_3;

          WHEN mailbox_read_save_3 =>
            -- Save register R3 on the stack.
            thrd2intrfc_address <= stack_mem + x"0000000C";
            thrd2intrfc_value <= R3;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_save_4;

          WHEN mailbox_read_save_4 =>
            -- Save register R4 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000010";
            thrd2intrfc_value <= R4;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_23_0_0;

          WHEN mailbox_read_23_0_0 =>
            -- arith2: @readarg R1 0  (57)
            thrd2intrfc_value <= x"00000000";
            thrd2intrfc_opcode <= OPCODE_POP;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_23_0_1;

          WHEN mailbox_read_23_0_1 =>
            -- Capture result of readarg.
            R1 <= intrfc2thrd_value;
            curstate <= mailbox_read_23_1_0;

          WHEN mailbox_read_23_1_0 =>
            -- arith3: @add R0 R1 20  (0)
            R0 <= R1 + x"00000014";
            curstate <= mailbox_read_23_2_0;

          WHEN mailbox_read_23_2_0 =>
            -- arith2: @mov R2 R0  (78)
            R2 <= R0;
            curstate <= mailbox_read_23_3_0;

          WHEN mailbox_read_23_3_0 =>
            -- call hthread_mutex_lock R2 @returnVal @none  (79)
            -- Push argument 0
            thrd2intrfc_value <= R2;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_23_3_1;

          WHEN mailbox_read_23_3_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000024";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
            thrd2intrfc_value <= x"0000"&mailbox_read_23_3_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_read_23_3_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000024";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_read_23_4_0;

          WHEN mailbox_read_23_4_0 =>
            -- read R0 R1 12  (80)
            thrd2intrfc_address <= R1 + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_23_4_1;

          WHEN mailbox_read_23_4_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_23_5_0;

          WHEN mailbox_read_23_5_0 =>
            -- if R0 S> 0 goto hif_label0(25)  (81)
            if (R0 > x"00000000") then
              curstate <= mailbox_read_25_0_0;
            else
              curstate <= mailbox_read_24_0_0;
            end if;

          WHEN mailbox_read_24_0_0 =>
            -- goto HIFL0(26)  (82)
            curstate <= mailbox_read_26_0_0;

          WHEN mailbox_read_25_0_0 =>
            -- goto HIFL2(29)  (85)
            curstate <= mailbox_read_29_0_0;

          WHEN mailbox_read_26_0_0 =>
            -- arith3: @add R0 R1 28  (0)
            R0 <= R1 + x"0000001C";
            curstate <= mailbox_read_26_1_0;

          WHEN mailbox_read_26_1_0 =>
            -- call hthread_cond_wait R0 R2 @returnVal @none  (90)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_26_1_1;

          WHEN mailbox_read_26_1_1 =>
            -- Push argument 1
            thrd2intrfc_value <= R2;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_26_1_2;

          WHEN mailbox_read_26_1_2 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000028";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_COND_WAIT;
            thrd2intrfc_value <= x"0000"&mailbox_read_26_1_3;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_read_26_1_3 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000028";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_read_26_2_0;

          WHEN mailbox_read_26_2_0 =>
            -- read R0 R1 12  (91)
            thrd2intrfc_address <= R1 + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_26_2_1;

          WHEN mailbox_read_26_2_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_26_3_0;

          WHEN mailbox_read_26_3_0 =>
            -- if R0 S> 0 goto hif_label2(28)  (92)
            if (R0 > x"00000000") then
              curstate <= mailbox_read_28_0_0;
            else
              curstate <= mailbox_read_27_0_0;
            end if;

          WHEN mailbox_read_27_0_0 =>
            -- goto HIFL0(26)  (93)
            curstate <= mailbox_read_26_0_0;

          WHEN mailbox_read_28_0_0 =>
            -- goto HIFL2(29)  (96)
            curstate <= mailbox_read_29_0_0;

          WHEN mailbox_read_29_0_0 =>
            -- read R0 R1 16  (100)
            thrd2intrfc_address <= R1 + x"00000010";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_0_1;

          WHEN mailbox_read_29_0_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_1_0;

          WHEN mailbox_read_29_1_0 =>
            -- arith2: @mov R4 R0  (100)
            R4 <= R0;
            curstate <= mailbox_read_29_2_0;

          WHEN mailbox_read_29_2_0 =>
            -- read R0 R1 4  (101)
            thrd2intrfc_address <= R1 + x"00000004";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_2_1;

          WHEN mailbox_read_29_2_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_3_0;

          WHEN mailbox_read_29_3_0 =>
            -- arith2: @mov R3 R0  (101)
            R3 <= R0;
            curstate <= mailbox_read_29_4_0;

          WHEN mailbox_read_29_4_0 =>
            -- arith2: @mov R0 R3  (102)
            R0 <= R3;
            curstate <= mailbox_read_29_5_0;

          WHEN mailbox_read_29_5_0 =>
            -- arith3: @mul R0 R0 4  (103)
            --call quick function (will set returnVal)
            T1 <= x"0000"&mailbox_read_29_5_1;    --return address
            T2 <= R0;  --operand 1
            T3 <= x"00000004";  --operand 2
            T4 <= T4;
            curstate <= MULT00;
          WHEN mailbox_read_29_5_1 =>
            R0 <= returnVal;
            curstate <= mailbox_read_29_6_0;

          WHEN mailbox_read_29_6_0 =>
            -- arith3: @add R0 R4 R0  (105)
            R0 <= R4 + R0;
            curstate <= mailbox_read_29_7_0;

          WHEN mailbox_read_29_7_0 =>
            -- read R0 R0 0  (106)
            thrd2intrfc_address <= R0 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_7_1;

          WHEN mailbox_read_29_7_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_8_0;

          WHEN mailbox_read_29_8_0 =>
            -- arith2: @mov R4 R0  (106)
            R4 <= R0;
            curstate <= mailbox_read_29_9_0;

          WHEN mailbox_read_29_9_0 =>
            -- arith3: @add R3 R3 1  (107)
            R3 <= R3 + x"00000001";
            curstate <= mailbox_read_29_10_0;

          WHEN mailbox_read_29_10_0 =>
            -- read R0 R1 0  (108)
            thrd2intrfc_address <= R1 + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_10_1;

          WHEN mailbox_read_29_10_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_11_0;

          WHEN mailbox_read_29_11_0 =>
            -- arith3: @mod R0 R3 R0  (109)
            --call quick function (will set returnVal)
            T1 <= x"0000"&mailbox_read_29_11_1;    --return address
            T2 <= R3;  --operand 1
            T3 <= R0;  --operand 2
            T4 <= T4;
            curstate <= DIVIDE00;
          WHEN mailbox_read_29_11_1 =>
            R0 <= T4;
            curstate <= mailbox_read_29_12_0;

          WHEN mailbox_read_29_12_0 =>
            -- write R1 4 R0  (110)
            thrd2intrfc_address <= R1 + x"00000004";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_13_0;

          WHEN mailbox_read_29_13_0 =>
            -- read R0 R1 12  (111)
            thrd2intrfc_address <= R1 + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_13_1;

          WHEN mailbox_read_29_13_1 =>
            -- Capture result of read.
            R0 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_14_0;

          WHEN mailbox_read_29_14_0 =>
            -- arith3: @sub R0 R0 1  (112)
            R0 <= R0 - x"00000001";
            curstate <= mailbox_read_29_15_0;

          WHEN mailbox_read_29_15_0 =>
            -- write R1 12 R0  (113)
            thrd2intrfc_address <= R1 + x"0000000C";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_16_0;

          WHEN mailbox_read_29_16_0 =>
            -- call hthread_mutex_unlock R2 @returnVal @none  (114)
            -- Push argument 0
            thrd2intrfc_value <= R2;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_16_1;

          WHEN mailbox_read_29_16_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000024";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
            thrd2intrfc_value <= x"0000"&mailbox_read_29_16_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_read_29_16_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000024";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_17_0;

          WHEN mailbox_read_29_17_0 =>
            -- arith3: @add R0 R1 32  (0)
            R0 <= R1 + x"00000020";
            curstate <= mailbox_read_29_18_0;

          WHEN mailbox_read_29_18_0 =>
            -- call hthread_cond_signal R0 @returnVal @none  (116)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_29_18_1;

          WHEN mailbox_read_29_18_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000024";
            params_mem <= stack_mem + x"00000014";
            thrd2intrfc_function <= FUNCTION_HTHREAD_COND_SIGNAL;
            thrd2intrfc_value <= x"0000"&mailbox_read_29_18_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN mailbox_read_29_18_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000024";
            params_mem <= stack_mem - x"00000014";
            T1 <= intrfc2thrd_value;
            curstate <= mailbox_read_29_19_0;

          WHEN mailbox_read_29_19_0 =>
            -- return R4  (117)
            T1 <= R4;
            curstate <= mailbox_read_restore_0;

          WHEN mailbox_read_restore_0 =>
            -- Restore register R0 from the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_restore_1;

          WHEN mailbox_read_restore_1 =>
            -- Restore register R1 from the stack.
            R0 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_restore_2;

          WHEN mailbox_read_restore_2 =>
            -- Restore register R2 from the stack.
            R1 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000008";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_restore_3;

          WHEN mailbox_read_restore_3 =>
            -- Restore register R3 from the stack.
            R2 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"0000000C";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_restore_4;

          WHEN mailbox_read_restore_4 =>
            -- Restore register R4 from the stack.
            R3 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000010";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= mailbox_read_end;

          WHEN mailbox_read_end =>
            -- Use the return opcode to jump back to the caller.
            R4 <= intrfc2thrd_value;
            thrd2intrfc_value <= T1;
            thrd2intrfc_opcode <= OPCODE_RETURN;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;


          -- Begin of function sort8k_entry (from sort8k_no_globals.c.hif)

          WHEN sort8k_entry_start =>
            -- Declare the number of stack memory words needed for this function.
            thrd2intrfc_value <= x"00000002";
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_save_0;

          WHEN sort8k_entry_save_0 =>
            -- Save register R0 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_save_1;

          WHEN sort8k_entry_save_1 =>
            -- Save register R1 on the stack.
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_value <= R1;
            thrd2intrfc_opcode <= OPCODE_STORE;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_31_0_0;

          WHEN sort8k_entry_31_0_0 =>
            -- arith2: @readarg R0 0  (7)
            thrd2intrfc_value <= x"00000000";
            thrd2intrfc_opcode <= OPCODE_POP;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_31_0_1;

          WHEN sort8k_entry_31_0_1 =>
            -- Capture result of readarg.
            R0 <= intrfc2thrd_value;
            curstate <= sort8k_entry_31_1_0;

          WHEN sort8k_entry_31_1_0 =>
            -- arith2: @mov R1 R0  (37)
            R1 <= R0;
            curstate <= sort8k_entry_32_0_0;

          WHEN sort8k_entry_32_0_0 =>
            -- arith2: @mov R0 R1  (0)
            R0 <= R1;
            curstate <= sort8k_entry_32_1_0;

          WHEN sort8k_entry_32_1_0 =>
            -- call mailbox_read R0 @returnVal R0  (40)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_32_1_1;

          WHEN sort8k_entry_32_1_1 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"00000018";
            params_mem <= stack_mem + x"00000008";
            thrd2intrfc_function <= mailbox_read_start;
            thrd2intrfc_value <= x"0000"&sort8k_entry_32_1_2;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN sort8k_entry_32_1_2 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"00000018";
            params_mem <= stack_mem - x"00000008";
            R0 <= intrfc2thrd_value;
            curstate <= sort8k_entry_32_2_0;

          WHEN sort8k_entry_32_2_0 =>
            -- call bubblesort R0 2048 @returnVal @none  (43)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_32_2_1;

          WHEN sort8k_entry_32_2_1 =>
            -- Push argument 1
            thrd2intrfc_value <= x"00000800";
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_32_2_2;

          WHEN sort8k_entry_32_2_2 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"0000001C";
            params_mem <= stack_mem + x"00000008";
            thrd2intrfc_function <= bubblesort_start;
            thrd2intrfc_value <= x"0000"&sort8k_entry_32_2_3;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN sort8k_entry_32_2_3 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"0000001C";
            params_mem <= stack_mem - x"00000008";
            T1 <= intrfc2thrd_value;
            curstate <= sort8k_entry_32_3_0;

          WHEN sort8k_entry_32_3_0 =>
            -- arith3: @add R0 R1 36  (0)
            R0 <= R1 + x"00000024";
            curstate <= sort8k_entry_32_4_0;

          WHEN sort8k_entry_32_4_0 =>
            -- call mailbox_write R0 23 @returnVal @none  (45)
            -- Push argument 0
            thrd2intrfc_value <= R0;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_32_4_1;

          WHEN sort8k_entry_32_4_1 =>
            -- Push argument 1
            thrd2intrfc_value <= x"00000017";
            thrd2intrfc_opcode <= OPCODE_PUSH;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_32_4_2;

          WHEN sort8k_entry_32_4_2 =>
            -- Set the stack_mem/params_mem pointers for callee and
            -- use the call opcode to actually jump to the callee.
            stack_mem <= stack_mem + x"0000001C";
            params_mem <= stack_mem + x"00000008";
            thrd2intrfc_function <= mailbox_write_start;
            thrd2intrfc_value <= x"0000"&sort8k_entry_32_4_3;
            thrd2intrfc_opcode <= OPCODE_CALL;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          WHEN sort8k_entry_32_4_3 =>
            -- Reset the stack/param pointers for caller and capture the return value.
            stack_mem <= stack_mem - x"0000001C";
            params_mem <= stack_mem - x"00000008";
            T1 <= intrfc2thrd_value;
            curstate <= sort8k_entry_32_5_0;

          WHEN sort8k_entry_32_5_0 =>
            -- goto HIFL0(32)  (46)
            curstate <= sort8k_entry_32_0_0;

          WHEN sort8k_entry_33_0_0 =>
            -- return @none  (0)
            T1 <= x"00000000";
            curstate <= sort8k_entry_restore_0;

          WHEN sort8k_entry_restore_0 =>
            -- Restore register R0 from the stack.
            thrd2intrfc_address <= stack_mem + x"00000000";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_restore_1;

          WHEN sort8k_entry_restore_1 =>
            -- Restore register R1 from the stack.
            R0 <= intrfc2thrd_value;
            thrd2intrfc_address <= stack_mem + x"00000004";
            thrd2intrfc_opcode <= OPCODE_LOAD;
            curstate <= WAIT_STATE;
            returnstate <= sort8k_entry_end;

          WHEN sort8k_entry_end =>
            -- Use the return opcode to jump back to the caller.
            R1 <= intrfc2thrd_value;
            thrd2intrfc_value <= T1;
            thrd2intrfc_opcode <= OPCODE_RETURN;
            curstate <= WAIT_STATE;
            returnstate <= FUNCTCALL_STATE;

          --multiply quick function
          --implements 32 bit multiply
          --assumes return address in T1, operands in T2 and T3
          WHEN MULT00 =>
            T4 <= std_logic_vector(conv_signed(signed(b"00"&T2(16 to 31)) * signed(b"00"&T3(16 to 31)), 32));
            returnVal <= std_logic_vector(conv_signed(signed(b"00"&T2(0 to 15)) * signed(b"00"&T3(16 to 31)), 32));
            curstate <= MULT01;
          WHEN MULT01 =>
            T4 <= std_logic_vector(conv_signed(signed(b"00"&T2(16 to 31)) * signed(b"00"&T3(0 to 15)), 32));
            returnVal <= T4 + (returnVal(16 to 31)&x"0000");
            curstate <= MULT02;
          WHEN MULT02 =>
            returnVal <= (T4(16 to 31)&x"0000") + returnVal;
            curstate <= T1(16 to 31);

          -- DIVIDE QUICK FUNCTION
          -- inputs
          -- T2 - dividend
          -- T3 - divisor
          -- outputs
          -- returnVal - quotient
          -- T4 - remainder
          -- tmps
          -- T5 - tmp_divisor
          -- T6 - counter
          WHEN DIVIDE00 =>
            if (T2 < x"00000000") then   -- init quotient  
              returnVal <= -T2;
            else
              returnVal <= T2;
            end if;
            T4 <= x"00000000";     -- init remainder
            if (T3 < x"00000000") then   -- init tmp_divisor
              T5 <= -T3;
            else
              T5 <= T3;
            end if;
            T6 <= x"00000000";    -- init counter
            curstate <= DIVIDE01;
          WHEN DIVIDE01 =>
            -- BEGIN LOOP
            T6 <= T6 + x"00000001";     -- increment counter
            T4 <= T4(1 to 31)&returnVal(0);   -- remainder = remainder(1 to 31)&quotient(0)
            returnVal <= returnVal(1 to 31)&'0';  -- shift quotient left
            curstate <= DIVIDE02;
          WHEN DIVIDE02 =>
            -- if the remainder is greater than tmp_divisor
            if (T4 >= T5) then
              returnVal(31) <= '1';  -- set lsb of quotient
              T4 <= T4 - T5;    -- subtract tmp_divisor from remainder
            end if;
            if (T6 < x"00000020") then  -- check loop bound
              curstate <= DIVIDE01;   -- GO TO NEXT ITERATION
            else
              curstate <= DIVIDE03;   -- LOOP IS DONE
            end if;
          WHEN DIVIDE03 =>
            -- LOOP IS DONE
            -- THE FOLLOWING STATES HANDLE THE SIGNED ASPECT
            -- if dividend < 0
            if (T2 < x"00000000") then
              T4 <= -T4;    -- remainder = -remainder
              curstate <= DIVIDE04;
            else
              curstate <= DIVIDE05;
            end if;
          WHEN DIVIDE04 =>
            if (T3 > x"00000000") then
              returnVal <= -returnVal;
            end if;
            curstate <= T1(16 to 31); -- return to caller
          WHEN DIVIDE05 =>
            if (T3 < x"00000000") then
              returnVal <= -returnVal; -- negate the quotient
            end if;
            curstate <= T1(16 to 31); -- return to caller
            





          -- Other states
          WHEN WAIT_STATE =>
            curstate <= returnstate;
          WHEN FUNCTCALL_STATE => -- give the HWTI control over the next state
            curstate <= intrfc2thrd_function;
          WHEN others => --this case should never be reached
            curstate <= START_STATE;

        END CASE;
      END IF;
    END IF;
  END PROCESS;
END IMP; 
