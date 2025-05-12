library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end;

architecture ALU_tb_arch of ALU_tb is
    component ALU
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector : in unsigned (1 downto 0);
        C, Z : out std_logic;
        output : out unsigned (15 downto 0)
    );
    end component;

    signal input_0, input_1 : unsigned (15 downto 0);
    signal operation_selector : unsigned (1 downto 0);
    signal C, Z : std_logic;
    signal output : unsigned (15 downto 0);

    begin
        uut : ALU port map(
            input_0 => input_0,
            input_1 => input_1,
            operation_selector => operation_selector,
            C => C,
            Z => Z,
            output => output
        );
        process
        begin
            operation_selector <= "00";
            input_0 <= "0000000000001111";
            input_1 <= "0000000000000001";
            wait for 20 ns;
            operation_selector <= "01";
            wait for 20 ns;
            operation_selector <= "10";
            wait for 20 ns;
            operation_selector <= "11";
            wait for 20 ns;
            wait;
        end process;
    end architecture;    