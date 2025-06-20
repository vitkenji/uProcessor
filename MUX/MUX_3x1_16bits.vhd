library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_3x1_16bits is
    port (
        selector : in unsigned (1 downto 0);
        input_0, input_1, input_2 : in unsigned (15 downto 0);
        output : out unsigned (15 downto 0) 
    );
end entity;

architecture MUX_3x1_16bits_arch of MUX_3x1_16bits is
begin
    output <= input_0 when selector = "00" else
              input_1 when selector = "01" else
              input_2 when selector = "10" else
              (others => '0');
end architecture;