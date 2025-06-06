library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit is
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
end entity;

architecture Control_Unit_arch of Control_Unit is
    component State_Machine
    port(
        clk : in std_logic;
        rst : in std_logic;
        state : out unsigned (1 downto 0)
    );
    end component;

    signal opcode : unsigned (3 downto 0);
    signal state_s : unsigned (1 downto 0);

    begin

        uut_state_machine : State_Machine port map (
            clk => clk,
            rst => rst,
            state => state_s
        );

        opcode <= instruction (3 downto 0);

        ir_write_enable <= '1' when state_s = "00" else
                            '0';

        jump_enable <= '1' when state_s = "01" and opcode = "1111" else
                       '0';
                       
        pc_write_enable <= '1' when state_s = "01" else
                            '0';
                        
        accumulator_write_enable <= '1' when state_s = "10" else
                                    '0';

        ALU_operation <= "000" when state_s = "10" else
                         "001" when state_s = "10" else
                         "010" when state_s = "10" else
                         "011" when state_s = "10" else
                         "100";


end architecture;