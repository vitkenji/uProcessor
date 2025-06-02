library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_top_level_tb is
end entity;

architecture PC_top_level_tb_arch of PC_top_level_tb is
    component PC_top_level
    port (
        clk, rst, write_enable, selector: in std_logic;
        top_data_in : in unsigned (6 downto 0);
        top_data_out : out unsigned (6 downto 0)
    );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk , reset, rst : std_logic;
    signal data_in : unsigned (6 downto 0);
    signal data_out : unsigned (6 downto 0);
    signal write_enable, selector : std_logic;
    
begin
    uut : PC_top_level port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable,
        selector => selector,
        top_data_in => data_in,
        top_data_out => data_out
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
        write_enable <= '1';
        selector <= '0';
        data_in <= "0001000";
        wait for 200 ns;
        selector <= '1';
        wait;
    end process;
end architecture;
