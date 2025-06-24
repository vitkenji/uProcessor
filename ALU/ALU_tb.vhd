library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end;

architecture ALU_tb_arch of ALU_tb is
    component ALU
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector : in unsigned (2 downto 0);
        carry, sinal, zero : out std_logic;
        less_equal, higher_same : out std_logic;
        overflow : out std_logic;
        alu_result: out unsigned (15 downto 0)
    );
    end component;

    signal input_0, input_1 : unsigned (15 downto 0);
    signal operation_selector : unsigned (2 downto 0);
    signal carry, sinal, zero : std_logic;
    signal less_equal, higher_same : std_logic;
    signal overflow : std_logic;
    signal alu_result : unsigned (15 downto 0);

begin
    uut : ALU port map(
        input_0 => input_0,
        input_1 => input_1,
        operation_selector => operation_selector,
        carry => carry,
        sinal => sinal,
        zero => zero,
        less_equal => less_equal,
        higher_same => higher_same,
        overflow => overflow,
        alu_result => alu_result
    );
    
    process
    begin
        -- Caso de Teste 1: Soma
        -- Input_0: 7 | Input_1: 1 | Resultado esperado: 8
        operation_selector <= "010";
        input_0 <= "0000000000000111"; -- 7
        input_1 <= "0000000000000001"; -- 1
        wait for 20 ns;

        -- Caso de Teste 2: Subtração
        -- Input_0: 12 | Input_1: 2 | Resultado esperado: 10
        operation_selector <= "011";
        input_0 <= "0000000000001100"; -- 12
        input_1 <= "0000000000000010"; -- 2
        wait for 20 ns;

        -- Caso de Teste 3: Comparação (subtração para flags)
        -- Input_0: 5 | Input_1: 5 | Resultado esperado: 0, zero = '1'
        operation_selector <= "001";
        input_0 <= "0000000000000101"; -- 5
        input_1 <= "0000000000000101"; -- 5
        wait for 20 ns;

        -- Caso de Teste 4: Soma com carry
        -- Input_0: 50000 | Input_1: 30000 | Resultado esperado: overflow, carry = '1'
        operation_selector <= "010";
        input_0 <= "1100001101010000"; -- 50000
        input_1 <= "0111010100110000"; -- 30000
        wait for 20 ns;

        -- Caso de Teste 5: Subtração com borrow
        -- Input_0: 2 | Input_1: 5 | Resultado esperado: negativo, carry = '1', sinal = '1'
        operation_selector <= "011";
        input_0 <= "0000000000000010"; -- 2
        input_1 <= "0000000000000101"; -- 5
        wait for 20 ns;

        -- Caso de Teste 6: Resultado zero
        -- Input_0: 10 | Input_1: 10 | Resultado esperado: 0, zero = '1'
        operation_selector <= "011";
        input_0 <= "0000000000001010"; -- 10
        input_1 <= "0000000000001010"; -- 10
        wait for 20 ns;

        -- Caso de Teste 7: Resultado negativo (sinal = '1')
        -- Input_0: 5 | Input_1: 15 | Resultado esperado: negativo, sinal = '1'
        operation_selector <= "011";
        input_0 <= "0000000000000101"; -- 5
        input_1 <= "0000000000001111"; -- 15
        wait for 20 ns;

        -- Caso de Teste 8: Operação inválida
        -- operation_selector: "100" | Resultado esperado: 0
        operation_selector <= "100";
        input_0 <= "0000000000001111"; -- 15
        input_1 <= "0000000000000011"; -- 3
        wait for 20 ns;

        wait;
    end process;    
end architecture;