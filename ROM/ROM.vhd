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
    -- Definição de opcodes
    constant JUMP: unsigned (3 downto 0) := "1111"; -- Opcode para JUMP
    constant LD: unsigned (3 downto 0) := "0001"; -- Opcode para LOAD
    constant MOV_ACC: unsigned (3 downto 0) := "0100"; -- Opcode para MOV Accumulator
    constant MOV_REG: unsigned (3 downto 0) := "0110"; -- Opcode para MOV Register
    constant ADD: unsigned (3 downto 0) := "0010"; -- Opcode para ADD
    constant SUB: unsigned (3 downto 0) := "0011"; -- Opcode para SUB
    constant COMP: unsigned (3 downto 0) := "0101"; -- Opcode para COMPARAÇÃO
    constant BLE: unsigned (3 downto 0) := "0111"; -- Opcode para BLE
    constant BHS: unsigned (3 downto 0) := "1000"; -- Opcode para BHS
    constant SW: unsigned (3 downto 0) := "1001"; -- Opcode para SW
    constant LW: unsigned (3 downto 0) := "1010"; -- Opcode para LW

    -- Definição de registradores
    constant R0: unsigned (2 downto 0) := "000"; -- Registrador R0
    constant R1: unsigned (2 downto 0) := "001"; -- Registrador R1
    constant R2: unsigned (2 downto 0) := "010"; -- Registrador R2
    constant R3: unsigned (2 downto 0) := "011"; -- Registrador R3
    constant R4: unsigned (2 downto 0) := "100"; -- Registrador R4
    constant R5: unsigned (2 downto 0) := "101"; -- Registrador R5

    type mem is array (0 to 127) of unsigned(16 downto 0);

    constant ROM_content : mem := (
        0   => LD & R0 & "0000001100", -- LD R0 12
        1   => LD & R1 & "0000010111", -- LD R1 23
        2   => LD & R2 & "0000010000", -- LD R2 16
        3   => ADD & R1 & "0000000000", -- ADD R1
        4   => SW & R0 & "0000000000", -- SW R0
        5   => ADD & R1 & "0000000000", -- ADD R1
        6   => SW & R1 & "0000000000", -- SW R1
        7   => SW & R0 & "0000000000", -- SW R0
        8   => MOV_ACC & R3 & "0000000000", -- MOV A, R3
        9   => LW & R0 & "0000000000", -- LW R0
        10  => JUMP & "0001110" & "000000", -- JUMP 14
        11  => "00000000000000000",
        12  => "00000000000000000",
        13  => "00000000000000000",
        14  => LD_OP & R5 & "0000100010", -- LD R4 34
        15  => JUMP_OP & "0000000" & "000000", -- JUMP 0
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