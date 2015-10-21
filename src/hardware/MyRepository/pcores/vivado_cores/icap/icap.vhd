library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity myicap is
  port(
    clk                : in std_logic;
    icap_i             : in std_logic_vector(0 to 31);
    icap_o             : out std_logic_vector(0 to 31);
    icap_csib          : in std_logic;
    icap_rdwrb         : in std_logic
   
    );


end entity myicap;

architecture behav of myicap is

begin  
       ICAP_VIRTEX7_I : ICAPE2
         generic map (
           DEVICE_ID         => X"04224093",
           ICAP_WIDTH        => "X32")
         port map (
           clk               => clk,
           csib              => icap_csib,
           rdwrb             => icap_rdwrb,
           i                 => icap_i,
           o                 => icap_o);

end behav;