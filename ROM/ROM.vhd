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
        0   => "00010000000011101", -- LD R0 29
        1   => "00010010000000001", -- LD R1 1
        2   => "01000100000000000", -- MOV A R2
        3   => "00100110000000000", -- ADD R3
        4   => "00101000000000000", -- ADD R4
        5   => "01101000000000000", -- MOV R4 A 
        6   => "01000110000000000", -- MOV A R3
        7   => "00100010000000000", -- ADD R1
        8   => "01100110000000000", -- MOV R3 A
        9   => "01110111110111001", -- BLE R3 29 -7
        10  => "01001000000000000", -- MOV A R4
        11  => "01101010000000000", -- MOV R5 A
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