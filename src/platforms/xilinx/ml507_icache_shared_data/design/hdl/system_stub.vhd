-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
  port (
    fpga_0_RS232_Uart_1_RX_pin : in std_logic;
    fpga_0_RS232_Uart_1_TX_pin : out std_logic;
    fpga_0_LEDs_8Bit_GPIO_IO_pin : inout std_logic_vector(0 to 7);
    fpga_0_SRAM_Mem_A_pin : out std_logic_vector(7 to 30);
    fpga_0_SRAM_Mem_DQ_pin : inout std_logic_vector(0 to 31);
    fpga_0_SRAM_Mem_BEN_pin : out std_logic_vector(0 to 3);
    fpga_0_SRAM_Mem_OEN_pin : out std_logic;
    fpga_0_SRAM_Mem_CEN_pin : out std_logic;
    fpga_0_SRAM_Mem_ADV_LDN_pin : out std_logic;
    fpga_0_SRAM_Mem_WEN_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_ODT_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_Addr_pin : out std_logic_vector(12 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_CE_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_DDR2_CS_n_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_WE_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_Clk_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DM_pin : out std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS_n : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQ : inout std_logic_vector(63 downto 0);
    fpga_0_SRAM_CLK : out std_logic;
    fpga_0_SRAM_CLK_FB : in std_logic;
    sys_clk_pin : in std_logic;
    sys_rst_pin : in std_logic
  );
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
    port (
      fpga_0_RS232_Uart_1_RX_pin : in std_logic;
      fpga_0_RS232_Uart_1_TX_pin : out std_logic;
      fpga_0_LEDs_8Bit_GPIO_IO_pin : inout std_logic_vector(0 to 7);
      fpga_0_SRAM_Mem_A_pin : out std_logic_vector(7 to 30);
      fpga_0_SRAM_Mem_DQ_pin : inout std_logic_vector(0 to 31);
      fpga_0_SRAM_Mem_BEN_pin : out std_logic_vector(0 to 3);
      fpga_0_SRAM_Mem_OEN_pin : out std_logic;
      fpga_0_SRAM_Mem_CEN_pin : out std_logic;
      fpga_0_SRAM_Mem_ADV_LDN_pin : out std_logic;
      fpga_0_SRAM_Mem_WEN_pin : out std_logic;
      fpga_0_DDR2_SDRAM_DDR2_ODT_pin : out std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_Addr_pin : out std_logic_vector(12 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin : out std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin : out std_logic;
      fpga_0_DDR2_SDRAM_DDR2_CE_pin : out std_logic_vector(0 to 0);
      fpga_0_DDR2_SDRAM_DDR2_CS_n_pin : out std_logic_vector(0 to 0);
      fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin : out std_logic;
      fpga_0_DDR2_SDRAM_DDR2_WE_n_pin : out std_logic;
      fpga_0_DDR2_SDRAM_DDR2_Clk_pin : out std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin : out std_logic_vector(1 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_DM_pin : out std_logic_vector(7 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_DQS : inout std_logic_vector(7 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_DQS_n : inout std_logic_vector(7 downto 0);
      fpga_0_DDR2_SDRAM_DDR2_DQ : inout std_logic_vector(63 downto 0);
      fpga_0_SRAM_CLK : out std_logic;
      fpga_0_SRAM_CLK_FB : in std_logic;
      sys_clk_pin : in std_logic;
      sys_rst_pin : in std_logic
    );
  end component;

begin

  system_i : system
    port map (
      fpga_0_RS232_Uart_1_RX_pin => fpga_0_RS232_Uart_1_RX_pin,
      fpga_0_RS232_Uart_1_TX_pin => fpga_0_RS232_Uart_1_TX_pin,
      fpga_0_LEDs_8Bit_GPIO_IO_pin => fpga_0_LEDs_8Bit_GPIO_IO_pin,
      fpga_0_SRAM_Mem_A_pin => fpga_0_SRAM_Mem_A_pin,
      fpga_0_SRAM_Mem_DQ_pin => fpga_0_SRAM_Mem_DQ_pin,
      fpga_0_SRAM_Mem_BEN_pin => fpga_0_SRAM_Mem_BEN_pin,
      fpga_0_SRAM_Mem_OEN_pin => fpga_0_SRAM_Mem_OEN_pin,
      fpga_0_SRAM_Mem_CEN_pin => fpga_0_SRAM_Mem_CEN_pin,
      fpga_0_SRAM_Mem_ADV_LDN_pin => fpga_0_SRAM_Mem_ADV_LDN_pin,
      fpga_0_SRAM_Mem_WEN_pin => fpga_0_SRAM_Mem_WEN_pin,
      fpga_0_DDR2_SDRAM_DDR2_ODT_pin => fpga_0_DDR2_SDRAM_DDR2_ODT_pin,
      fpga_0_DDR2_SDRAM_DDR2_Addr_pin => fpga_0_DDR2_SDRAM_DDR2_Addr_pin,
      fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin => fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin,
      fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin => fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin,
      fpga_0_DDR2_SDRAM_DDR2_CE_pin => fpga_0_DDR2_SDRAM_DDR2_CE_pin(0 to 0),
      fpga_0_DDR2_SDRAM_DDR2_CS_n_pin => fpga_0_DDR2_SDRAM_DDR2_CS_n_pin(0 to 0),
      fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin => fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin,
      fpga_0_DDR2_SDRAM_DDR2_WE_n_pin => fpga_0_DDR2_SDRAM_DDR2_WE_n_pin,
      fpga_0_DDR2_SDRAM_DDR2_Clk_pin => fpga_0_DDR2_SDRAM_DDR2_Clk_pin,
      fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin => fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin,
      fpga_0_DDR2_SDRAM_DDR2_DM_pin => fpga_0_DDR2_SDRAM_DDR2_DM_pin,
      fpga_0_DDR2_SDRAM_DDR2_DQS => fpga_0_DDR2_SDRAM_DDR2_DQS,
      fpga_0_DDR2_SDRAM_DDR2_DQS_n => fpga_0_DDR2_SDRAM_DDR2_DQS_n,
      fpga_0_DDR2_SDRAM_DDR2_DQ => fpga_0_DDR2_SDRAM_DDR2_DQ,
      fpga_0_SRAM_CLK => fpga_0_SRAM_CLK,
      fpga_0_SRAM_CLK_FB => fpga_0_SRAM_CLK_FB,
      sys_clk_pin => sys_clk_pin,
      sys_rst_pin => sys_rst_pin
    );

end architecture STRUCTURE;

