library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit is
    port(
        instruction : in unsigned (16 downto 0); -- Saída da ROM
        accumulator_out : in unsigned (15 downto 0); -- Saída do acumulador

        clk : in std_logic;
        rst : in std_logic;

        -- Sinais de controle
        jump_enable : out std_logic;
        mov_enable_accumulator : out std_logic; -- Habilita o MOV no acumulador
        pc_write_enable : out std_logic;
        ir_write_enable : out std_logic;
        accumulator_write_enable : out std_logic;
        reg_write_enable : out std_logic;

        -- Dados de controle
        destino_jump : out unsigned (6 downto 0);
        reg_data_write : out unsigned (15 downto 0); -- Dado a ser escrito no registrador
        reg_read : out unsigned (2 downto 0); 
        ALU_operation : out unsigned (2 downto 0)
    );
end entity;

architecture Control_Unit_arch of Control_Unit is

    -- Incluindo a máquina de estados [State 0 = Fetch (Leitura da Instrução na ROM), 1 = Decode (Decodificação da Instrução), 2 = Execute (Execução da Instrução)]
    component State_Machine
    port(
        clk : in std_logic;
        rst : in std_logic;
        state : out unsigned (1 downto 0)
    );
    end component;

    -- Operações da ALU
    constant ALU_ADD: unsigned (2 downto 0) := "010"; -- Operação de Adição
    constant ALU_SUB: unsigned (2 downto 0) := "011"; -- Operação de Subtração
    constant ALU_CMPR: unsigned (2 downto 0) := "001"; -- Operação de Comparação (Subtração para verificação de flags)

    -- Definição de opcodes
    constant JUMP_OP: unsigned (3 downto 0) := "1111"; -- Opcode para JUMP
    constant LD_OP: unsigned (3 downto 0) := "0001"; -- Opcode para LOAD
    constant MOV_ACC_OP: unsigned (3 downto 0) := "0100"; -- Opcode para MOV Accumulator
    constant MOV_REG_OP: unsigned (3 downto 0) := "0110"; -- Opcode para MOV Register
    constant ADD_OP: unsigned (3 downto 0) := "0010"; -- Opcode para ADD
    constant SUB_OP: unsigned (3 downto 0) := "0011"; -- Opcode para SUB
    constant COMP_OP: unsigned (3 downto 0) := "0101"; -- Opcode para COMPARAÇÃO

    -- Decodificação de Instruções
    signal opcode : unsigned (3 downto 0);
    signal reg: unsigned (2 downto 0); -- Registrador
    signal ld_constant: unsigned (9 downto 0); -- Constante Imediata
    signal jump_adress : unsigned (6 downto 0); -- Endereço de salto

    signal state_s : unsigned (1 downto 0);

    -- VARIÁVEIS AUXILIARES para evitar múltiplas atribuições
    signal reg_write_enable_ld : std_logic;
    signal reg_write_enable_mov : std_logic;
    signal accumulator_write_enable_mov : std_logic;
    signal accumulator_write_enable_add : std_logic;
    signal accumulator_write_enable_sub : std_logic;
    signal reg_read_mov : unsigned (2 downto 0);
    signal reg_read_add : unsigned (2 downto 0);
    signal reg_read_sub : unsigned (2 downto 0);
    signal reg_read_comp : unsigned (2 downto 0);
    signal reg_data_write_ld : unsigned (15 downto 0);
    signal reg_data_write_mov : unsigned (15 downto 0);
    signal ALU_operation_add : unsigned (2 downto 0);
    signal ALU_operation_sub : unsigned (2 downto 0);
    signal ALU_operation_comp : unsigned (2 downto 0);

    begin

        uut_state_machine : State_Machine port map (
            clk => clk,
            rst => rst,
            state => state_s
        );  

        -- [Fetch] Ler a ROM e armazenar a instrução
        ir_write_enable <= '1' when state_s = "00" else '0'; -- Armazeno a instrução em um registrador para utilizar no Execute

        -- [Decode] Identifica a instrução e produz os sinais de controle
        opcode <= instruction (16 downto 13); -- 4 bits Mais Significativos da Instrução
        reg <= instruction (12 downto 10); -- Não sei se precisa de um tratamento especial para registradores maiores que 5 (no meu banco so tenho de 0 a 5)
        ld_constant <= instruction (9 downto 0);
        jump_adress <= instruction (12 downto 6); -- 7 bits do endereço de salto

        -- [Execute] Executa as instruções

        -- Jump
        jump_enable <= '1' when state_s = "10" and opcode = JUMP_OP else '0'; 
        destino_jump <= jump_adress when state_s = "10" and opcode = JUMP_OP else (others => '0'); -- Define o destino do salto 

        -- Load [Carregar um valor imediato no registrador indicado]
        reg_write_enable_ld <= '1' when state_s = "10" and opcode = LD_OP else '0';
        reg_data_write_ld <= (15 downto 10 => ld_constant(9)) & ld_constant when state_s = "10" and opcode = LD_OP else (others => '0'); -- Extensão de sinal: replica o bit 9 (bit de sinal) para formar 16 bits

        -- Mov Acumulator
        accumulator_write_enable_mov <= '1' when state_s = "10" and opcode = MOV_ACC_OP else '0'; 
        reg_read_mov <= reg when state_s = "10" and opcode = MOV_ACC_OP else (others => '0'); 
        mov_enable_accumulator <= '1' when state_s = "10" and opcode = MOV_ACC_OP else '0'; -- Habilita o MOV no acumulador [O valor do acumulador será o da saída do banco de registradores]

        -- Mov Register
        reg_write_enable_mov <= '1' when state_s = "10" and opcode = MOV_REG_OP else '0';
        reg_data_write_mov <= accumulator_out when state_s = "10" and opcode = MOV_REG_OP else (others => '0'); -- Escreve o valor do acumulador no registrador

        -- ADD
        reg_read_add <= reg when state_s = "10" and opcode = ADD_OP else (others => '0'); -- Leitura do registrador para a operação de ADD
        ALU_operation_add <= ALU_ADD when state_s = "10" and opcode = ADD_OP else (others => '0'); -- Define a operação de ADD na ALU
        accumulator_write_enable_add <= '1' when state_s = "10" and opcode = ADD_OP else '0'; -- Habilita a escrita no acumulador após a operação de ADD

        -- SUB
        reg_read_sub <= reg when state_s = "10" and opcode = SUB_OP else (others => '0'); -- Leitura do registrador para a operação de SUB
        ALU_operation_sub <= ALU_SUB when state_s = "10" and opcode = SUB_OP else (others => '0'); -- Define a operação de SUB na ALU
        accumulator_write_enable_sub <= '1' when state_s = "10" and opcode = SUB_OP else '0'; -- Habilita a escrita no acumulador após a operação de SUB

        -- COMPARAÇÃO
        -- O objetivo da CMPR é comparar dois valores, alterando apenas as flags, sem modificar o valor de nenhum registrador.
        -- a ULA realiza uma subtração entre os operandos, mas não armazena o resultado em lugar nenhum. O resultado serve apenas para atualizar as flags (Zero, Sinal, Carry, Overflow)
        reg_read_comp <= reg when state_s = "10" and opcode = COMP_OP else (others => '0'); 
        ALU_operation_comp <= ALU_CMPR when state_s = "10" and opcode = COMP_OP else (others => '0'); -- Define a operação de comparação na ALU

        pc_write_enable <= '1' when state_s = "10" else '0'; -- Habilita a escrita no PC para a próxima instrução

        -- COMBINAÇÃO DOS SINAIS AUXILIARES
        reg_write_enable <= reg_write_enable_ld or reg_write_enable_mov;
        accumulator_write_enable <= accumulator_write_enable_mov or accumulator_write_enable_add or accumulator_write_enable_sub;
        reg_read <= reg_read_mov or reg_read_add or reg_read_sub or reg_read_comp;
        reg_data_write <= reg_data_write_ld or reg_data_write_mov;
        ALU_operation <= ALU_operation_add or ALU_operation_sub or ALU_operation_comp;

end architecture;