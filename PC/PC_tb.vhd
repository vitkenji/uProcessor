library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end;

architecture PC_tb_arch of PC_tb is
    component PC
    port (
        clk : in std_logic;
        rst : in std_logic;
        write_enable : in std_logic;
        data_in : in unsigned (6 downto 0);
        data_out : out unsigned (6 downto 0)
    );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk , reset, rst : std_logic;
    signal data_in : unsigned (6 downto 0);
    signal data_out : unsigned (6 downto 0);
    signal write_enable : std_logic;
    
begin
    uut : PC port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable,
        data_in => data_in,
        data_out => data_out
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
        data_in <= "0000000";
        wait for 200 ns;
        data_in <= "0000001";
        wait for 200 ns;
        data_in <= "0000010";
        wait for 200 ns;
        data_in <= "0000011";
        wait for 200 ns;
        data_in <= "0000100";
        wait;
    end process;
end architecture;