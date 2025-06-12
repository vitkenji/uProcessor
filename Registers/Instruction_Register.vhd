-- Registrador de 17 bits para armazenar instruções

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Register is
    port(
        clk: in std_logic;
        rst: in std_logic;
        write_enable: in std_logic;
        instruction_in: in unsigned(16 downto 0);
        instruction_out: out unsigned(16 downto 0)
    );
end entity Instruction_Register;

architecture Instruction_Register_arch of Instruction_Register is
    signal data: unsigned(16 downto 0);
begin

    process(clk, rst, write_enable)
    begin
        if rst = '1' then
            data <= "00000000000000000";
        elsif write_enable = '1' then 
            if rising_edge(clk) then 
                data <= instruction_in;
            end if;
        end if;
    end process;

    instruction_out <= data;

end architecture Instruction_Register_arch;
