library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder_tb is
end;

architecture Adder_tb_arch of Adder_tb is
    component Adder
    port (
        data_in : in unsigned (6 downto 0);
        data_out : out unsigned (6 downto 0)
    );
    end component;

    signal data_in : unsigned (6 downto 0);
    signal data_out : unsigned (6 downto 0);

begin
    uut : Adder port map(
    data_in => data_in,
    data_out => data_out
);
    process
    begin
        data_in <= "0000000";
        wait for 20 ns;      
        data_in <= "0000001";
        wait for 20 ns;
        data_in <= "0000011";
        wait for 20 ns;
        data_in <= "1111111";
        wait for 20 ns;
        wait;
    end process;    
end architecture;