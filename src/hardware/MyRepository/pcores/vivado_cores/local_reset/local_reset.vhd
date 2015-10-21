library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity resetgen is
generic(
     RESET_ACTIVE : std_logic := '0'
);	
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    cmd_TDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    cmd_TVALID : IN STD_LOGIC;
    cmd_TREADY : OUT STD_LOGIC;
    resp_TDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    resp_TVALID : OUT STD_LOGIC;
    resp_TREADY : IN STD_LOGIC;
    rst : out std_logic );
end;


architecture behav of resetgen is 

type state_machine_type is
(
reset,
idle,
reset_phase,
send_done
);
signal current_state,next_state : state_machine_type :=reset;
signal cycles_count_next, cycles_count : STD_LOGIC_VECTOR (31 downto 0);




begin
 
   resp_TDATA <= x"DEADBEEF";

-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
fsm_sync_process : process (
ap_clk, ap_rst_n,cycles_count_next, next_state

) is
begin
   if (rising_edge(ap_clk)) then
      if (ap_rst_n ='0') then
          current_state <= reset;
          cycles_count <= (others => '0');
      else
          current_state <= next_state;
          cycles_count <= cycles_count_next;
      end if;
   end if;
end process fsm_sync_process;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
cycles_count,cmd_TDATA,cmd_TVALID,resp_TREADY,
current_state) is
begin

next_state <= current_state;
rst  <= not RESET_ACTIVE ;
cycles_count_next <= cycles_count;
cmd_TREADY <= '0' ;
resp_TVALID <= '0';
--FSM logic

 case (current_state) is
   when reset =>
       next_state <= idle;
   
   when idle =>
	if  (cmd_TVALID = '1') then
            cmd_TREADY <= '1' ;
            cycles_count_next <= cmd_TDATA;
            next_state <=reset_phase;
        end if; 

   when reset_phase =>
       if (cycles_count > 0) then 
            rst <= RESET_ACTIVE;
            cycles_count_next <= cycles_count -1;
       else
            next_state <= send_done;
       end if;

   when send_done =>
         resp_TVALID <= '1';
      if (resp_TREADY = '1') then        
         next_state <= idle;
      end if;

   when others =>
        next_state <= idle;

  end case;
end process FSM_COMB_PROCESS;
end behav;
