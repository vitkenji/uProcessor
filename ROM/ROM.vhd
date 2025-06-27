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
    constant JUMP: unsigned (3 downto 0) := "1111"; 
    constant LD: unsigned (3 downto 0) := "0001"; 
    constant MOV_ACC: unsigned (3 downto 0) := "0100"; 
    constant MOV_REG: unsigned (3 downto 0) := "0110"; 
    constant ADD: unsigned (3 downto 0) := "0010"; 
    constant SUB: unsigned (3 downto 0) := "0011"; 
    constant CMP: unsigned (3 downto 0) := "0101"; 
    constant BLE: unsigned (3 downto 0) := "0111";
    constant BHS: unsigned (3 downto 0) := "1000"; 
    constant SW: unsigned (3 downto 0) := "1001"; 
    constant LW: unsigned (3 downto 0) := "1010";

    constant R0: unsigned (2 downto 0) := "000"; 
    constant R1: unsigned (2 downto 0) := "001"; 
    constant R2: unsigned (2 downto 0) := "010"; 
    constant R3: unsigned (2 downto 0) := "011";
    constant R4: unsigned (2 downto 0) := "100"; 
    constant R5: unsigned (2 downto 0) := "101";

    constant NOP: unsigned (16 downto 0) := (others => '0');
    
    type mem is array (0 to 127) of unsigned(16 downto 0);

    constant ROM_content : mem := (
        0   => LD & R0 & "0000000001", -- LD R0, 1
        1   => LD & R1 & "0000100000", -- LD R1, 32 

        2   => MOV_ACC & R0 & "0000000000", -- MOV A, R0
        3   => SW & R0 & "0000000000", -- SW R0 (RAM[R0] = A)
        4   => LD & R5 & "0000000001", -- LD R5, 1
        5   => MOV_ACC & R0 & "0000000000", -- MOV A, R0
        6   => ADD & R5 & "0000000000", -- ADD R5 (A = R0 + 1)
        7   => MOV_REG & R0 & "0000000000", -- MOV R0, A 
        8   => CMP & R1 & "0000000000", -- CMP R0, R1 (A - R1)
        9   => BLE & "111001" & "0000000", -- Se R0 <= 32
        
        10  => LD & R2 & "0000000010", -- LD R2, 2 

        11  => LW & R2 & "0000000000", -- LW R2
        12  => MOV_REG & R4 & "0000000000", -- MOV R4, A 
        13  => LD & R5 & "0000000000", -- LD R5, 0
        14  => MOV_ACC & R5 & "0000000000", -- MOV A, R5
        15  => CMP & R4 & "0000000000", -- CMP R4, R5 
        16  => BHS & "001100" & "0000000", -- Se RAM[R2]==0
        
        17  => MOV_ACC & R2 & "0000000000", -- MOV A, R2
        18  => ADD & R2 & "0000000000", -- ADD R2 
        19  => MOV_REG & R3 & "0000000000", -- MOV R3, A 

        20  => LD & R5 & "0000000000", -- LD R5, 0
        21  => MOV_ACC & R5 & "0000000000", -- MOV A, R5
        22  => SW & R3 & "0000000000", -- SW R3 
        23  => MOV_ACC & R3 & "0000000000", -- MOV A, R3
        24  => ADD & R2 & "0000000000", -- ADD R2
        25  => MOV_REG & R3 & "0000000000", -- MOV R3, A 
        26  => CMP & R1 & "0000000000", -- CMP R3, R1 
        27  => BLE & "111001" & "0000000",

        28  => MOV_ACC & R2 & "0000000000", -- MOV A, R2
        29  => LD & R5 & "0000000001", -- LD R5, 1
        30  => ADD & R5 & "0000000000", -- ADD R5 (
        31  => MOV_REG & R2 & "0000000000", -- MOV R2, A 
        32  => CMP & R1 & "0000000000", -- CMP R2, R1
        33  => BLE & "101010" & "0000000", 

        34  => LD & R0 & "0000000010", -- LD R0, 2 
        
        35  => LW & R0 & "0000000000", -- LW R0 
        36  => MOV_REG & R2 & "0000000000", -- MOV R2, A 
        37  => LD & R5 & "0000000000", -- LD R5, 0
        38  => MOV_ACC & R5 & "0000000000", -- MOV A, R5 
        39  => CMP & R2 & "0000000000", -- CMP R2 
        40  => BHS & "000011" & "0000000", 

        41  => MOV_ACC & R2 & "0000000000", -- MOV A, R2 
        42  => SW & R5 & "0000000000", -- SW R5 

        43  => LD & R5 & "0000000001", -- LD R5, 1
        44  => MOV_ACC & R5 & "0000000000", -- MOV A, R5
        45  => ADD & R0 & "0000000000", -- ADD R4 
        46  => MOV_REG & R0 & "0000000000", -- MOV R0, A 
        47  => CMP & R1 & "0000000000", -- CMP R1 
        48  => BLE & "110011" & "0000000", -- Se R0 <= 32

        49  => NOP,
        50  => NOP,
        51  => "11000000000000000", 
        52  => LD & R0 & "0000000000", 
        53  => NOP,
        54  => NOP,

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