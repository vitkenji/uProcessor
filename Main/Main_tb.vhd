library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main_tb is
end entity;

architecture Main_tb_arch of Main_tb is
    component Main
    port (
        clk, rst: in std_logic
    );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk , reset : std_logic;
    
begin
    uut : Main port map(
        clk => clk,
        rst => reset
    );

    reset_global : process
    begin
        reset <= '1';
        wait for period_time * 3;
        reset <= '0';
        wait;
    end process;

    sim_time_proc : process
    begin
        wait for 100 us;
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


end architecture;