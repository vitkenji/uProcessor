library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Operações da ALU
-- 10 -> soma [1+0 = 1; 0+1 = 1; 0+0 = 0; 1+1 = 10;]
-- 11 -> subtração [1-0 = 1; 0-1 = 1; 1-1 = 0; 0-0 = 0]
-- Carry (C)
-- Overflow	(V)
-- Zero	(Z)
-- Sinal/Negativo (N)

entity ALU is
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector: in unsigned (2 downto 0);
        carry, sinal, zero: out std_logic;
        less_equal, higher_same : out std_logic;
        overflow : out std_logic;  -- Nova porta para flag de overflow
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

    -- Flags (Carry, zero, sinal, overflow)
    -- BHS -> C == 1 
    -- BLE -> Z == 1 OR N != V
    zero <= '1' when result_internal = "0000000000000000" else '0';

    less_equal <= '1' when input_0 <= input_1 else '0';

    higher_same <= '1' when input_0 >= input_1 else '0';

    -- Flag Sinal (bit mais significativo)
    sinal <= result_internal(15);

    -- Flag Carry
    carry <= sum_result_17bits(16) when operation_selector = "010" else
             sub_result_17bits(16) when operation_selector = "011" or operation_selector = "001" else
             '0';
             
    -- Flag Overflow (Se os sinais dos operandos e o sinal do resultado seguem um padrão impossível para a operação (como dois positivos gerando negativo), isso só pode ocorrer se houve estouro)
    -- Overflow na adição: Se ambos os operandos têm o mesmo sinal, mas o resultado tem sinal diferente
    -- Overflow na subtração: Se o primeiro operando tem sinal diferente do segundo, e o resultado tem o mesmo sinal do segundo
    overflow <= 
      -- Para adição (010)
      ((not input_0(15) and not input_1(15) and result_internal(15)) or -- Dois positivos dando negativo
       (input_0(15) and input_1(15) and not result_internal(15)))       -- Dois negativos dando positivo
       when operation_selector = "010" else
      -- Para subtração (011 ou 001)
      ((not input_0(15) and input_1(15) and result_internal(15)) or     -- Positivo menos negativo dando negativo
       (input_0(15) and not input_1(15) and not result_internal(15)))   -- Negativo menos positivo dando positivo
       when (operation_selector = "011" or operation_selector = "001") else
      '0';

end architecture;