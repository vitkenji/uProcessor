# Microprocessor

## Instructions

| Mnemonic | Opcode | Format | Description
| --       |--      |--      | --
| ld       | 0001   |  R     | rn = Imm
| add      | 0010   |  I     | A += rn
| sub      | 0011   |  R     | A -= rn
| mov  a   | 0100   |  R     | A = rn
| comp     | 0101   |  R     | 
| mov rn   | 0110   |  B     | rn = A
| ble      | 0111   |  R     | 
| bhs      | 1000   |  B     |

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
