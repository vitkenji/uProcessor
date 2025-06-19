library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Branch_Adder is
    port (
        delta : in unsigned (6 downto 0);
        current_address : in unsigned (6 downto 0);
        address_out : out unsigned (6 downto 0)
    );
end entity;

architecture Branch_Adder_arch of Branch_Adder is
    begin
        address_out <= delta + current_address;
end architecture;