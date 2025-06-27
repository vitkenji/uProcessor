library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
        port (
            clk : in std_logic;
            address : in unsigned (15 downto 0);
            write_enable : in std_logic;
            ram_data_in : in unsigned (15 downto 0);
            ram_data_out : out unsigned (15 downto 0) 
        );
end entity;

architecture RAM_arch of RAM is
    type mem is array (0 to 65535) of unsigned (15 downto 0);
    signal content_ram : mem := (others => (others => '0'));
    begin
        process(clk, write_enable)
        begin
            if rising_edge(clk) then
                if write_enable = '1' then
                    content_ram(to_integer(address)) <= ram_data_in;
                end if;
            end if;
        end process;

        ram_data_out <= content_ram(to_integer(address));

end architecture;