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
        0   => "00010110000000101", --Caregar r3 com o valor 5 [LD R3, 5
        1   => "00011000000001000", -- Carregar r4 com 8 [LD, R4, 8]
        2   => "00000000000000000", -- SOMAR R3 COM R4 E COLOCAR EM R5 [ADD R3; ADD R4; MOV ACC, R5]
        3   => "00000000000000000", -- SUBTRAI 1 DE R5 [LD R1, 1; SUB R1; MOV ACC, R5] 
        4   => "00000000000000000", -- SALTA PARA O 20 [JUMP 20]
        5   => "00000000000000000", -- ZERAR R5 [LD R5, 0]
        6   => "00000000000000000",
        7   => "00000000000000000",
        8   => "00000000000000000",
        9   => "00000000000000000",
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
        20  => "00000000000000000", -- COPIA R5 PARA R3 (MOV ACC, R3) --
        21  => "00000000000000000", -- JUMP 2
        22  => "00000000000000000", -- ZERA R3 9=(LD R3, 0)
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