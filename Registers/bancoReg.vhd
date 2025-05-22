library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Considerar a utilização do acumulator 

entity bancoReg is
    port(
        clk: in std_logic;
        rst: in std_logic;

        -- Leitura [Selecionar o reg a ser lido e sair com o dado]
        reg_read: in unsigned(2 downto 0);
        data_out: out unsigned(15 downto 0); -- Sai o valor registrado no reg tbm?

        -- Escrita [write_enable = 1 -> data_write no reg_write] 
        write_enable: in std_logic;
        data_write: in unsigned(15 downto 0);
        reg_write: in unsigned(2 downto 0)

        -- Não leio dois regs ao mesmo tempo pois há o uso do acumulador   

    );
end entity bancoReg;

architecture a_bancoReg of bancoReg is
    component reg16bits
        port(
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    -- Preciso ter sinais de controle para cada registrador. Caso contrário, vai ser escrito em todos os registradores
    signal write_enable_r0, write_enable_r1, write_enable_r2, write_enable_r3, write_enable_r4, write_enable_r5: std_logic := '0';

    --Preciso ter sinais de saída para cada registrador
    signal data_out_r0, data_out_r1, data_out_r2, data_out_r3, data_out_r4, data_out_r5: unsigned(15 downto 0);

    -- Não coloquei o sinal de entrada individual para cada registrador, pois todos eles vão receber o mesmo valor de entrada, o que muda se vai inserir ou não é o write_enable de cada registrador
    
begin 
    -- 6 registradores de 16 bits (Especificação para nomenclatura:  R0,..., R5)
    r0 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r0,
        data_in => data_write,
        data_out => data_out_r0
    );

    r1 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r1,
        data_in => data_write,
        data_out => data_out_r1
    );

    r2 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r2,
        data_in => data_write,
        data_out => data_out_r2
    );

    r3 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r3,
        data_in => data_write,
        data_out => data_out_r3
    );

    r4 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r4,
        data_in => data_write,
        data_out => data_out_r4
    );

    r5 : reg16bits port map(
        clk => clk,
        rst => rst,
        write_enable => write_enable_r5,
        data_in => data_write,
        data_out => data_out_r5
    );

    -- Lógica de controle para escrita
    write_enable_r0 <= write_enable when reg_write = "000" else '0';
    write_enable_r1 <= write_enable when reg_write = "001" else '0';
    write_enable_r2 <= write_enable when reg_write = "010" else '0';
    write_enable_r3 <= write_enable when reg_write = "011" else '0';
    write_enable_r4 <= write_enable when reg_write = "100" else '0';
    write_enable_r5 <= write_enable when reg_write = "101" else '0';

    -- Não coloquei o else '0' ao final, assim como na recomendaçao, pois não a atribuição não é apenas para um sinal.

    -- Lógica de controle para leitura
    data_out <= data_out_r0 when reg_read = "000" else
                data_out_r1 when reg_read = "001" else
                data_out_r2 when reg_read = "010" else
                data_out_r3 when reg_read = "011" else
                data_out_r4 when reg_read = "100" else
                data_out_r5 when reg_read = "101" else
                "0000000000000000";

end architecture a_bancoReg;