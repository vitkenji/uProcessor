SRC=ALU.vhd
ENTITY=ALU

TB=reg16bits_tb.vhd
TB_ENTITY=reg16bits_tb

WAVE=$(TB_ENTITY).ghw


# Regra padrão
all: run

# Compila os arquivos
analyze_especifico:
	ghdl -a $(SRC)
	ghdl -e $(ENTITY)
	ghdl -a $(TB)
	ghdl -e $(TB_ENTITY)

analyze:
	ghdl -a *.vhd
	ghdl -e $(TB_ENTITY)

# Executa o testbench e gera o waveform
run: analyze
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

# Abre a simulação no GTKWave
view_padrao: run
	gtkwave $(WAVE)

view: run
	gtkwave $(WAVE) $(TB_ENTITY)_configGHW.gtkw

# Limpa arquivos gerados
clean:
	rm -f *.o *.cf $(WAVE) $(ENTITY) $(TB_ENTITY)
