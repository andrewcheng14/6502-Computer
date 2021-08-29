  .org $8000 ; A15 pin is connected to CE; EEPROM only enabled from 8000 -> FFFF

reset:
  lda #$ff
  sta $6002
  
loop:
  lda #$ff
  sta $6000

  jmp loop

  .org $fffc
  .word reset
  .word $0000
