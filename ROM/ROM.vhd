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
    constant CMP: unsigned (3 downto 0) := "0101"; -- Opcode para COMPARAÇÃO
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

    constant LOOP_RAM: unsigned (5 downto 0) := "111101"; -- Endereço de início do loop para preencher a RAM
    constant LOOP_CRIVO: unsigned (5 downto 0) := "101110"; -- Endereço de início do loop do Crivo de Eratóstenes
    constant INCR_CAND: unsigned (5 downto 0) := "001101"; -- Endereço para incrementar o candidato
    constant PROXIMO_CANDIDATO: unsigned (5 downto 0) := "000110"; -- Endereço para o próximo candidato no Crivo de Eratóstenes
    type mem is array (0 to 127) of unsigned(16 downto 0);

    constant ROM_content : mem := (
        0   => LD & R0 & "0000000001", -- LD R0, 1 (endereço)
        1   => LD & R1 & "0000100000", -- LD R1, 32 (limite)

        -- LOOP_RAM:
        2   => MOV_ACC & R0 & "0000000000", -- MOV A, R0
        3   => SW & R0 & "0000000000", -- SW R0 (RAM[R0] = A)
        4   => LD & R5 & "0000000001", -- LD R5, 1
        5   => MOV_ACC & R0 & "0000000000", -- MOV A, R0
        6   => ADD & R5 & "0000000000", -- ADD R5 (A = R0 + 1)
        7   => MOV_REG & R0 & "0000000000", -- MOV R0, A (atualiza R0)
        8   => CMP & R1 & "0000000000", -- CMP R0, R1 (A - R1)
        9   => BLE & "111001" & "0000000", -- Se R0 <= 32, volta para linha 2 (delta = 2-9 = -7 = 111101)
        
        10  => LD & R2 & "0000000010", -- LD R2, 2 (candidato)
        
        -- LOOP_CRIVO:
        11  => LW & R2 & "0000000000", -- LW R2 (A = RAM[R2])
        12  => MOV_REG & R4 & "0000000000", -- MOV R4, A (R4 = candidato)
        13  => LD & R5 & "0000000000", -- LD R5, 0
        14  => MOV_ACC & R5 & "0000000000", -- MOV A, R5
        15  => CMP & R4 & "0000000000", -- CMP R4, R5 (0 >= R4)
        16  => BHS & "001100" & "0000000", -- Se RAM[R2]==0, pula para INCR_CAND (delta = 28-16 = 12 = 001100)
        
        -- INICIO MARCAÇÃO DE MÚLTIPLOS
        17  => MOV_ACC & R2 & "0000000000", -- MOV A, R2
        18  => ADD & R2 & "0000000000", -- ADD R2 (A = 2*candidato)
        19  => MOV_REG & R3 & "0000000000", -- MOV R3, A (R3 = múltiplo)
        
        -- MARCA_LOOP:
        20  => LD & R5 & "0000000000", -- LD R5, 0
        21  => MOV_ACC & R5 & "0000000000", -- MOV A, R5
        22  => SW & R3 & "0000000000", -- SW R3 (marca RAM[R3] = 0)
        23  => MOV_ACC & R3 & "0000000000", -- MOV A, R3
        24  => ADD & R2 & "0000000000", -- ADD R2 (A = múltiplo + candidato)
        25  => MOV_REG & R3 & "0000000000", -- MOV R3, A (atualiza múltiplo)
        26  => CMP & R1 & "0000000000", -- CMP R3, R1 (R3 - R1)
        27  => BLE & "111001" & "0000000", -- Se múltiplo <= 32, volta para MARCA_LOOP (delta = 20-27 = -7 = 111001)
        
        -- INCR_CAND:
        28  => MOV_ACC & R2 & "0000000000", -- MOV A, R2
        29  => LD & R5 & "0000000001", -- LD R5, 1
        30  => ADD & R5 & "0000000000", -- ADD R5 (A = candidato + 1)
        31  => MOV_REG & R2 & "0000000000", -- MOV R2, A (atualiza candidato)
        32  => CMP & R1 & "0000000000", -- CMP R2, R1
        33  => BLE & "101010" & "0000000", -- Se candidato <= 32, volta para LOOP_CRIVO (delta = 11-33 = -22 = 101010) [ CRITÉRIO DE PARADA]
        
        -- LEITURA DOS PRIMOS NA RAM 
        34  => LD & R0 & "0000000010", -- LD R0, 2 (endereço inicial)
        
        35  => LW & R0 & "0000000000", -- LW R0 (A = RAM[R0])
        36  => MOV_REG & R2 & "0000000000", -- MOV R2, A (R2 = RAM[R0])
        37  => LD & R5 & "0000000000", -- LD R5, 0
        38  => MOV_ACC & R5 & "0000000000", -- MOV A, R5 (A = 0)
        39  => CMP & R2 & "0000000000", -- CMP R2 (A(0) - R2 (RAM[R0]))
        40  => BHS & "000011" & "0000000", -- Se RAM[R0]==0 pula, OU SEJA, A>=RAM[0] (COMO nunca vai ser maior pq A é 0, ele verifica so se é igual a 0) pula para INCR_LEITURA (delta = 43-40 = 3 = 000011)

        -- Imprimir primo na saida da RAM
        41  => MOV_ACC & R2 & "0000000000", -- MOV A, R2 (A = RAM[R0])
        42  => SW & R5 & "0000000000", -- SW R5 (RAM[R0] != 0, é primo, então imprime no primeiro endereço da RAM)

        -- INCR_LEITURA:
        43  => LD & R5 & "0000000001", -- LD R5, 1
        44  => MOV_ACC & R5 & "0000000000", -- MOV A, R5
        45  => ADD & R0 & "0000000000", -- ADD R4 (A = R0 + 1)
        46  => MOV_REG & R0 & "0000000000", -- MOV R0, A (atualiza endereço)
        47  => CMP & R1 & "0000000000", -- CMP R1 (A - R1 = R0 - 32)
        48  => BLE & "110011" & "0000000", -- Se R0 <= 32, volta para linha 35 (delta = 35-48 = -13 = 110011)
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