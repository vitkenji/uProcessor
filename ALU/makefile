SRC=ALU.vhd
TB=ALU_tb.vhd
ENTITY=ALU
TB_ENTITY=ALU_tb
WAVE=ALU.ghw

# Regra padrão
all: run

# Compila os arquivos
analyze:
	ghdl -a $(SRC)
	ghdl -e $(ENTITY)
	ghdl -a $(TB)
	ghdl -e $(TB_ENTITY)

# Executa o testbench e gera o waveform
run: analyze
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

# Abre a simulação no GTKWave
view_padrao: run
	gtkwave $(WAVE)

view: run
	gtkwave $(WAVE) alu_ghw_configurado.gtkw

# Limpa arquivos gerados
clean:
	rm -f *.o *.cf $(WAVE) $(ENTITY) $(TB_ENTITY)
