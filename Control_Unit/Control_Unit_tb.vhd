library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit_tb is
end;

architecture Control_Unit_tb_arch of Control_Unit_tb is
    component Control_Unit
        port(
                instruction : in unsigned (16 downto 0);
                clk : in std_logic;
                rst : in std_logic;
                jump_enable : out std_logic
            );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk , reset, rst : std_logic;

    signal instruction : unsigned (16 downto 0);
    signal jump_enable : std_logic;

    begin
        uut : Control_Unit port map(
            clk => clk,
            rst => rst,
            instruction => instruction,
            jump_enable => jump_enable
        );
        
        reset_global : process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait;
    end process;

    sim_time_proc : process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc; 
    
    clk_proc : process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        instruction <= "00000000000011110";
        wait for 200 ns;
        instruction <= "00000000000011111";
        wait;
    end process;
end architecture;