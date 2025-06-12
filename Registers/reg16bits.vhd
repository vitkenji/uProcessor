library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits is
    port(
        clk: in std_logic;
        rst: in std_logic;
        write_enable: in std_logic;
        data_in: in unsigned(15 downto 0);
        data_out: out unsigned(15 downto 0)
    );
end entity reg16bits;


architecture a_reg16bits of reg16bits is
    signal registro: unsigned(15 downto 0);
    
begin

    process(clk, rst, write_enable)
    begin
        if rst = '1' then
            registro <= "0000000000000000";
        elsif write_enable = '1' then -- Clock enable
            if rising_edge(clk) then  -- Borda de subida do clock
                registro <= data_in;
            end if;
        end if;
    end process;

    data_out <= registro;

end architecture a_reg16bits;
