-------------------------------------------------------------------------------
-- ddr2_sdram_util_bus_split_1_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library util_bus_split_v1_00_a;
use util_bus_split_v1_00_a.all;

entity ddr2_sdram_util_bus_split_1_wrapper is
  port (
    Sig : in std_logic_vector(0 to 1);
    Out1 : out std_logic_vector(0 to 0);
    Out2 : out std_logic_vector(1 to 1)
  );

  attribute x_core_info : STRING;
  attribute x_core_info of ddr2_sdram_util_bus_split_1_wrapper : entity is "util_bus_split_v1_00_a";

end ddr2_sdram_util_bus_split_1_wrapper;

architecture STRUCTURE of ddr2_sdram_util_bus_split_1_wrapper is

  component util_bus_split is
    generic (
      C_SIZE_IN : integer;
      C_LEFT_POS : integer;
      C_SPLIT : integer
    );
    port (
      Sig : in std_logic_vector(0 to C_SIZE_IN-1);
      Out1 : out std_logic_vector(C_LEFT_POS to C_SPLIT-1);
      Out2 : out std_logic_vector(C_SPLIT to C_SIZE_IN-1)
    );
  end component;

begin

  DDR2_SDRAM_util_bus_split_1 : util_bus_split
    generic map (
      C_SIZE_IN => 2,
      C_LEFT_POS => 0,
      C_SPLIT => 1
    )
    port map (
      Sig => Sig,
      Out1 => Out1,
      Out2 => Out2
    );

end architecture STRUCTURE;

