SRC_ALU=ALU/ALU.vhd
SRC_ALU_TB=ALU/ALU_tb.vhd
SRC_REGS=Registers/reg16bits.vhd Registers/Register_Bank.vhd Registers/Accumulator.vhd Registers/Instruction_Register.vhd Registers/flagReg.vhd
SRC_MAIN=Main/Main.vhd
SRC_TB=Main/Main_tb.vhd
SRC_ROM=ROM/ROM.vhd
SRC_PC=PC/PC.vhd
SRC_ADDER=PC/Adder.vhd
SRC_BRANCH_ADDER=PC/Branch_Adder.vhd
SRC_MUX=MUX/MUX_2x1_7bits.vhd
SRC_MUX_16=MUX/MUX_2x1_16bits.vhd
SRC_MUX_3x1_16=MUX/MUX_3x1_16bits.vhd
SRC_STATE=State_Machine/State_Machine.vhd
SRC_RAM=RAM/RAM.vhd
SRC_CONTROL=Control_Unit/Control_Unit.vhd
SRC_CONTROL_TB=Control_Unit/Control_Unit_tb.vhd

ENTITIES=main
TB_ENTITY=main_tb

WAVE=$(TB_ENTITY).ghw

all: run

analyze:
	ghdl -a $(SRC_ALU)
	ghdl -a $(SRC_REGS)
	ghdl -a $(SRC_TB)
	ghdl -a $(SRC_ROM)
	ghdl -a $(SRC_PC)
	ghdl -a $(SRC_ADDER)
	ghdl -a $(SRC_BRANCH_ADDER)
	ghdl -a $(SRC_MUX)
	ghdl -a $(SRC_MUX_16)
	ghdl -a $(SRC_MUX_3x1_16)
	ghdl -a $(SRC_STATE)
	ghdl -a $(SRC_RAM)
	ghdl -a $(SRC_CONTROL)
	ghdl -a $(SRC_CONTROL_TB)
	ghdl -a $(SRC_MAIN)

analyze_control:
	ghdl -a $(SRC_STATE)
	ghdl -a $(SRC_CONTROL)
	ghdl -a $(SRC_CONTROL_TB)

elaborate: analyze
	ghdl -e ALU
	ghdl -e reg16bits
	ghdl -e Register_Bank
	ghdl -e Accumulator
	ghdl -e Instruction_Register
	ghdl -e ROM
	ghdl -e Adder
	ghdl -e MUX_2x1_7bits
	ghdl -e MUX_2x1_16bits
	ghdl -e MUX_3x1_16bits
	ghdl -e PC
	ghdl -e State_Machine
	ghdl -e RAM
	ghdl -e Control_Unit
	ghdl -e $(TB_ENTITY)
	ghdl -e main

elaborate_control: analyze_control
	ghdl -e State_Machine
	ghdl -e Control_Unit
	ghdl -e $(TB_ENTITY)

run: elaborate
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

run_control: elaborate_control
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)

test_control: run_control
	gtkwave $(WAVE) $(TB_ENTITY)_configGHW.gtkw

view_padrao: run
	gtkwave $(WAVE)

view: run
	gtkwave $(WAVE) $(TB_ENTITY)_CRIVO_configGHW.gtkw

clean:
	rm -f *.o *.cf $(WAVE) $(ENTITIES) $(TB_ENTITY)

