library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end;

architecture reg16bits_arch of reg16bits_tb is
    component reg16bits
    port(
        clk: in std_logic;
        rst: in std_logic;
        write_enable: in std_logic;
        data_in: in unsigned(15 downto 0);
        data_out: out unsigned(15 downto 0)
    );
    end component;

    constant clk_period : time := 100 ns;
    constant clk_period_max : time := 10 us;
    signal finished : std_logic := '0';

    -- Variáveis locais
    signal clk, rst, write_enable : std_logic;
    signal data_in : unsigned(15 downto 0);
    signal data_out : unsigned(15 downto 0);

begin
    uut: reg16bits port map (
        clk => clk,
        rst => rst,
        write_enable => write_enable,
        data_in => data_in,
        data_out => data_out
    );
 
    -- Unico processo que termina a simulação
    time_total_simulation: process
    begin
        wait for clk_period_max;
        finished <= '1';
        wait;
    end process time_total_simulation;

    -- Processo que gera o clock
    clk_process: process
    begin
        while finished /= '1' loop -- Enquanto finished não for '1' 
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait; 
    end process clk_process;

    -- Teste do registrador
    process
    begin
        -- Inicialização
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- Caso de Teste 1: Habilitar a escrita
        -- data_in: 0000000000000010 | Resultado esperado: 0000000000000010
        write_enable <= '1';
        data_in <= "0000000000001010"; -- 10
        wait for clk_period; 

        -- Caso de Teste 2: Desabilitar a escrita
        -- data_in: 0000000000000011 | Resultado esperado: 0000000000001010
        write_enable <= '0';
        data_in <= "0000000000000011"; -- 3
        wait for clk_period; 

        -- Caso de Teste 3: Numero grande
        -- data_in: 0011111111111111 | Resultado esperado: 0011111111111111
        write_enable <= '1';
        data_in <= "0011111111111111"; -- 16383
        wait for clk_period;

        -- Caso de Teste 4: Valor máximo
        -- data_in: 1111111111111111 | Resultado esperado: 1111111111111111
        data_in <= "1111111111111111"; -- 65535
        wait for clk_period;    

        -- Caso de Teste 5
        -- data_in: 1000000000000000 | Resultado esperado: 1000000000000000
        data_in <= "1000000000000000"; -- 32768
        wait for clk_period;

        -- Caso de Teste 6: Reset
        -- rst: 1 | Resultado esperado: 0000000000000000
        rst <= '1';
        wait for clk_period;

        -- Caso de Teste 7: Tentativa de escrita após reset
        -- data_in: 0000110100101010 | Resultado esperado: 0000000000000000
        data_in <= "0000110100101010"; -- 3370
        wait for clk_period;

        -- Caso de Teste 8: Mudar reset e escrever
        -- rst: 0 | data_in: 0000000000000001 | Resultado esperado: 0000000000000001
        rst <= '0';
        data_in <= "0000000000000001"; -- 1
        wait for clk_period;

        wait;
    end process;

end architecture;
