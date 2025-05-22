library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoReg_tb is
end bancoReg_tb;

architecture a_bancoReg_tb of bancoReg_tb is

    component bancoReg
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            reg_read    : in unsigned(2 downto 0);
            data_out    : out unsigned(15 downto 0);
            write_enable: in std_logic;
            data_write  : in unsigned(15 downto 0);
            reg_write   : in unsigned(2 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal reg_read    : unsigned(2 downto 0) := (others => '0');
    signal data_out    : unsigned(15 downto 0);
    signal write_enable: std_logic := '0';
    signal data_write  : unsigned(15 downto 0) := (others => '0');
    signal reg_write   : unsigned(2 downto 0) := (others => '0');
    signal finished    : std_logic := '0';

    constant clk_period      : time := 10 ns;
    constant total_sim_time  : time := 500 ns;

begin

    uut: bancoReg
        port map(
            clk          => clk,
            rst          => rst,
            reg_read     => reg_read,
            data_out     => data_out,
            write_enable => write_enable,
            data_write   => data_write,
            reg_write    => reg_write
        );

    clk_process : process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    sim_timer: process
    begin
        wait for total_sim_time;
        finished <= '1';
        wait;
    end process;

    stim_proc: process
        variable i : integer;
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        write_enable <= '1';
        for i in 0 to 7 loop
            data_write <= to_unsigned(i * 1000 + 123, 16);
            reg_write  <= to_unsigned(i, 3);
            wait for clk_period;
        end loop;

        write_enable <= '0';
        wait for clk_period;

        for i in 0 to 7 loop
            reg_read <= to_unsigned(i, 3);
            wait for clk_period;
        end loop;

        reg_read <= "011";
        wait for clk_period;

        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        for i in 0 to 7 loop
            reg_read <= to_unsigned(i, 3);
            wait for clk_period;
        end loop;

        wait;
    end process;

end a_bancoReg_tb;
