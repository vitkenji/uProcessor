library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_Bank is
    port(
        clk: in std_logic;
        rst: in std_logic;

        reg_read: in unsigned(2 downto 0);
        data_out: out unsigned(15 downto 0);

        write_enable: in std_logic;
        data_write: in unsigned(15 downto 0);
        reg_write: in unsigned(2 downto 0)
    );
end entity Register_Bank;

architecture Register_Bank_arch of Register_Bank is
    component reg16bits
        port(
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    signal write_enable_r0, write_enable_r1, write_enable_r2, write_enable_r3, write_enable_r4, write_enable_r5: std_logic := '0';
    signal data_out_r0, data_out_r1, data_out_r2, data_out_r3, data_out_r4, data_out_r5: unsigned(15 downto 0);

begin 
    r0 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r0,
        data_in => data_write,
        data_out => data_out_r0
    );

    r1 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r1,
        data_in => data_write,
        data_out => data_out_r1
    );

    r2 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r2,
        data_in => data_write,
        data_out => data_out_r2
    );

    r3 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r3,
        data_in => data_write,
        data_out => data_out_r3
    );

    r4 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r4,
        data_in => data_write,
        data_out => data_out_r4
    );

    r5 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r5,
        data_in => data_write,
        data_out => data_out_r5
    );

    write_enable_r0 <= write_enable when reg_write = "000" else '0';
    write_enable_r1 <= write_enable when reg_write = "001" else '0';
    write_enable_r2 <= write_enable when reg_write = "010" else '0';
    write_enable_r3 <= write_enable when reg_write = "011" else '0';
    write_enable_r4 <= write_enable when reg_write = "100" else '0';
    write_enable_r5 <= write_enable when reg_write = "101" else '0';

    data_out <= data_out_r0 when reg_read = "000" else
                data_out_r1 when reg_read = "001" else
                data_out_r2 when reg_read = "010" else
                data_out_r3 when reg_read = "011" else
                data_out_r4 when reg_read = "100" else
                data_out_r5 when reg_read = "101" else
                "0000000000000000";

end architecture;