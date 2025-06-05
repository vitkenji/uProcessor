# Microprocessor

## Instructions

| Mnemonic | Opcode | Format | Description
| --       |--      |--      | --
| add      | 0001   |  R     | A += rd
| sub      | 0010   |  R     | A -= rd
| xor      | 0011   |  R     | A ^= rd
| and      | 0100   |  R     | A && rd
| ld       | 1000   |  I     | rd = Imm
| addi     | 1001   |  I     | A += Imm
| movA     | 1101   |  R     | A = rd
| movR     | 1110   |  R     | rd = A
| jump     | 1111   |  B     |

## Instruction formats

B:
| imm (13) | opcode (4)
| --      | --

R:
| nothing (10) | rd (3) | opcode(4)
| --      | --    | --    

I: 
| imm(10)  | rd(3) | opcode(4)
| --      | --    | --




## Collaborators:
- Adryan Castro Feres
- Vitor Kenji Zoppo Yamada
