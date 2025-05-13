library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector: in unsigned (1 downto 0);
        carry, greater_equal, less_equal: out std_logic; 
        output : out unsigned (15 downto 0)
    );
end entity;

architecture ALU_arch of ALU is

    signal input_0_17bits, input_1_17bits, sum_result, sub_result : unsigned(16 downto 0);

begin
    input_0_17bits <= '0' & input_0;
    input_1_17bits <= '0' & input_1;
    
    sum_result <= input_0_17bits + input_0_17bits;
    sub_result <= input_0_17bits - input_1_17bits;

    output <= unsigned(input_0) + unsigned(input_1) when operation_selector = "00" else
              unsigned(input_0) - unsigned(input_1) when operation_selector = "01" else
              unsigned(input_0) and unsigned(input_1) when operation_selector = "10" else
              unsigned(input_0) xor unsigned(input_1) when operation_selector = "11" else
              "0000000000000000";

    carry <= sum_result(16) when operation_selector = "00" else 
             sub_result(16) when operation_selector = "01" else
             '0';

    greater_equal <= '1' when unsigned(input_0) >= unsigned(input_1) else '0';
    less_equal <= '1' when unsigned(input_0) <= unsigned(input_1) else '0';

end architecture;