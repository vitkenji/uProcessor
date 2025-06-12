library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit_tb is
end entity;

architecture Control_Unit_tb_arch of Control_Unit_tb is

    component Control_Unit
    port(
        instruction : in unsigned (16 downto 0);
        accumulator_out : in unsigned (15 downto 0);
        clk : in std_logic;
        rst : in std_logic;

        -- Sinais de controle
        jump_enable : out std_logic;
        mov_enable_accumulator : out std_logic;
        pc_write_enable : out std_logic;
        ir_write_enable : out std_logic;
        accumulator_write_enable : out std_logic;
        reg_write_enable : out std_logic;
        -- Dados de controle
        destino_jump : out unsigned (6 downto 0);
        reg_data_write : out unsigned (15 downto 0);
        reg_write : out unsigned (2 downto 0);
        reg_read : out unsigned (2 downto 0); 
        ALU_operation : out unsigned (2 downto 0)
    );
    end component;

    constant clk_period : time := 100 ns;
    constant clk_period_max : time := 20 us;
    signal finished : std_logic := '0';

    -- Variáveis locais
    signal clk, rst : std_logic;
    signal instruction : unsigned(16 downto 0);
    signal accumulator_out : unsigned(15 downto 0);
    
    -- Sinais de saída
    signal jump_enable : std_logic;
    signal mov_enable_accumulator : std_logic;
    signal pc_write_enable : std_logic;
    signal ir_write_enable : std_logic;
    signal accumulator_write_enable : std_logic;
    signal reg_write_enable : std_logic;
    signal destino_jump : unsigned(6 downto 0);
    signal reg_data_write : unsigned(15 downto 0);
    signal reg_write : unsigned(2 downto 0);
    signal reg_read : unsigned(2 downto 0);
    signal ALU_operation : unsigned(2 downto 0);

begin
    uut: Control_Unit port map (
        instruction => instruction,
        accumulator_out => accumulator_out,
        clk => clk,
        rst => rst,
        jump_enable => jump_enable,
        mov_enable_accumulator => mov_enable_accumulator,
        pc_write_enable => pc_write_enable,
        ir_write_enable => ir_write_enable,
        accumulator_write_enable => accumulator_write_enable,
        reg_write_enable => reg_write_enable,
        destino_jump => destino_jump,
        reg_data_write => reg_data_write,
        reg_write => reg_write,
        reg_read => reg_read,
        ALU_operation => ALU_operation
    );
 
    -- Processo que termina a simulação
    time_total_simulation: process
    begin
        wait for clk_period_max;
        finished <= '1';
        wait;
    end process time_total_simulation;

    -- Processo que gera o clock
    clk_process: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait; 
    end process clk_process;

    -- Teste da Control Unit
    process
    begin
        -- Inicialização
        rst <= '1';
        instruction <= (others => '0');
        --accumulator_out <= "0000000000001111"; -- 15
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- Estado FETCH: ir_write_enable deve ser '1'
        -- Qualquer instrução no estado 00 (FETCH)
        instruction <= "11110000000000000"; -- JUMP exemplo
        wait for clk_period * 3; -- 3 clocks para completar ciclo fetch->decode->execute

        -- Teste 1: JUMP (opcode = "1111")
        -- Instrução: 1111 0101010 000000
        -- Espera: jump_enable = '1', destino_jump = "0101010", pc_write_enable = '1'
        instruction <= "11110101010000000";
        wait for clk_period * 3;

        -- Teste 2: LOAD (opcode = "0001") 
        -- Instrução: 0001 010 0000000101
        -- Espera: reg_write_enable = '1', reg_write = "010", reg_data_write = extensão de sinal de 5
        instruction <= "00010100000000101";
        wait for clk_period * 3;

        -- Teste 3: LOAD com número negativo
        -- Instrução: 0001 011 1000000101 (bit 9 = 1, número negativo)
        -- Espera: reg_write_enable = '1', reg_write = "011", reg_data_write com extensão negativa
        instruction <= "00010111000000101";
        wait for clk_period * 3;

        -- Teste 4: MOV_ACC (opcode = "0100")
        -- Instrução: 0100 101 0000000000
        -- Espera: accumulator_write_enable = '1', reg_read = "101", mov_enable_accumulator = '1'
        instruction <= "01001010000000000";
        wait for clk_period * 3;

        -- Teste 5: MOV_REG (opcode = "0110")
        -- Instrução: 0110 001 0000000000
        -- Espera: reg_write_enable = '1', reg_write = "001", reg_data_write = accumulator_out
        instruction <= "01100010000000000";
        wait for clk_period * 3;

        -- Teste 6: ADD (opcode = "0010")
        -- Instrução: 0010 011 0000000000
        -- Espera: reg_read = "011", ALU_operation = "010", accumulator_write_enable = '1'
        instruction <= "00100110000000000";
        wait for clk_period * 3;

        -- Teste 7: SUB (opcode = "0011")
        -- Instrução: 0011 100 0000000000
        -- Espera: reg_read = "100", ALU_operation = "011", accumulator_write_enable = '1'
        instruction <= "00111000000000000";
        wait for clk_period * 3;

        -- Teste 8: COMP (opcode = "0101")
        -- Instrução: 0101 111 0000000000
        -- Espera: reg_read = "111", ALU_operation = "001", accumulator_write_enable = '0'
        instruction <= "01011110000000000";
        wait for clk_period * 3;

        -- Teste 9: Opcode inválido (opcode = "1000")
        -- Instrução: 1000 000 0000000000
        -- Espera: todos os sinais em '0' ou valores padrão
        instruction <= "10000000000000000";
        wait for clk_period * 3;

        -- Teste 10: Mudança de acumulador para testar MOV_REG
        accumulator_out <= "1010101010101010"; -- Novo valor do acumulador
        instruction <= "01100010000000000"; -- MOV_REG novamente
        wait for clk_period * 3;

        wait;
    end process;

end architecture;