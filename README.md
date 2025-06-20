# Microprocessor

## Instructions

| Mnemonic   | Opcode | Format | Description
| --         |--      |--      | --
| LD Rn,i    | 0001   |  I     | Rn = i
| ADD Rn     | 0010   |  R     | A += Rn
| SUB Rn     | 0011   |  R     | A -= Rn
| MOV A,Rn   | 0100   |  R     | A = Rn
| CMPR       | 0101   |  R     | 
| MOV Rn,A   | 0110   |  B     | Rn = A
| BLE Rn,i,b | 0111   |  B     | Rn <= i ? adr+b 
| BHS Rn,i,b | 1000   |  B     | Rn >= i ? adr+b
| SW         | 1001   |  B     | RAM[Rn]= A
| LW         | 1010   |  B     | A =  RAM[Rn]
| JUMP i     | 1111   |  J     | address = i

## Instruction formats

B:
| opcode (4) | opcode (4)
| --      | --

R:
| opcode (4) | rd (3) | opcode(4)
| --      | --    | --    

I: 
| opcode (4)  | rd(3) | opcode(4)
| --      | --    | --




## Collaborators:
- Adryan Castro Feres
- Vitor Kenji Zoppo Yamada
