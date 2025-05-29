library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
port(
    clk : in std_logic;
    address : in unsigned(6 downto 0);
    data : out unsigned(16 downto 0)
);
end entity;

architecture ROM_arch of ROM is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant ROM_content : mem := (
        0 => "00000000000000011",
        1 => "00000010010010011",
        others => (others =>'0')
    );
    begin
        process(clk)
        begin
            if (rising_edge(clk)) then
                data <= ROM_content(to_integer(address));
            end if;
        end process;
end architecture;