# Fontes
SRC_ALU=ALU/ALU.vhd
SRC_REGS=Registers/reg16bits.vhd Registers/bancoReg.vhd Registers/Accumulator.vhd Registers/Instruction_Register.vhd
SRC_MAIN=Main/main.vhd
SRC_TB=Main/main_tb.vhd
SRC_ROM=ROM/ROM.vhd
SRC_PC=PC/PC.vhd
SRC_ADDER=PC/Adder.vhd
SRC_MUX=MUX/MUX_2x1_7bits.vhd
SRC_STATE=State_Machine/State_Machine.vhd
# SRC_PC_TOP=PC_top_level.vhd
# SRC_PC_TB=PC_top_level_tb.vhd
SRC_CONTROL=Control_Unit/Control_Unit.vhd
SRC_CONTROL_TB=Control_Unit/Control_Unit_tb.vhd

# Entidades
ENTITIES=Control_Unit
TB_ENTITY=Control_Unit_tb

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
	ghdl -a $(SRC_ROM)
	ghdl -a $(SRC_PC)
	ghdl -a $(SRC_ADDER)
	ghdl -a $(SRC_MUX)
	ghdl -a $(SRC_STATE)
	ghdl -a $(SRC_CONTROL)
	ghdl -a $(SRC_CONTROL_TB)

# Compilação específica para Control_Unit
analyze_control:
	ghdl -a $(SRC_STATE)
	ghdl -a $(SRC_CONTROL)
	ghdl -a $(SRC_CONTROL_TB)

# Elaboração das entidades
elaborate: analyze
	ghdl -e ALU
	ghdl -e reg16bits
	ghdl -e bancoReg
	ghdl -e Accumulator
	ghdl -e Instruction_Register
	ghdl -e main
	ghdl -e ROM
	ghdl -e Adder
	ghdl -e MUX_2x1_7bits
	ghdl -e PC
	ghdl -e State_Machine
	ghdl -e $(TB_ENTITY)

# Elaboração específica para Control_Unit
elaborate_control: analyze_control
	ghdl -e State_Machine
	ghdl -e Control_Unit
	ghdl -e $(TB_ENTITY)

# Execução do testbench e geração do waveform
run: elaborate
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

# Execução específica para Control_Unit
run_control: elaborate_control
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

# Comando completo para testar apenas Control_Unit
test_control: run_control
	gtkwave $(WAVE) $(TB_ENTITY)_configGHW.gtkw

# Visualização da simulação com configuração padrão
view_padrao: run
	gtkwave $(WAVE)

# Visualização com configuração personalizada
view: run
	gtkwave $(WAVE) $(TB_ENTITY)_configGHW.gtkw


# Limpeza dos arquivos gerados
clean:
	rm -f *.o *.cf $(WAVE) $(ENTITIES) $(TB_ENTITY)
