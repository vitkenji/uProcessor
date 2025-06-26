# Microprocessor

## Instructions

| Mnemonic   | Opcode | Format | Description
| --         |--      |--      | --
| LD Rn,i    | 0001   |  I     | Rn = i
| ADD Rn     | 0010   |  R     | A += Rn
| SUB Rn     | 0011   |  R     | A -= Rn
| MOV A,Rn   | 0100   |  R     | A = Rn
| CMPR       | 0101   |  R     | 
| MOV Rn,A   | 0110   |  R     | Rn = A
| BLE b      | 0111   |  B     | A <= reg ? PC+b (branch if less or equal, usa flags da ALU) 
| BHS b      | 1000   |  B     | A >= reg ? PC+b (branch if higher or same, usa flags da ALU)
| SW         | 1001   |  M     | RAM[Rn]= A
| LW         | 1010   |  M     | A =  RAM[Rn]
| JUMP i     | 1111   |  J     | address = i

## Instruction formats

B:
| opcode (4) | rn (3) | consts(10) 
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

## Collaborators:
- Adryan Castro Feres
- Vitor Kenji Zoppo Yamada
