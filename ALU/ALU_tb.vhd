library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end;

architecture ALU_tb_arch of ALU_tb is
    component ALU
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector : in unsigned (1 downto 0);
        carry, greater_equal, less_equal : out std_logic;
        output : out unsigned (15 downto 0)
    );
    end component;

    signal input_0, input_1 : unsigned (15 downto 0);
    signal operation_selector : unsigned (1 downto 0);
    signal carry, greater_equal, less_equal : std_logic;
    signal output : unsigned (15 downto 0);

    begin
        uut : ALU port map(
            input_0 => input_0,
            input_1 => input_1,
            operation_selector => operation_selector,
            carry => carry,
            greater_equal => greater_equal,
            less_equal => less_equal,
            output => output
        );
        process
        begin
            -- Caso de Teste 1: Soma
            -- Input_0: 7(0111) | Input_1: 1(0001) | Resultado esperado: 8(0000000000001000)
            operation_selector <= "00";
            input_0 <= "0000000000000111"; -- 7
            input_1 <= "0000000000000001"; -- 1
            wait for 20 ns;

            -- Caso de Teste 2: Subtração
            -- Input_0: 12(1100) | Input_1: 2(0010) | Resultado esperado: 10(0000000000001010)
            operation_selector <= "01";
            input_0 <= "0000000000001100"; -- 12
            input_1 <= "0000000000000010"; -- 2
            wait for 20 ns;

            -- Caso de Teste 3: And
            -- Input_0: 0010001101101110 | Input_1: 0100000101001111 | Resultado esperado: 0000000101001110
            operation_selector <= "10";
            input_0 <= "0010001101101110";
            input_1 <= "0100000101001111"; 
            wait for 20 ns;

            -- Caso de Teste 4: Xor
            -- Input_0: 0010001101101110 | Input_1: 0100000101001111 | Resultado esperado: 0110001000100001
            operation_selector <= "11";
            input_0 <= "0010001101101110";
            input_1 <= "0100000101001111"; 
            wait for 20 ns;

            -- Caso de Teste 5: Soma com carry | Resultado > 65535 (1111111111111111)
            -- Input_0: 50000(1100001101010000) | Input_1: 30000(0111010100110000) | Resultado esperado: 80000(0011100010000000 -> 14464 Sem o bit 16) e carry 1
            operation_selector <= "00";
            input_0 <= "1100001101010000";
            input_1 <= "0111010100110000"; 
            wait for 20 ns;

            -- Caso de Teste 6: Subtração com borrow (carry) | Quando Input_0 < Input_1 em uma subtração unsigned de 16 bits, ocorre um borrow e a flag carry é acionada. O sub_result é calculado como (Input_0 - Input_1) mod 2^17
            -- Input_0: 2(0000000000000010) | Input_1: 5(0000000000000101) | Resultado esperado: 2-5 mod 2^16(1111111111111101) e carry 1
            operation_selector <= "01";
            input_0 <= "0000000000000010";
            input_1 <= "0000000000000101"; 
            wait for 20 ns;

            -- Casos de Testes Extras

            -- Caso de Teste: Soma sem carry, porem próximo| Resultado < 65535 < 65500
            -- Input_0: 65500() | Input_1: 25() | Resultado esperado: 65525()
            
            -- Caso de Teste: Soma com carry, porem próximo| 66000 > Resultado > 65535
            -- Input_0: 65535() | Input_1: 100() | Resultado esperado: 65635()            

            wait;
        end process;
    end architecture;    