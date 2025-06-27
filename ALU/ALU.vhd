library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        input_0, input_1 : in unsigned (15 downto 0);
        operation_selector: in unsigned (2 downto 0);
        carry, sinal, zero: out std_logic;
        overflow : out std_logic;
        alu_result : out unsigned (15 downto 0)
    );
end entity;

architecture ALU_arch of ALU is
    signal sum_result_17bits, sub_result_17bits : unsigned(16 downto 0);
    signal result_internal, and_result, or_result : unsigned(15 downto 0);
    signal carry_soma, carry_sub : std_logic;
begin

    sum_result_17bits <= ('0' & input_0) + ('0' & input_1);
    sub_result_17bits <= ('0' & input_0) - ('0' & input_1);
    and_result <= input_0 and input_1; 
    or_result <= input_0 or input_1; 

    result_internal <= sum_result_17bits(15 downto 0) when operation_selector = "010" else
                      sub_result_17bits(15 downto 0) when operation_selector = "011" else
                      sub_result_17bits(15 downto 0) when operation_selector = "001" else 
                      and_result when operation_selector = "110" else
                      or_result when operation_selector = "111" else
                      (others => '0');
    
    alu_result <= result_internal;
  
    zero <= '1' when result_internal = "0000000000000000" else '0';
    sinal <= result_internal(15);
    carry_soma <= sum_result_17bits(16);

    carry_sub <= '1' when input_1 <= input_0 else '0';

    carry <= carry_soma when operation_selector = "010" else
             carry_sub  when operation_selector = "001" else
             '0';
             
    overflow <= 
      ((not input_0(15) and not input_1(15) and result_internal(15)) or 
       (input_0(15) and input_1(15) and not result_internal(15)))   
       when operation_selector = "010" else
      ((not input_0(15) and input_1(15) and result_internal(15)) or     
       (input_0(15) and not input_1(15) and not result_internal(15)))   
       when (operation_selector = "011" or operation_selector = "001") else
      '0';

end architecture;