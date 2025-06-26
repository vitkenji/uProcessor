library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flagReg is
    port(
        clk: in std_logic;
        rst: in std_logic;

        write_enable: in std_logic;

        flag_in: in std_logic;
        flag_out: out std_logic

    );
end entity flagReg;

architecture flagReg_arch of flagReg is
    signal flag : std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            flag <= '0';
        elsif rising_edge(clk) then
            if write_enable = '1' then
                flag <= flag_in;
            end if;
        end if;
    end process;

    flag_out <= flag;

end architecture flagReg_arch;
