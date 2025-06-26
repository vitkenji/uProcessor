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
        overflow : out std_logic;
        alu_result: out unsigned (15 downto 0)
    );
    end component;

    signal input_0, input_1 : unsigned (15 downto 0);
    signal operation_selector : unsigned (2 downto 0);
    signal carry, sinal, zero : std_logic;
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
        overflow => overflow,
        alu_result => alu_result
    );
    
    process
    begin
        
        -- Testar o AND
        operation_selector <= "110"; -- AND
        input_0 <= to_unsigned(12, 16); -- 1000
        input_1 <= to_unsigned(10, 16); -- 1010
        wait for 10 ns;
        -- Resultado esperado: 
        
        
        -- Teste 1: Soma simples (carry=0, zero=0, sinal=0, overflow=0)
        operation_selector <= "010"; -- soma
        input_0 <= to_unsigned(5, 16);
        input_1 <= to_unsigned(3, 16);
        wait for 10 ns;

        -- Teste 2: Soma com carry (carry=1, overflow=0)
        operation_selector <= "010";
        input_0 <= to_unsigned(65535, 16); -- maior valor
        input_1 <= to_unsigned(1, 16);
        wait for 10 ns;

        -- Teste 3: Soma com overflow (overflow=1)
        operation_selector <= "010";
        input_0 <= to_unsigned(32767, 16); -- maior positivo
        input_1 <= to_unsigned(1, 16);
        wait for 10 ns;

        -- Teste 4: Subtração sem borrow (carry=0, zero=0, sinal=0)
        operation_selector <= "011";
        input_0 <= to_unsigned(10, 16);
        input_1 <= to_unsigned(5, 16);
        wait for 10 ns;

        -- Teste 5: Subtração com borrow (carry=1, sinal=1)
        operation_selector <= "011";
        input_0 <= to_unsigned(5, 16);
        input_1 <= to_unsigned(10, 16);
        wait for 10 ns;

        -- Teste 6: Resultado zero (zero=1)
        operation_selector <= "011";
        input_0 <= to_unsigned(8, 16);
        input_1 <= to_unsigned(8, 16);
        wait for 10 ns;

        -- Teste 7: Overflow na subtração (overflow=1)
        operation_selector <= "011";
        input_0 <= to_unsigned(32768, 16); -- menor negativo (em signed)
        input_1 <= to_unsigned(1, 16);
        wait for 10 ns;

        -- Teste 8: Comparação
        operation_selector <= "001";
        input_0 <= to_unsigned(3, 16);
        input_1 <= to_unsigned(8, 16);
        wait for 10 ns;

        -- Teste 9: Comparação 
        operation_selector <= "001";
        input_0 <= to_unsigned(8, 16);
        input_1 <= to_unsigned(8, 16);
        wait for 10 ns;

        -- Teste 10: Comparação
        operation_selector <= "001";
        input_0 <= to_unsigned(10, 16);
        input_1 <= to_unsigned(5, 16);
        wait for 10 ns;

        wait;
    end process;
end architecture;