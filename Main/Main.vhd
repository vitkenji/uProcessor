library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
    port (
        clk, rst : in std_logic
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
            data_in : in unsigned (6 downto 0);
            data_out : out unsigned (6 downto 0)
        );
    end component;

    component Adder
        port (
            data_in : in unsigned (6 downto 0);
            data_out : out unsigned (6 downto 0)
        );
    end component;    

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
            alu_result : out unsigned (15 downto 0)
        );
     end component;

    -- Sinais de interconexão
    signal pc_out, adder_out, mux_jump_out: unsigned (6 downto 0);
    signal rom_out, ir_out: unsigned (16 downto 0);
    signal accumulator_out, alu_out, bank_register_out, mux_acc_out : unsigned (15 downto 0);

    -- Sinais de controle da Control_Unit
    signal jump_enable : std_logic;
    signal mov_enable_accumulator : std_logic;
    signal pc_write_enable : std_logic;
    signal ir_write_enable : std_logic;
    signal accumulator_write_enable : std_logic;
    signal reg_write_enable : std_logic;
    signal destino_jump : unsigned (6 downto 0);
    signal reg_data_write : unsigned (15 downto 0);
    signal reg_write : unsigned (2 downto 0);
    signal reg_read : unsigned (2 downto 0);
    signal ALU_operation : unsigned (2 downto 0);

    -- Flags da ALU
    signal carry, sinal, zero : std_logic;

    begin
        uut_MUX_jump : MUX_2x1_7bits port map (
            selector => jump_enable,
            input_0 => adder_out,
            input_1 => destino_jump,  -- Usando destino_jump da Control_Unit
            output => mux_jump_out
        );

        uut_MUX_acc : MUX_2x1_16bits port map (
            selector => mov_enable_accumulator,
            input_0 => alu_out,  -- Para ADD/SUB vem da ALU
            input_1 => bank_register_out,  -- Para MOV vem do banco de registradores
            output => mux_acc_out
        );

        uut_PC : PC port map (
            clk => clk,
            rst => rst,
            write_enable => pc_write_enable,
            data_in => mux_jump_out,
            data_out => pc_out
        );
        
        uut_Adder : Adder port map (
            data_in => pc_out,
            data_out => adder_out
        );

        uut_ROM : ROM port map (
            clk => clk,
            address => pc_out,
            data => rom_out
        );

        uut_Control_Unit : Control_Unit port map (
            clk => clk,
            rst => rst,
            instruction => ir_out,  -- Usando instrução do IR, não diretamente da ROM
            accumulator_out => accumulator_out,
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

        uut_Instruction_Register : Instruction_Register port map (
            clk => clk,
            rst => rst,
            write_enable => ir_write_enable,
            instruction_in => rom_out,
            instruction_out => ir_out
        );

        uut_Accumulator : Accumulator port map (
            clk => clk,
            rst => rst,
            write_enable => accumulator_write_enable,
            data_in => mux_acc_out,  -- Para ADD/SUB vem da ALU e para MOV vem do banco de registradores
            data_out => accumulator_out
        );

        uut_ALU : ALU port map (
            input_0 => accumulator_out,  -- Acumulador como primeiro operando
            input_1 => bank_register_out,  -- Registrador como segundo operando
            operation_selector => ALU_operation,
            carry => carry,
            sinal => sinal,
            zero => zero,
            alu_result => alu_out
        );

        uut_bancoReg : bancoReg port map (
            clk => clk,
            rst => rst,
            reg_read => reg_read,  -- Endereço vem da Control_Unit
            data_out => bank_register_out,
            write_enable => reg_write_enable,
            reg_write => reg_write,  -- Endereço vem da Control_Unit
            data_write => reg_data_write  -- Dados vem da Control_Unit
        );

end architecture;