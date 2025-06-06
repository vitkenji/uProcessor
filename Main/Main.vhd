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
        clk : in std_logic;
        rst : in std_logic;
        jump_enable : out std_logic;
        pc_write_enable : out std_logic;
        ir_write_enable : out std_logic;
        accumulator_write_enable : out std_logic;
        register_write_enable : out std_logic;
        register_read_enable : out std_logic;
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
            carry, greater_equal, less_equal: out std_logic; 
            alu_result : out unsigned (15 downto 0)
        );
     end component;

    signal pc_out, adder_out, mux_jump_out: unsigned (6 downto 0);
    signal rom_out, ir_out: unsigned (16 downto 0);
    signal accumulator_out : unsigned (15 downto 0);
    signal alu_out : unsigned (15 downto 0);

    signal jump_enable : std_logic;
    signal pc_write_enable : std_logic;
    signal ir_write_enable : std_logic;
    signal accumulator_write_enable : std_logic;
    signal register_write_enable : std_logic;
    signal register_read_enable : std_logic;

    signal carry, greater_equal, less_equal : std_logic;

    signal ALU_operation : unsigned (2 downto 0);

    signal bank_register_out : unsigned (15 downto 0);

    begin
        uut_MUX_jump : MUX_2x1_7bits port map (
            selector => jump_enable,
            input_0 => adder_out,
            input_1 => rom_out(10 downto 4),
            output => mux_jump_out
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
            instruction => rom_out,
            jump_enable => jump_enable,
            pc_write_enable => pc_write_enable,
            ir_write_enable => ir_write_enable,
            accumulator_write_enable => accumulator_write_enable,
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
            data_in => alu_out,
            data_out => accumulator_out
        );

        uut_ALU : ALU port map (
            input_0 => bank_register_out,
            input_1 => accumulator_out,
            operation_selector => ALU_operation,
            carry => carry,
            greater_equal => greater_equal,
            less_equal => less_equal,
            alu_result => alu_out
        );

        uut_bancoReg : bancoReg port map (
            clk => clk,
            rst => rst,
            write_enable => register_write_enable,
            reg_write => rom_out(16 downto 14),
            data_write => rom_out (16 downto 1),
            reg_read => rom_out (16 downto 14),
            data_out => bank_register_out
        );

end architecture;