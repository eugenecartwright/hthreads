-------------------------------------------------------------------------------
-- hw_thread_bram_elaborate.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity hw_thread_bram_elaborate is
  generic (
    C_MEMSIZE : integer;
    C_PORT_DWIDTH : integer;
    C_PORT_AWIDTH : integer;
    C_NUM_WE : integer;
    C_FAMILY : string
    );
  port (
    BRAM_Rst_A : in std_logic;
    BRAM_Clk_A : in std_logic;
    BRAM_EN_A : in std_logic;
    BRAM_WEN_A : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_A : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_A : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_A : in std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Rst_B : in std_logic;
    BRAM_Clk_B : in std_logic;
    BRAM_EN_B : in std_logic;
    BRAM_WEN_B : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_B : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_B : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_B : in std_logic_vector(0 to C_PORT_DWIDTH-1)
  );

  attribute keep_hierarchy : STRING;
  attribute keep_hierarchy of hw_thread_bram_elaborate : entity is "yes";

end hw_thread_bram_elaborate;

architecture STRUCTURE of hw_thread_bram_elaborate is

  component RAMB36 is
    generic (
      WRITE_MODE_A : string;
      WRITE_MODE_B : string;
      READ_WIDTH_A : integer;
      READ_WIDTH_B : integer;
      WRITE_WIDTH_A : integer;
      WRITE_WIDTH_B : integer;
      RAM_EXTENSION_A : string;
      RAM_EXTENSION_B : string
    );
    port (
      ADDRA : in std_logic_vector(15 downto 0);
      CASCADEINLATA : in std_logic;
      CASCADEINREGA : in std_logic;
      CASCADEOUTLATA : out std_logic;
      CASCADEOUTREGA : out std_logic;
      CLKA : in std_logic;
      DIA : in std_logic_vector(31 downto 0);
      DIPA : in std_logic_vector(3 downto 0);
      DOA : out std_logic_vector(31 downto 0);
      DOPA : out std_logic_vector(3 downto 0);
      ENA : in std_logic;
      REGCEA : in std_logic;
      SSRA : in std_logic;
      WEA : in std_logic_vector(3 downto 0);
      ADDRB : in std_logic_vector(15 downto 0);
      CASCADEINLATB : in std_logic;
      CASCADEINREGB : in std_logic;
      CASCADEOUTLATB : out std_logic;
      CASCADEOUTREGB : out std_logic;
      CLKB : in std_logic;
      DIB : in std_logic_vector(31 downto 0);
      DIPB : in std_logic_vector(3 downto 0);
      DOB : out std_logic_vector(31 downto 0);
      DOPB : out std_logic_vector(3 downto 0);
      ENB : in std_logic;
      REGCEB : in std_logic;
      SSRB : in std_logic;
      WEB : in std_logic_vector(3 downto 0)
    );
  end component;

  -- Internal signals

  signal net_gnd0 : std_logic;
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 3);
  signal pgassign3 : std_logic_vector(0 to 15);
  signal pgassign4 : std_logic_vector(15 downto 0);
  signal pgassign5 : std_logic_vector(31 downto 0);
  signal pgassign6 : std_logic_vector(31 downto 0);
  signal pgassign7 : std_logic_vector(3 downto 0);
  signal pgassign8 : std_logic_vector(15 downto 0);
  signal pgassign9 : std_logic_vector(31 downto 0);
  signal pgassign10 : std_logic_vector(31 downto 0);
  signal pgassign11 : std_logic_vector(3 downto 0);
  signal pgassign12 : std_logic_vector(15 downto 0);
  signal pgassign13 : std_logic_vector(31 downto 0);
  signal pgassign14 : std_logic_vector(31 downto 0);
  signal pgassign15 : std_logic_vector(3 downto 0);
  signal pgassign16 : std_logic_vector(15 downto 0);
  signal pgassign17 : std_logic_vector(31 downto 0);
  signal pgassign18 : std_logic_vector(31 downto 0);
  signal pgassign19 : std_logic_vector(3 downto 0);

begin

  -- Internal assignments

  pgassign1(0 to 0) <= B"1";
  pgassign2(0 to 3) <= B"0000";
  pgassign3(0 to 15) <= B"0000000000000000";
  pgassign4(15 downto 15) <= B"1";
  pgassign4(14 downto 4) <= BRAM_Addr_A(19 to 29);
  pgassign4(3 downto 0) <= B"0000";
  pgassign5(31 downto 16) <= B"0000000000000000";
  pgassign5(15 downto 0) <= BRAM_Dout_A(0 to 15);
  BRAM_Din_A(0 to 15) <= pgassign6(15 downto 0);
  pgassign7(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign7(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign7(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign7(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign8(15 downto 15) <= B"1";
  pgassign8(14 downto 4) <= BRAM_Addr_B(19 to 29);
  pgassign8(3 downto 0) <= B"0000";
  pgassign9(31 downto 16) <= B"0000000000000000";
  pgassign9(15 downto 0) <= BRAM_Dout_B(0 to 15);
  BRAM_Din_B(0 to 15) <= pgassign10(15 downto 0);
  pgassign11(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign11(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign11(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign11(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign12(15 downto 15) <= B"1";
  pgassign12(14 downto 4) <= BRAM_Addr_A(19 to 29);
  pgassign12(3 downto 0) <= B"0000";
  pgassign13(31 downto 16) <= B"0000000000000000";
  pgassign13(15 downto 0) <= BRAM_Dout_A(16 to 31);
  BRAM_Din_A(16 to 31) <= pgassign14(15 downto 0);
  pgassign15(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign15(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign15(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign15(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign16(15 downto 15) <= B"1";
  pgassign16(14 downto 4) <= BRAM_Addr_B(19 to 29);
  pgassign16(3 downto 0) <= B"0000";
  pgassign17(31 downto 16) <= B"0000000000000000";
  pgassign17(15 downto 0) <= BRAM_Dout_B(16 to 31);
  BRAM_Din_B(16 to 31) <= pgassign18(15 downto 0);
  pgassign19(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign19(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign19(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign19(0 downto 0) <= BRAM_WEN_B(3 to 3);
  net_gnd0 <= '0';
  net_gnd4(3 downto 0) <= B"0000";

  ramb36_0 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 18,
      READ_WIDTH_B => 18,
      WRITE_WIDTH_A => 18,
      WRITE_WIDTH_B => 18,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign4,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign5,
      DIPA => net_gnd4,
      DOA => pgassign6,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign7,
      ADDRB => pgassign8,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign9,
      DIPB => net_gnd4,
      DOB => pgassign10,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign11
    );

  ramb36_1 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      READ_WIDTH_A => 18,
      READ_WIDTH_B => 18,
      WRITE_WIDTH_A => 18,
      WRITE_WIDTH_B => 18,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      ADDRA => pgassign12,
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign13,
      DIPA => net_gnd4,
      DOA => pgassign14,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign15,
      ADDRB => pgassign16,
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign17,
      DIPB => net_gnd4,
      DOB => pgassign18,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign19
    );

end architecture STRUCTURE;

