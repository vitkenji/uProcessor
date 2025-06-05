library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2x1_7bits is
    port (
        selector : in std_logic;
        input_0, input_1 : in unsigned (6 downto 0);
        output : out unsigned (6 downto 0) 
    );
end entity;

architecture MUX_2x1_7bits_arch of MUX_2x1_7bits is
begin
    output <= input_0 when selector = '0' else
              input_1 when selector = '1' else
              "0000000";
end architecture;