library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Accumulator is
    port (
        clk: in std_logic;
        rst : in std_logic;
        write_enable : in std_logic;
        data_in : in unsigned (15 downto 0);
        data_out : out unsigned (15 downto 0)
    );
end entity;

architecture Accumulator_arch of Accumulator is
    signal data: unsigned(15 downto 0);
    begin
    
        process(clk, rst, write_enable)
        begin
            if rst = '1' then
                data <= (others => '0');
            elsif write_enable = '1' then
                if rising_edge(clk) then
                    data <= data_in;
                end if;
            end if;
        end process;
    
        data_out <= data;
        
end architecture;