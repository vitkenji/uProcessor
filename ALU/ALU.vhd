library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector: in unsigned (1 downto 0);
        C, Z: out std_logic; 
        output : out unsigned (15 downto 0)
    );
end entity;

architecture ALU_arch of ALU is
begin
    output <= unsigned(input_0) + unsigned(input_1) when operation_selector = "00" else
              unsigned(input_0) - unsigned(input_1) when operation_selector = "01" else
              unsigned(input_0) and unsigned(input_1) when operation_selector = "10" else
              unsigned(input_0) xor unsigned(input_1) when operation_selector = "11" else
              "0000000000000000";

    Z <= '1' when unsigned(input_0) >= unsigned(input_1) else '0';
    C <= '1' when unsigned(input_0) <= unsigned(input_1) else '0';

end architecture;