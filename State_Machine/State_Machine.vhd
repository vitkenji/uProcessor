library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine is
    port(
        clk : in std_logic;
        rst : in std_logic;
        state : out std_logic
    );
end entity;

architecture State_Machine_arch of State_Machine is
    signal state_s: std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            state_s <= '0';
        elsif rising_edge(clk) then 
                state_s <= not state_s;
        end if;
    end process;
    state <= state_s;
end architecture;