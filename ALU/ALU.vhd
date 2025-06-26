library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Operações da ALU
-- 10 -> soma [1+0 = 1; 0+1 = 1; 0+0 = 0; 1+1 = 10;]
-- 11 -> subtração [1-0 = 1; 0-1 = 1; 1-1 = 0; 0-0 = 0]
-- 01 -> comparação (subtração sem armazenar)
-- 110 -> AND 
-- 111 -> OR
-- Carry (C)
-- Overflow	(V)
-- Zero	(Z)
-- Sinal/Negativo (N)

entity ALU is
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector: in unsigned (2 downto 0);
        carry, sinal, zero: out std_logic;
        overflow : out std_logic;  -- Nova porta para flag de overflow
        alu_result : out unsigned (15 downto 0)
    );
end entity;

architecture ALU_arch of ALU is
    signal sum_result_17bits, sub_result_17bits : unsigned(16 downto 0);
    signal result_internal, and_result, or_result : unsigned(15 downto 0);
    signal carry_soma, carry_sub : std_logic;
begin

    -- Operações com 17 bits para detectar carry
    sum_result_17bits <= ('0' & input_0) + ('0' & input_1);
    sub_result_17bits <= ('0' & input_0) - ('0' & input_1);
    and_result <= input_0 and input_1;  -- AND bit a bit
    or_result <= input_0 or input_1;    -- OR bit a bit
    
    -- Resultado da ALU
    result_internal <= sum_result_17bits(15 downto 0) when operation_selector = "010" else
                      sub_result_17bits(15 downto 0) when operation_selector = "011" else
                      sub_result_17bits(15 downto 0) when operation_selector = "001" else -- Comparação (subtração sem armazenar)
                      and_result when operation_selector = "110" else
                      or_result when operation_selector = "111" else
                      (others => '0');
    
    alu_result <= result_internal;

    -- Flags (Carry, zero, sinal, overflow) [BHS -> C == 1, BLE -> Z == 1 OR N != V]
    
    zero <= '1' when result_internal = "0000000000000000" else '0';
    sinal <= result_internal(15);
    carry_soma <= sum_result_17bits(16);

    -- For a subtraction, including the comparison instruction CMP and the negate instructions NEGS and NGCS, C is set to 0 if the subtraction produced a borrow (that is, an unsigned underflow), and to 1 otherwise.
    -- [Documentação ARM] Referência: https://developer.arm.com/documentation/100076/0100/A64-Instruction-Set-Reference/Condition-Codes/Carry-flag
    -- Em resumo: C é 1 se não houve borrow, e 0 caso contrário.
    carry_sub <= '1' when input_1 <= input_0 else '0';

    carry <= carry_soma when operation_selector = "010" else
             carry_sub  when operation_selector = "001" else
             '0';
             
    -- [OPERAÇÃO SIGNED] Flag Overflow (Se os sinais dos operandos e o sinal do resultado seguem um padrão impossível para a operação (como dois positivos gerando negativo), isso só pode ocorrer se houve estouro)
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