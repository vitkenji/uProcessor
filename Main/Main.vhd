library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
    port (
        clk, rst, selector: in std_logic;
        top_data_in : in unsigned (6 downto 0);
        top_data_out : out unsigned (6 downto 0)
    );
end entity;

architecture Main_arch of Main is
    
    component MUX_2x1_7bits
    port (
        selector : in std_logic;
        input_0, input_1 : in unsigned (6 downto 0);
        output : out unsigned (6 downto 0) 
    );
    end component;

    component ROM
    port (
        clk : in std_logic;
        address : in unsigned(6 downto 0);
        data : out unsigned(16 downto 0)
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

    component Control_Unit
    port(
        instruction : in unsigned (16 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        jump_enable : out std_logic;
        pc_write_enable : out std_logic
    );
    end component;

    signal pc_out, adder_out, mux_pc_out, mux_jump_out: unsigned (6 downto 0);
    signal rom_out : unsigned (16 downto 0);
    signal jump_enable : std_logic;
    signal pc_write_enable : std_logic;

    begin

        uut_MUX_pc : MUX_2x1_7bits port map (
            selector => selector,
            input_0 => top_data_in,
            input_1 => mux_jump_out,
            output => mux_pc_out
        );

        uut_MUX_jump : MUX_2x1_7bits port map (
            selector => jump_enable,
            input_0 => adder_out,
            input_1 => rom_out(10 downto 4),
            output => mux_jump_out
        );

        uut_PC : PC port map (
            clk => clk,
            rst => rst,
            write_enable => pc_write_enable,
            data_in => mux_pc_out,
            data_out => pc_out
        );
        
        uut_Adder : Adder port map (
            data_in => pc_out,
            data_out => adder_out
        );

        uut_ROM : ROM port map (
            clk => clk,
            address => pc_out,
            data => rom_out
        );

        uut_Control_Unit : Control_Unit port map (
            clk => clk,
            rst => rst,
            instruction => rom_out,
            jump_enable => jump_enable,
            pc_write_enable => pc_write_enable
        );

        top_data_out <= adder_out;

end architecture;