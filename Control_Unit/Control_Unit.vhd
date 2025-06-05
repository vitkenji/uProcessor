library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit is
    port(
        instruction : in unsigned (16 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        jump_enable : out std_logic;
        pc_write_enable : out std_logic
    );
end entity;

architecture Control_Unit_arch of Control_Unit is
    component State_Machine
    port(
        clk : in std_logic;
        rst : in std_logic;
        state : out std_logic
    );
    end component;

    signal opcode : unsigned (3 downto 0);
    signal state_s : std_logic;

    begin

        uut_state_machine : State_Machine port map (
            clk => clk,
            rst => rst,
            state => state_s
        );

        opcode <= instruction (3 downto 0);
        jump_enable <= '1' when state_s = '1' and opcode = "1111" else
                       '0'; 
        pc_write_enable <= '1' when state_s = '1' else
                            '0';

end architecture;