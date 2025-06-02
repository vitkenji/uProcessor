library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_top_level is
    port (
        clk, rst, write_enable, selector: in std_logic;
        top_data_in : in unsigned (6 downto 0);
        top_data_out : out unsigned (6 downto 0)
    );
end entity;

architecture PC_top_level_arch of PC_top_level is
    
    component MUX_2x1_7bits
    port (
        selector : in std_logic;
        input_0, input_1 : in unsigned (6 downto 0);
        output : out unsigned (6 downto 0) 
    );
    end component;

    component PC
    port (
        clk : in std_logic;
        rst : in std_logic;
        write_enable : in std_logic;
        data_in : in unsigned (6 downto 0);
        data_out : out unsigned (6 downto 0)
    );
    end component;

    component Adder
    port (
        data_in : in unsigned (6 downto 0);
        data_out : out unsigned (6 downto 0)
    );
    end component;    
    
    signal pc_out, adder_out, mux_out: unsigned (6 downto 0);

    begin
        uut_MUX_2x1_7bits : MUX_2x1_7bits port map (
            selector => selector,
            input_0 => top_data_in,
            input_1 => adder_out,
            output => mux_out
        );

        uut_PC : PC port map (
            clk => clk,
            rst => rst,
            write_enable => write_enable,
            data_in => mux_out,
            data_out => pc_out
        );
        
        uut_Adder : Adder port map (
            data_in => pc_out,
            data_out => adder_out
        );

        top_data_out <= adder_out;

end architecture;