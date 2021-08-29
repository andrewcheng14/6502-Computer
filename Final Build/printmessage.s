PORTB = $6000
PORTA = $6001
DDRB = $6002 ; Data Direction Register B (used for settings pins on PORTB to input/output)
DDRA = $6003 ; Data Direction Register A

E  = %10000000 ; Enable bit - Setting to 1 starts data read/write
RW = %01000000 ; Read/Write bit - 1 to read, 0 to write
RS = %00100000 ; Register Select bit - 1 for data registers, 0 for instruction registers

  .org $8000 ; A15 pin (6502) is connected to CE (ROM); ROM only enabled from 8000 -> FFFF  

reset:
  ldx #$ff   ; set stack pointer to 01FF
  txs

  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA

  lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00001110 ; Display on; cursor on; blink off
  jsr lcd_instruction
  lda #%00000110 ; Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda #%00000001 ; clear display
  jsr lcd_instruction

  ldx #0
print_message:
  lda message,x  ; Sets zero flag if 0 was loaded to A register
  beq loop
  jsr print_char
  inx
  jmp print_message

loop:            ; infinite loop to 'pause' lcd
  jmp loop

message: .asciiz "Go Dawgs!"

lcd_wait:        ; wait for LCD to not be busy
  pha            ; push value at A register to stack 
  lda #%00000000 ; Set all pins on port B to input (read)
  sta DDRB
lcd_busy:
  lda #RW        ; Set read bit (to enable reading)
  sta PORTA
  lda #(RW | E)  ; Setting enable bit (to perform read)
  sta PORTA
  lda PORTB      ; read from port B
  and #%10000000 ; bit mask
  bne lcd_busy   ; branch if zero bit is set (LCD is busy) 

  lda #RW
  sta PORTA  
  lda #%11111111 ; set all pins on port B to ouput
  sta DDRB
  pla            ; pull value from stack to A register
  rts

lcd_instruction:
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts

print_char:
  jsr lcd_wait
  sta PORTB
  lda #RS        ; Set RS bit to Data Registers (for R/W)
  sta PORTA
  lda #(RS | E)  
  sta PORTA
  lda #RS
  sta PORTA
  rts

  .org $fffc     ; program counter is loaded with the value stored at this address
  .word reset    
  .word $0000    ; padding                                                         

