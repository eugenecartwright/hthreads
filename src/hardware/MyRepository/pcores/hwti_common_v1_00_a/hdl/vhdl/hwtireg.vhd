library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library hwti_common_v1_00_a;
use hwti_common_v1_00_a.common.all;

entity hwtireg is
    generic
    (
        REG_WIDTH : integer := 32;
        USE_HIGH  : boolean := false;
        C_AWIDTH  : integer := 32;
        C_DWIDTH  : integer := 64
    );
    port
    (
        clk         :  in std_logic;
        rst         :  in std_logic;

        rd          :  in std_logic;
        wr          :  in std_logic;
        data        :  in std_logic_vector(0 to C_DWIDTH-1);

        rdack       : out std_logic;
        wrack       : out std_logic;
        value       : out std_logic_vector(0 to REG_WIDTH-1);
        output      : out std_logic_vector(0 to C_DWIDTH-1)
    );
end entity;

architecture behavioral of hwtireg is
    signal reg    : std_logic_vector(0 to REG_WIDTH-1);
begin
    value <= reg;
    wrack <= wr;
    rdack <= rd;
    output(C_DWIDTH-REG_WIDTH to C_DWIDTH-1) <= reg when rd = '1' else (others => '0');

    zero : if( REG_WIDTH < C_DWIDTH ) generate
    begin
        output(0 to C_DWIDTH-REG_WIDTH-1) <= (others => '0');
    end generate;

    regproc : process(clk,rst,rd,wr,data,reg) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' ) then
                reg <= (others => '0');
            elsif( wr = '1' ) then
                reg   <= data(C_DWIDTH-REG_WIDTH to C_DWIDTH-1);
            end if;
        end if;
    end process regproc;
end architecture;
