library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main_tb is
end entity;

architecture Main_tb_arch of Main_tb is
    component Main
    port (
        clk, rst: in std_logic;
        prime_out: out unsigned(15 downto 0);
        exception: out std_logic
    );
    end component;

    constant period_time : time := 10 ns;
    signal finished : std_logic := '0';
    signal clk , reset : std_logic;
    signal prime_out : unsigned(15 downto 0); 
    signal exception_signal : std_logic; 
    
begin
    uut : Main port map(
        clk => clk,
        rst => reset,
        prime_out => prime_out,
        exception => exception_signal
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
        wait for 46 us;
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