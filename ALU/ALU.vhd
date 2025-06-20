library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Operações da ALU
-- 10 -> soma [1+0 = 1; 0+1 = 1; 0+0 = 0; 1+1 = 10;]
-- 11 -> subtração [1-0 = 1; 0-1 = 1; 1-1 = 0; 0-0 = 0]

entity ALU is
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector: in unsigned (2 downto 0);
        carry, sinal, zero: out std_logic;
        less_equal, higher_same : out std_logic;
        alu_result : out unsigned (15 downto 0)
    );
end entity;

architecture ALU_arch of ALU is
    signal sum_result_17bits, sub_result_17bits : unsigned(16 downto 0);
    signal result_internal : unsigned(15 downto 0);
begin

    -- Operações com 17 bits para detectar carry/borrow
    sum_result_17bits <= ('0' & input_0) + ('0' & input_1);
    sub_result_17bits <= ('0' & input_0) - ('0' & input_1);

    -- Resultado da ALU
    result_internal <= sum_result_17bits(15 downto 0) when operation_selector = "010" else
                      sub_result_17bits(15 downto 0) when operation_selector = "011" else
                      sub_result_17bits(15 downto 0) when operation_selector = "001" else -- Comparação (subtração sem armazenar)
                      (others => '0');
    
    alu_result <= result_internal;

    -- Flag Zero
    zero <= '1' when result_internal = "0000000000000000" else '0';

    less_equal <= '1' when input_0 <= input_1 else '0';

    higher_same <= '1' when input_0 >= input_1 else '0';

    -- Flag Sinal (bit mais significativo)
    sinal <= result_internal(15);

    -- Flag Carry
    carry <= sum_result_17bits(16) when operation_selector = "010" else
             sub_result_17bits(16) when operation_selector = "011" or operation_selector = "001" else
             '0';

end architecture;