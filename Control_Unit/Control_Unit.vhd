library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit is
    port(
        instruction : in unsigned (16 downto 0); -- Saída da ROM

        clk : in std_logic;
        rst : in std_logic;

        jump_enable, ble_enable, bhs_enable,
        pc_write_enable, ir_write_enable, accumulator_write_enable, flag_write_enable,
        reg_write_enable, ram_write_enable: out std_logic;

        reg_data_write_selector : out std_logic;

        accumulator_selector : out unsigned (1 downto 0);

        ALU_operation : out unsigned (2 downto 0);

        exception : out std_logic
    );
end entity;

architecture Control_Unit_arch of Control_Unit is

    component State_Machine
    port(
        clk : in std_logic;
        rst : in std_logic;
        state : out unsigned (1 downto 0)
    );
    end component;

    constant ALU_ADD: unsigned (2 downto 0) := "010"; -- Operação de Adição
    constant ALU_SUB: unsigned (2 downto 0) := "011"; -- Operação de Subtração
    constant ALU_CMPR: unsigned (2 downto 0) := "001"; -- Operação de Comparação (Subtração para verificação de flags)
    constant ALU_AND: unsigned (2 downto 0) := "110"; -- Operação AND
    constant ALU_OR: unsigned (2 downto 0) := "111"; -- Operação OR

    -- Definição de opcodes
    constant JUMP_OP: unsigned (3 downto 0) := "1111"; -- Opcode para JUMP
    constant LD_OP: unsigned (3 downto 0) := "0001"; -- Opcode para LOAD
    constant MOV_ACC_OP: unsigned (3 downto 0) := "0100"; -- Opcode para MOV Accumulator
    constant MOV_REG_OP: unsigned (3 downto 0) := "0110"; -- Opcode para MOV Register
    
    constant ADD_OP: unsigned (3 downto 0) := "0010"; -- Opcode para ADD
    constant SUB_OP: unsigned (3 downto 0) := "0011"; -- Opcode para SUB
    constant AND_OP: unsigned (3 downto 0) := "1101"; -- Opcode para AND
    constant OR_OP: unsigned (3 downto 0) := "1110"; -- Opcode para OR

    constant COMP_OP: unsigned (3 downto 0) := "0101"; -- Opcode para COMPARAÇÃO
    constant BLE_OP : unsigned (3 downto 0) := "0111"; -- Opcode para BLE
    constant BHS_OP : unsigned (3 downto 0) := "1000"; -- Opcode para BHS
    constant SW_OP : unsigned (3 downto 0) := "1001"; -- Opcode para SW
    constant LW_OP : unsigned (3 downto 0) := "1010"; -- Opcode para LW

    signal opcode : unsigned (3 downto 0);
    signal reg: unsigned (2 downto 0); -- Registrador
    signal ld_constant: unsigned (9 downto 0); -- Constante Imediata
    signal jump_adress : unsigned (6 downto 0); -- Endereço de salto

    signal state_s : unsigned (1 downto 0);

    signal reg_write_enable_ld, reg_write_enable_mov, accumulator_write_enable_mov, 
        accumulator_write_enable_add, accumulator_write_enable_sub, 
        accumulator_write_enable_lw : std_logic;

    signal ALU_operation_add, ALU_operation_sub, ALU_operation_comp: unsigned (2 downto 0);
    
    signal invalid_opcode : std_logic;

    begin

        uut_state_machine : State_Machine port map (
            clk => clk,
            rst => rst,
            state => state_s
        );  

        ir_write_enable <= '1' when state_s = "00" else '0'; -- Armazeno a instrução em um registrador para utilizar no Execute

        opcode <= instruction (16 downto 13); -- 4 bits Mais Significativos da Instrução
        reg <= instruction (12 downto 10); 
        ld_constant <= instruction (9 downto 0);
        jump_adress <= instruction (12 downto 6); -- 7 bits do endereço de salto

        jump_enable <= '1' when state_s = "01" and opcode = JUMP_OP else '0';   

        ble_enable <= '1' when state_s = "01" and opcode = BLE_OP else '0';
        bhs_enable <= '1' when state_s = "01" and opcode = BHS_OP else '0';        
        
        invalid_opcode <= '0' when (opcode = LD_OP or opcode = ADD_OP or opcode = SUB_OP or 
                                   opcode = MOV_ACC_OP or opcode = COMP_OP or opcode = MOV_REG_OP or
                                   opcode = BLE_OP or opcode = BHS_OP or opcode = SW_OP or
                                   opcode = LW_OP or opcode = AND_OP or opcode = OR_OP or
                                   opcode = JUMP_OP or opcode = "0000") else '1'; -- 0000 é por conta da instrução NOP
        
        exception <= invalid_opcode;
        
        pc_write_enable <= '1' when (state_s = "01" and invalid_opcode = '0') else '0'; -- Habilita a escrita no PC para a próxima instrução

        reg_write_enable_ld <= '1' when state_s = "10" and opcode = LD_OP else '0';
     
        accumulator_write_enable_mov <= '1' when state_s = "10" and opcode = MOV_ACC_OP else '0';
        accumulator_selector <= "01" when state_s = "10" and opcode = MOV_ACC_OP else -- Habilita o MOV no acumulador [O valor do acumulador será o da saída do banco de registradores]
                                  "10" when state_s = "10" and opcode = LW_OP else "00";

        reg_write_enable_mov <= '1' when state_s = "10" and opcode = MOV_REG_OP else '0';
   
        ALU_operation_add <= ALU_ADD when state_s = "10" and opcode = ADD_OP else (others => '0'); -- Define a operação de ADD na ALU
        accumulator_write_enable_add <= '1' when state_s = "10" and opcode = ADD_OP else '0'; -- Habilita a escrita no acumulador após a operação de ADD

        ALU_operation_sub <= ALU_SUB when state_s = "10" and opcode = SUB_OP else (others => '0'); -- Define a operação de SUB na ALU
        accumulator_write_enable_sub <= '1' when state_s = "10" and opcode = SUB_OP else '0'; -- Habilita a escrita no acumulador após a operação de SUB

        accumulator_write_enable_lw <= '1' when state_s = "10" and opcode = LW_OP else '0';

        ALU_operation_comp <= ALU_CMPR when state_s = "10" and opcode = COMP_OP else (others => '0'); -- Define a operação de comparação na ALU

        reg_data_write_selector <= '1' when state_s = "10" and opcode = MOV_REG_OP else '0'; 

        ram_write_enable <= '1' when state_s = "10" and opcode = SW_OP else '0';

        reg_write_enable <= reg_write_enable_ld or reg_write_enable_mov;
        accumulator_write_enable <= accumulator_write_enable_mov or accumulator_write_enable_add or accumulator_write_enable_sub or accumulator_write_enable_lw;
        
        ALU_operation <= ALU_operation_add or ALU_operation_sub or ALU_operation_comp;
        flag_write_enable <= '1' when state_s = "10" and (opcode = COMP_OP or opcode = ADD_OP or opcode = SUB_OP or opcode = AND_OP or opcode = OR_OP) else '0'; -- Habilita a escrita nas flags apenas nas operações da ULA
end architecture;