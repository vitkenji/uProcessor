library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_top_level is
    port (
        clk, rst, write_enable: in std_logic;
        top_data_in : in unsigned (6 downto 0);
        top_data_out : out unsigned (6 downto 0)
    );
end entity;

architecture PC_top_level_arch of PC_top_level is
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
    
    signal pc_out : unsigned (6 downto 0);
    signal pc_in : unsigned (6 downto 0);

    begin
        uut_PC : PC port map (
            clk => clk,
            rst => rst,
            write_enable => write_enable,
            data_in => pc_in,
            data_out => pc_out
        );
        
        uut_Adder : Adder port map (
            data_in => pc_out,
            data_out => pc_in
        );
end architecture;