# Fontes
SRC_ALU=ALU/ALU.vhd
SRC_REGS=Registers/reg16bits.vhd Registers/bancoReg.vhd
SRC_MAIN=main.vhd
SRC_TB=main_tb.vhd

# Entidades
ENTITIES=ALU reg16bits bancoReg main
TB_ENTITY=main_tb

# Arquivo de waveform
WAVE=$(TB_ENTITY).ghw

# Alvo padrão
all: run

# Compilação específica por módulos
analyze:
	ghdl -a $(SRC_ALU)
	ghdl -a $(SRC_REGS)
	ghdl -a $(SRC_MAIN)
	ghdl -a $(SRC_TB)

# Elaboração das entidades
elaborate: analyze
	ghdl -e ALU
	ghdl -e reg16bits
	ghdl -e bancoReg
	ghdl -e main
	ghdl -e $(TB_ENTITY)

# Execução do testbench e geração do waveform
run: elaborate
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

# Visualização da simulação com configuração padrão
view_padrao: run
	gtkwave $(WAVE)

# Visualização com configuração personalizada
view: run
	gtkwave $(WAVE) $(TB_ENTITY)_configGHW.gtkw

# Limpeza dos arquivos gerados
clean:
	rm -f *.o *.cf $(WAVE) $(ENTITIES) $(TB_ENTITY)
