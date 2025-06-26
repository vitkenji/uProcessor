library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
    port (
        clk, rst : in std_logic;
        -- Novo pino para exibir o número primo atual
        primo_out : out unsigned(15 downto 0);
        -- Sinal de exceção para opcode inválido
        exception : out std_logic
    );
end entity;

architecture Main_arch of Main is
    
    component MUX_2x1_7bits
        port (
            selector : in std_logic;
            input_0, input_1 : in unsigned (6 downto 0);
            output : out unsigned (6 downto 0) 
        );
    end component;

    component MUX_2x1_16bits
        port (
            selector : in std_logic;
            input_0, input_1 : in unsigned (15 downto 0);
            output : out unsigned (15 downto 0) 
        );
    end component;

    component MUX_3x1_16bits
        port (
            selector : in unsigned (1 downto 0);
            input_0, input_1, input_2 : in unsigned (15 downto 0);
            output : out unsigned (15 downto 0) 
        );
    end component;

    component ROM
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(16 downto 0)
        );
    end component;

    component PC
        port (
            clk : in std_logic;
            rst : in std_logic;
            write_enable : in std_logic;
            pc_in : in unsigned (6 downto 0);
            pc_out : out unsigned (6 downto 0)
        );
    end component;

    component Adder
        port (
            data_in : in unsigned (6 downto 0);
            data_out : out unsigned (6 downto 0)
        );
    end component;
    
    component Branch_Adder
        port (
            delta : in unsigned (5 downto 0);
            current_address : in unsigned (6 downto 0);
            address_out : out unsigned (6 downto 0)
        );
    end component;

    component Control_Unit
        port(
            instruction : in unsigned (16 downto 0);
            clk : in std_logic;
            rst : in std_logic;
            
            -- Sinais de controle
            jump_enable, ble_enable, bhs_enable,
            pc_write_enable, ir_write_enable, accumulator_write_enable, 
            reg_write_enable, ram_write_enable : out std_logic;

            reg_data_write_selector : out std_logic;

            accumulator_selector : out unsigned (1 downto 0);
            -- Dados de controle
            ALU_operation : out unsigned (2 downto 0);
            flag_write_enable : out std_logic;
            -- Sinal de exceção
            exception : out std_logic
        );
    end component;

    component bancoReg
        port(
            clk: in std_logic;
            rst: in std_logic;
            reg_read: in unsigned(2 downto 0);
            data_out: out unsigned(15 downto 0); 
            write_enable: in std_logic;
            data_write: in unsigned(15 downto 0);
            reg_write: in unsigned(2 downto 0)
        );
    end component;

    component Instruction_Register
        port(
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic;
            instruction_in: in unsigned(16 downto 0);
            instruction_out: out unsigned(16 downto 0)
        );
    end component;

    component Accumulator
        port (
            clk: in std_logic;
            rst : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned (15 downto 0);
            data_out : out unsigned (15 downto 0)
        );
    end component;     
    
    component ALU
        port (
            input_0, input_1 : in unsigned (15 downto 0);
            operation_selector: in unsigned (2 downto 0);
            carry, sinal, zero: out std_logic;
            overflow : out std_logic;
            alu_result : out unsigned (15 downto 0)
        );
    end component;

    component RAM
        port (
            clk : in std_logic;
            address : in unsigned (15 downto 0);
            write_enable : in std_logic;
            ram_data_in : in unsigned (15 downto 0);
            ram_data_out : out unsigned (15 downto 0) 
        );
    end component;    
    
    component flagReg
        port(
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic;
            flag_in: in std_logic;
            flag_out: out std_logic
        );
    end component;

    component reg16bits
        port(
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;
    
    -- Sinais de interconexão
    signal pc_out, adder_out, branch_adder_out, mux_jump_out, mux_branch_out: unsigned (6 downto 0);
    signal rom_out, ir_out: unsigned (16 downto 0);    
    signal accumulator_out, alu_out, bank_register_out, mux_acc_out, mux_reg_data_write_out, ram_data_out : unsigned (15 downto 0);
    signal primo_reg_out : unsigned(15 downto 0);

    -- Sinais de controle da Control_Unit
    signal jump_enable, ble_enable, bhs_enable,pc_write_enable, ir_write_enable, accumulator_write_enable, reg_write_enable, reg_data_write_selector, ram_write_enable : std_logic;
    
    signal accumulator_selector : unsigned (1 downto 0);
    signal ALU_operation : unsigned (2 downto 0);    
    signal branch_enable : std_logic;
    signal input_constant_LD : unsigned (15 downto 0);-- Flags da ALU
    signal carry, sinal, zero, overflow, zero_out, carry_out, sinal_out, overflow_out : std_logic;

    -- Sinal para controle de escrita das flags
    signal flag_write_enable : std_logic;
    signal primo_reg_we : std_logic;
    signal exception_signal : std_logic;
    
    begin
        ------------------------------------------
        -- INSTRUÇÃO --
        ------------------------------------------
        
        uut_PC : PC port map (
            clk => clk,
            rst => rst,
            write_enable => pc_write_enable,
            pc_in => mux_jump_out,
            pc_out => pc_out
        );
        
        -- Incrementador do PC
        uut_Adder : Adder port map (
            data_in => pc_out,
            data_out => adder_out
        );
        
        -- Somador para cálculo de branch relativo        
        uut_Branch_Adder : Branch_Adder port map (
            delta => ir_out(12 downto 7),
            current_address => pc_out,
            address_out => branch_adder_out
        );
        
        uut_ROM : ROM port map (
            clk => clk,
            address => pc_out,
            data => rom_out
        );
        
        uut_Instruction_Register : Instruction_Register port map (
            clk => clk,
            rst => rst,
            write_enable => ir_write_enable,
            instruction_in => rom_out,
            instruction_out => ir_out
        );

        ------------------------------------------
        -- LÓGICA DE SALTO --
        ------------------------------------------
        
        -- Branch é ativado com base nas flags da operação anterior da ALU (CMP, ADD, SUB)
        -- BLE (Branch if Less or Equal): Salta se Z=1 OU N≠V (Zero -> Os valores comparados são iguais | Se o sinal for negativo (N=1) e não houve overflow (V=0), ou se o sinal for positivo (N=0) e houve overflow (V=1): O primeiro operando é menor.)
        -- BHS (Branch if Higher or Same): Salta se C=1 (C = 1 -> A < B, e sempre CMP vai ser acc - reg, então c=1 signifiica que acc < reg = reg > acc )
        branch_enable <= '1' when ble_enable = '1' and (zero_out = '1' or sinal_out /= overflow_out) else 
                         '1' when bhs_enable = '1' and carry_out = '1' else '0';

        -- Seleção entre próxima instrução ou salto
        uut_MUX_branch : MUX_2x1_7bits port map (
            selector => branch_enable,
            input_0 => adder_out,
            input_1 => branch_adder_out, 
            output => mux_branch_out
        );
        
        -- Seleção entre branch e jump
        uut_MUX_jump : MUX_2x1_7bits port map (
            selector => jump_enable,
            input_0 => mux_branch_out,
            input_1 => ir_out(12 downto 6),
            output => mux_jump_out
        );
        
        ------------------------------------------
        -- UNIDADE DE CONTROLE --
        ------------------------------------------
        
        uut_Control_Unit : Control_Unit port map (
            clk => clk,
            rst => rst,
            instruction => ir_out,  -- Usando instrução do IR, não diretamente da ROM
            jump_enable => jump_enable,
            ble_enable => ble_enable,
            bhs_enable => bhs_enable,
            accumulator_selector => accumulator_selector,
            pc_write_enable => pc_write_enable,
            ir_write_enable => ir_write_enable,            
            accumulator_write_enable => accumulator_write_enable,
            reg_write_enable => reg_write_enable,
            reg_data_write_selector => reg_data_write_selector,
            ram_write_enable => ram_write_enable,
            ALU_operation => ALU_operation,
            flag_write_enable => flag_write_enable,
            exception => exception_signal
        );
        
        ------------------------------------------
        -- DADOS --
        ------------------------------------------
        
        uut_bancoReg : bancoReg port map (
            clk => clk,
            rst => rst,
            reg_read => ir_out(12 downto 10),
            data_out => bank_register_out,
            write_enable => reg_write_enable,
            reg_write => ir_out(12 downto 10),
            data_write => mux_reg_data_write_out
        );
        
        uut_Accumulator : Accumulator port map (
            clk => clk,
            rst => rst,
            write_enable => accumulator_write_enable,
            data_in => mux_acc_out,  -- Para ADD/SUB vem da ALU e para MOV vem do banco de registradores
            data_out => accumulator_out
        );  
        
        uut_ALU : ALU port map (
            input_0 => accumulator_out,
            input_1 => bank_register_out,  
            operation_selector => ALU_operation,
            carry => carry,
            sinal => sinal,
            zero => zero,
            overflow => overflow,
            alu_result => alu_out
        );

        -- Registradores de flags
        uut_flagReg_zero : flagReg port map (
            clk => clk,
            rst => rst,
            write_enable => flag_write_enable,
            flag_in => zero,
            flag_out => zero_out
        );
        
        uut_flagReg_carry : flagReg port map (
            clk => clk,
            rst => rst,
            write_enable => flag_write_enable,
            flag_in => carry,
            flag_out => carry_out
        );

        uut_flagReg_sinal : flagReg port map (
            clk => clk,
            rst => rst,
            write_enable => flag_write_enable,
            flag_in => sinal,
            flag_out => sinal_out
        );

        uut_flagReg_overflow : flagReg port map (
            clk => clk,
            rst => rst,
            write_enable => flag_write_enable,
            flag_in => overflow,
            flag_out => overflow_out
        );
        
        uut_RAM : RAM port map (
            clk => clk,
            address => bank_register_out,
            write_enable => ram_write_enable,
            ram_data_in => accumulator_out,
            ram_data_out => ram_data_out 
        );
        
        -- Write enable para o registrador de primos: só ativa quando RAM[0] está sendo lido
        primo_reg_we <= '1' when bank_register_out = 0 else '0';
        
        uut_primoReg : reg16bits port map (
            clk => clk,
            rst => rst,
            write_enable => primo_reg_we,
            data_in => ram_data_out,
            data_out => primo_reg_out
        );
        
        primo_out <= primo_reg_out;
        
        ------------------------------------------
        -- MULTIPLEXADORES DE DADOS --
        ------------------------------------------
        
        -- Preparação de dados para operações de load imediato
        input_constant_LD <= (15 downto 10 => ir_out(9)) & ir_out(9 downto 0);
        
        -- Seleção de entrada para o acumulador (ALU, banco de registradores ou RAM)
        uut_MUX_acc : MUX_3x1_16bits port map (
            selector => accumulator_selector,
            input_0 => alu_out,  -- Para ADD/SUB vem da ALU
            input_1 => bank_register_out,  -- Para MOV vem do banco de registradores
            input_2 => ram_data_out, -- Para LW vem da RAM
            output => mux_acc_out
        );        
        
        -- Seleção de dados para escrita no banco de registradores
        uut_MUX_reg_data_write : MUX_2x1_16bits port map (
            selector => reg_data_write_selector,
            input_0 => input_constant_LD, -- Para LD (constante imediata)
            input_1 => accumulator_out,   -- Para MOV Rn (valor do acumulador)
            output => mux_reg_data_write_out
        );
        
        -- Conecta o sinal de exceção à saída
        exception <= exception_signal;

end architecture;