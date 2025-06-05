library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine is
    port(
        clk : in std_logic;
        rst : in std_logic;
        state : out unsigned (1 downto 0)
    );
end entity;

architecture State_Machine_arch of State_Machine is
    signal state_s: unsigned (1 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            state_s <= "00";
        elsif rising_edge(clk) then 
            if state_s = "10" then
                state_s <= "00";
            else
                state_s <= state_s + 1;
            end if;
        end if;
    end process;
    state <= state_s;
end architecture;