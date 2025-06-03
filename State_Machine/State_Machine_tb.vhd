library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine_tb is
end;

architecture State_Machine_tb_arch of State_Machine_tb is
    component State_Machine
    port (
        clk : in std_logic;
        rst : in std_logic;
        state : out std_logic
    );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk , reset, rst : std_logic;
    signal state : std_logic;

begin
    uut : State_Machine port map (
        clk => clk,
        rst => rst,
        state => state
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
        wait for 200 ns;
        wait;
    end process;
end architecture;

