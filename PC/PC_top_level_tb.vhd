library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_top_level_tb is
end entity;

architecture PC_top_level_tb_arch of PC_top_level_tb is
    component PC_top_level
        port (
            clk           : in std_logic;
            rst           : in std_logic;
            write_enable  : in std_logic;
            top_data_in   : in unsigned (6 downto 0);
            top_data_out  : out unsigned (6 downto 0)
        );
    end component;

    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal write_enable  : std_logic := '0';
    signal top_data_in   : unsigned(6 downto 0) := (others => '0');
    signal top_data_out  : unsigned(6 downto 0);

    constant period_time : time := 100 ns;

begin
    uut: PC_top_level
        port map (
            clk           => clk,
            rst           => rst,
            write_enable  => write_enable,
            top_data_in   => top_data_in,
            top_data_out  => top_data_out
        );

    clk_process : process
    begin
        while now < 2000 ns loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for period_time;
        rst <= '0';

        write_enable <= '1';
        top_data_in <= "0000000"; 
        wait for period_time;

        for i in 0 to 5 loop
            wait for period_time;
        end loop;
        write_enable <= '0';
        wait for 3 * period_time;

        write_enable <= '1';
        wait for 3 * period_time;

        wait;
    end process;

end architecture;
