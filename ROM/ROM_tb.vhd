library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_tb is
end;

architecure ROM_tb_arch of ROM_tb is
    component ROM
    port (
        clk : in std_logic;
        address : in unsigned(6 downto 0);
        data : out unsigned(16 downto 0);
    );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk , reset : std_logic;
    signal address : unsigned (6 downto 0);
    signal data : unsigned (16 downto 0);

begin
    uut : ROM port map(
        clk => clk,
        address => address,
        data => data
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
        wait;
    end process;
end architecture ROM_tb_arch;