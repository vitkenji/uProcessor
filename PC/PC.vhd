-- Armazena o endereço da próxima instrução a ser executada (Registrador de 7 bits)
-- As instruções são armazenadas em uma ROM de 128 posições, onde cada posição contém uma instrução de 17 bits


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        clk : in std_logic;
        rst : in std_logic;
        write_enable : in std_logic;
        pc_in : in unsigned (6 downto 0);
        pc_out : out unsigned (6 downto 0)
    );
end entity;

architecture PC_arch of PC is
    signal data : unsigned (6 downto 0) := (others => '0');

begin
    process(clk, rst, write_enable)
    begin
        if rst = '1' then
            data <= "0000000";
        elsif write_enable = '1' then
            if (rising_edge(clk)) then
                data <= pc_in;
            end if;
        end if;
    end process;

    pc_out <= data;
        
end architecture;