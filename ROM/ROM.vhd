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
        0   => "00010110000000101", -- LD R3, 5
        1   => "00011000000001000", -- LD R4, 8
        2   => "00100110000000000", -- ADD R3 (ACC = R3 + 0)
        3   => "00101000000000000", -- ADD R4 (ACC = R3 + R4) 
        4   => "01101010000000000", -- MOV R5, ACC (R5 = ACC = R3 + R4) 
        5   => "00010010000000001", -- LD R1, 1
        6   => "00110010000000000", -- SUB R1 (ACC - 1 = R5 - 1)
        7   => "01101010000000000", -- MOV R5, ACC (R5 = ACC = R5 - 1)
        8   => "11110010100000000", -- JUMP 20
        9   => "00011010000000000", -- LD R5, 0 
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
        20  => "01100110000000000", -- MOV R3, ACC (R3 = ACC = R5 - 1)
        21  => "11110000010000000", -- JUMP 2
        22  => "00010110000000000", -- LD R3, 0
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