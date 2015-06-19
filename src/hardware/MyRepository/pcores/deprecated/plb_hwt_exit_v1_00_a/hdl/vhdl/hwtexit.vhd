library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library hwti_common_v1_00_a;
use hwti_common_v1_00_a.common.all;

entity hwtexit is
    port
    (
        clk                 :  in std_logic;
        rst                 :  in std_logic;

        HWTI2USER_READ      : out std_logic;
        HWTI2USER_DATA      :  in std_logic_vector(0 to 63);
        HWTI2USER_CONTROL   :  in std_logic;
        HWTI2USER_EXISTS    :  in std_logic;

        USER2HWTI_WRITE     : out std_logic;
        USER2HWTI_DATA      : out std_logic_vector(0 to 63);
        USER2HWTI_CONTROL   : out std_logic;
        USER2HWTI_FULL      :  in std_logic
  );
end entity hwtexit;

architecture behavioral of hwtexit is
    type state is
    (
        IDLE,
        DOEXIT
    );

    signal cs   : state;
    signal ns   : state;
    signal tid  : std_logic_vector(0 to 7);
    signal tidn : std_logic_vector(0 to 7);
    signal arg  : std_logic_vector(0 to 31);
    signal argn : std_logic_vector(0 to 31);
begin
    update : process(clk,rst) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' ) then
                cs  <= IDLE;
                tid <= (others => '0');
                arg <= (others => '0');
            else
                cs  <= ns;
                tid <= tidn;
                arg <= argn;
            end if;
        end if;
    end process;

    controller : process(cs,HWTI2USER_EXISTS,HWTI2USER_DATA,USER2HWTI_FULL,tid, arg) is
    begin
        ns                <= cs;
        argn              <= arg;
        tidn              <= tid;
        HWTI2USER_READ    <= '0';
        USER2HWTI_WRITE   <= '0';
        USER2HWTI_CONTROL <= '0';
        USER2HWTI_DATA    <= (others => '0');

        case cs is
        when IDLE =>
            if( HWTI2USER_EXISTS = '1' ) then
                hwti_wake(HWTI2USER_DATA,tidn,argn);
                HWTI2USER_READ <= '1';
                ns             <= DOEXIT;
            end if;

        when DOEXIT =>
            if( USER2HWTI_FULL = '0' ) then
                USER2HWTI_WRITE   <= '1';
                USER2HWTI_DATA    <= hwti_thr_exit(arg);
                USER2HWTI_CONTROL <= '0';
                ns                <= IDLE;
            end if;
        end case;
    end process;
end behavioral;
