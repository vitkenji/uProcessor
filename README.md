# Microprocessor

## Instructions

| Mnemonic | Opcode | Format | Description
| --       |--      |--      | --
| add      | 0010   |  R     | A += rd
| addi     | 0011   |  I     | A += Imm
| sub      | 0100   |  R     | A -= rd
| and      | 0101   |  R     | A && rd
| xor      | 0110   |  R     | A ^= rd
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
