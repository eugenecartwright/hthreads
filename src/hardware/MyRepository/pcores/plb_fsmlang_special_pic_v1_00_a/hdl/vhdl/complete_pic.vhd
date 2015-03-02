library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity complete_pic is
generic(
  IID_WIDTH         : integer := 3;
  REG_SIZE          : integer := 9;
  CMD_WIDTH         : integer := 4;
  C_NUM_INTERRUPTS  : integer := 8
);
port
(
  --User Interface Port(s)
  msg_chan_channelDataIn : out std_logic_vector(0 to (8 - 1));
  msg_chan_channelDataOut : in std_logic_vector(0 to (8 - 1));
  msg_chan_exists : in std_logic;
  msg_chan_full : in std_logic;
  msg_chan_channelRead : out std_logic;
  msg_chan_channelWrite : out std_logic;
  go : in std_logic;
  ack : out std_logic;
  TID_IN : in std_logic_vector(0 to 7);
  IID_IN : in std_logic_vector(0 to IID_WIDTH - 1);
  CMD_IN : in std_logic_vector(0 to CMD_WIDTH - 1);
  RET_OUT : out std_logic_vector(0 to 7);
  TID_OUT : out std_logic_vector(0 to 7);

  --Controller Port(s)
  interrupts_in : in std_logic_vector(0 to C_NUM_INTERRUPTS - 1);

  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity complete_pic;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of complete_pic is
-- Component Definitions

    COMPONENT PIC
    GENERIC(
          IID_WIDTH : integer := 3;
          REG_SIZE : integer := 9;
          CMD_WIDTH : integer := 4;
          C_NUM_INTERRUPTS : integer := 8
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
         IID_IN : IN  std_logic_vector(0 to IID_WIDTH-1);
         CMD_IN : IN  std_logic_vector(0 to CMD_WIDTH-1);
         RUPT_IN : IN  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         IER_OUT : OUT  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         IAR_OUT : OUT  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         RET_OUT : OUT  std_logic_vector(0 to 7);
         TID_OUT : OUT  std_logic_vector(0 to 7);
         clock_sig : IN  std_logic;
         reset_sig : IN  std_logic
        );
    END COMPONENT;
	 
   COMPONENT INTC
	generic(
        C_NUM_INTERRUPTS : integer := 8;
        NEW_IID_WIDTH : integer := 3
	);
    PORT(
         interrupts_in : IN  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         ier_in : IN  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         iar_in : IN  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         interrupts_out : OUT  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         clock_sig : IN  std_logic;
         reset_sig : IN  std_logic
        );
    END COMPONENT;

-- Signal Definitions
signal  IER_sig :  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
signal  IAR_sig :  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
signal  PEND_sig :  std_logic_vector(0 to C_NUM_INTERRUPTS-1);


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


begin

-- Component Interconnection
    PIC_LOGIC : PIC
    generic map(
        IID_WIDTH   => IID_WIDTH,
        REG_SIZE    => REG_SIZE,
        CMD_WIDTH   => CMD_WIDTH,
        C_NUM_INTERRUPTS => C_NUM_INTERRUPTS  
    )
    port map(
          msg_chan_channelDataIn => msg_chan_channelDataIn,
          msg_chan_channelDataOut => msg_chan_channelDataOut,
          msg_chan_exists => msg_chan_exists,
          msg_chan_full => msg_chan_full,
          msg_chan_channelRead => msg_chan_channelRead,
          msg_chan_channelWrite => msg_chan_channelWrite,
          go => go,
          ack => ack,
          TID_IN => TID_IN,
          IID_IN => IID_IN,
          CMD_IN => CMD_IN,
          RUPT_IN => PEND_sig,
          IER_OUT => IER_sig,
          IAR_OUT => IAR_sig,
          RET_OUT => RET_OUT,
          TID_OUT => TID_OUT,
          clock_sig => clock_sig,
          reset_sig => reset_sig
    );

    INTC_LOGIC : INTC
    generic map(
       NEW_IID_WIDTH => IID_WIDTH,
       C_NUM_INTERRUPTS => C_NUM_INTERRUPTS
    )
    port map(
          interrupts_in => interrupts_in,
          ier_in => IER_sig,
          iar_in => IAR_sig,
          interrupts_out => PEND_sig,
          clock_sig => clock_sig,
          reset_sig => reset_sig
    );

end architecture implementation;

