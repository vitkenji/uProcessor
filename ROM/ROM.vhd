-- Armazena 128 (2^7) instruções (17 bits)

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
        0   => "00010000000001100", -- LD R0 12 
        1   => "00010010000010111", -- LD R1 23 
        2   => "00010100000010000", -- LD R2 16
        3   => "00100010000000000", -- ADD R1
        4   => "10010000000000000", -- SW R0
        5   => "00100010000000000", -- ADD R1
        6   => "10010010000000000", -- SW R1
        7   => "10010000000000000", -- SW R0
        8   => "01000110000000000", -- MOV A, R3
        9   => "10100000000000000", -- LW R0
        10  => "00000000000000000", 
        11  => "00000000000000000", 
        12  => "00000000000000000",
        13  => "00000000000000000",
        14  => "00000000000000000",
        15  => "00000000000000000",
        16  => "00000000000000000",
        17  => "00000000000000000",
        18  => "00000000000000000",
        19  => "00000000000000000",
        20  => "00000000000000000", 
        21  => "00000000000000000", 
        22  => "00000000000000000", 
        23  => "00000000000000000",
        24  => "00000000000000000",
        25  => "00000000000000000",
        26  => "00000000000000000",
        27  => "00000000000000000",
        28  => "00000000000000000",
        29  => "00000000000000000",
        30  => "00000000000000000",
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