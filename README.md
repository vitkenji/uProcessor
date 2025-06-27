# Microprocessor

A microprocessor implemented in VHDL, based on a RISC-V processor. Validation was performed using the Sieve of Eratosthenes algorithm.

* 17-bit instructions.
* 128-address instruction memory.
* Bank register with 6 registers.
* 128Kb of RAM.

## Instructions

| Instr      | Description         | Opcode | Format |
|------------|---------------------|--------|--------|
| LD Rn,i    | Rn = i              | 0001   | I      |
| ADD Rn     | A += Rn             | 0010   | R      |
| SUB Rn     | A -= Rn             | 0011   | R      |
| MOV A,Rn   | A = Rn              | 0100   | R      |
| CMPR       | A - Rn              | 0101   | R      |
| MOV Rn,A   | Rn = A              | 0110   | R      |
| SW Rn      | RAM[Rn] = A         | 1001   | R      |
| LW Rn      | A = RAM[Rn]         | 1010   | R      |
| AND Rn     | A && Rn             | 1001   | R      |
| OR Rn      | A or Rn             | 1010   | R      |
| BLE b      | A <= reg ? PC + b   | 0111   | B      |
| BHS b      | A >= reg ? PC + b   | 1000   | B      |
| JUMP i     | address = i         | 1111   | J      |

## Instruction formats

B:
| opcode (4) | delta (6) | nothing(7) 
| --      | --    | --  

R:
| opcode (4) | rn (3) | nothing(10)
| --      | --    | --    

I: 
| opcode (4)  | rn(3) | constant(10)
| --      | --    | --

J: 
| opcode (4)  | address(7) | nothing(6)
| --      | --    | --


## Requirements

Before running, make sure you have the following libraries installed:

- `ghdl`
- `gtkwave`

- ## Running

Run the following command:

- `make view`

## Collaborators:
- Adryan Castro Feres
- Vitor Kenji Zoppo Yamada
