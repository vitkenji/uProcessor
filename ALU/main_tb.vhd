library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end entity;

architecture main_tb_arch of main_tb is

    component main
        port(
            clk                : in std_logic;
            rst                : in std_logic;
            write_enable_A     : in std_logic;
            write_enable_regs  : in std_logic;
            reg_read           : in unsigned(2 downto 0);
            reg_write          : in unsigned(2 downto 0);
            data_write         : in unsigned(15 downto 0);
            operation_selector : in unsigned(1 downto 0);
            carry              : out std_logic;
            greater_equal      : out std_logic;
            less_equal         : out std_logic;
            saida              : out unsigned(15 downto 0)
        );
    end component;

    signal clk               : std_logic := '0';
    signal rst               : std_logic := '0';
    signal write_enable_A    : std_logic := '0';
    signal write_enable_regs : std_logic := '0';
    signal reg_read          : unsigned(2 downto 0) := (others => '0');
    signal reg_write         : unsigned(2 downto 0) := (others => '0');
    signal data_write        : unsigned(15 downto 0) := (others => '0');
    signal operation_selector: unsigned(1 downto 0) := (others => '0');
    signal carry             : std_logic;
    signal greater_equal     : std_logic;
    signal less_equal        : std_logic;
    signal saida             : unsigned(15 downto 0);
    signal finished          : std_logic := '0';

    constant clk_period : time := 10 ns;

begin

    uut: main
        port map(
            clk                => clk,
            rst                => rst,
            write_enable_A     => write_enable_A,
            write_enable_regs  => write_enable_regs,
            reg_read           => reg_read,
            reg_write          => reg_write,
            data_write         => data_write,
            operation_selector => operation_selector,
            carry              => carry,
            greater_equal      => greater_equal,
            less_equal         => less_equal,
            saida              => saida
        );


    clk_process: process
    begin
        while finished = '0' loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    sim_timer: process
    begin
        wait for 2000 ns;
        finished <= '1';
        wait;
    end process;


    stim_proc: process
    begin
        rst <= '1';
        wait for 2 * clk_period;
        rst <= '0';
        wait for 2 * clk_period;

        write_enable_A <= '1';
        operation_selector <= "00";
        reg_read <= "111";
        wait for clk_period;
        write_enable_A <= '0';
        wait for 2 * clk_period;

        write_enable_regs <= '1';
        reg_write <= "000";
        data_write <= to_unsigned(10, 16);
        wait for clk_period;
        write_enable_regs <= '0';
        wait for clk_period;

        write_enable_regs <= '1';
        reg_write <= "001";
        data_write <= to_unsigned(5, 16);
        wait for clk_period;
        write_enable_regs <= '0';
        wait for clk_period;

        reg_read <= "000";
        operation_selector <= "00";
        wait for clk_period;
        
        write_enable_A <= '1';
        wait for clk_period;
        write_enable_A <= '0';
        wait for 2 * clk_period;

        reg_read <= "001";
        operation_selector <= "00";
        wait for clk_period;
        
        write_enable_A <= '1';
        wait for clk_period;
        write_enable_A <= '0';
        wait for 2 * clk_period;

        reg_read <= "000";
        operation_selector <= "01";
        wait for clk_period;
        
        write_enable_A <= '1';
        wait for clk_period;
        write_enable_A <= '0';
        wait for 2 * clk_period;

        reg_read <= "000";
        operation_selector <= "10";
        wait for clk_period;
        
        write_enable_A <= '1';
        wait for clk_period;
        write_enable_A <= '0';
        wait for 2 * clk_period;

        reg_read <= "000";
        operation_selector <= "11";
        wait for clk_period;
        
        write_enable_A <= '1';
        wait for clk_period;
        write_enable_A <= '0';
        wait for 2 * clk_period;

        write_enable_regs <= '1';
        reg_write <= "010";
        data_write <= saida;
        wait for clk_period;
        write_enable_regs <= '0';
        wait for clk_period;

        reg_read <= "010";
        wait for clk_period;
        wait;
    end process;

end architecture;