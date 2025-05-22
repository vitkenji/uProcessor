library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Juntar ULA com registrador
entity main is
    port(
        clk: in std_logic;
        rst: in std_logic;

        -- Controle dos registradores
        write_enable_A: in std_logic;
        write_enable_regs: in std_logic;

        reg_read: in unsigned(2 downto 0);
        reg_write: in unsigned(2 downto 0);
        data_write: in unsigned(15 downto 0);

        -- Controle da ALU
        operation_selector: in unsigned(1 downto 0);   
        carry, greater_equal, less_equal: out std_logic;
        saida: out unsigned(15 downto 0)
    );
end entity main;

architecture a_main of main is

    -- Componentes

    component reg16bits
        port(
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    component bancoReg
        port(
            clk: in std_logic;
            rst: in std_logic;
            reg_read: in unsigned(2 downto 0);
            data_out: out unsigned(15 downto 0);
            write_enable: in std_logic;
            data_write: in unsigned(15 downto 0);
            reg_write: in unsigned(2 downto 0)
        );
    end component;

    component ALU
        port(
            input_0, input_1 : in unsigned (15 downto 0);
            operation_selector : in unsigned (1 downto 0);
            carry, greater_equal, less_equal : out std_logic;
            saida : out unsigned (15 downto 0)
        );
    end component;


    -- Sinais

    -- Registrador de 16 bits [Acumulador]
    signal data_in_A : unsigned(15 downto 0) := (others => '0');
    signal data_out_A : unsigned(15 downto 0) := (others => '0');

    -- Banco de registradores
    signal data_out_reg: unsigned(15 downto 0);

    -- ALU
    signal saida_ALU : unsigned (15 downto 0);

begin

    -- Registrador de 16 bits [Acumulador]
    A: reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_A,
        data_in => data_in_A,
        data_out => data_out_A
    );

    -- Banco de registradores
    uut_bancoReg: bancoReg port map(
        clk => clk,
        rst => rst,
        reg_read => reg_read,
        data_out => data_out_reg,
        write_enable => write_enable_regs,
        data_write => data_write,
        reg_write => reg_write
    );

    -- ALU
    uut_ALU: ALU port map(
        input_0 => data_out_reg,
        input_1 => data_out_A,
        operation_selector => operation_selector,
        carry => carry,
        greater_equal => greater_equal,
        less_equal => less_equal,
        saida => saida_ALU
    );

    -- Lógica para atualização do acumulador
    data_in_A <= saida_ALU when write_enable_A = '1' else 
    '0';

end architecture a_main;
