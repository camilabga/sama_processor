;
; Q02.asm
;
; Created: 21/05/2018 17:26:55
; Author : Camila Barbosa
;

.INCLUDE "M328PDEF.inc"

.ORG   0x0000    

RJMP SETUP   

BTS:
SBRS R19, 0
RJMP ZERAR_COUNTER
SBRS R21, 2
RJMP TIMER
RJMP TURBO
TIMER:
IN R17, TCNT0			; Read the timer
CP R17, R18				; Compare with previous value
MOV R18, R17			; Save current value
BRSH BTS				; Unless the timer has decreased, repeat
DEC R20

SBRC R20, 0
RJMP EXIBIR
SBRC R20, 1
RJMP EXIBIR
SBRC R20, 2
RJMP EXIBIR
SBRC R20, 3
RJMP EXIBIR
SBRC R20, 4
RJMP EXIBIR
SBRC R20, 5
RJMP EXIBIR
SBRC R20, 6
RJMP EXIBIR
SBRC R20, 7
RJMP EXIBIR

INC R21 // 3 SEGUNDOS
LDI R20, 60
SBRS R30, 0
RJMP CONTAR_DOWN
RJMP CONTAR_UP                   

SETUP:
LDI R16, 0b00011111              
OUT DDRD, R16
LDI R16, 0b11111111
OUT DDRB, R16
; 128

/* CONFIGURACAO TIMER */

LDI R16, 0b00000101
OUT TCCR0B, R16
LDI R16, 0b00000010		; CTC
OUT TCCR0A, R16
LDI R16, 0b11111111
OUT OCR0A, R16

LDI R24, 0x00
LDI R16, 0x00

/* SETAR 128 IN�CIO */
LDI R27, 0x08
LDI R28, 0x02
LDI R29, 0x01

LDI R30, 0x00 // UP - STATE
LDI R31, 0x00 // DOWN - STATE
LDI R19, 0x00 // TURBO - STATE

;LDI R29, 0x00
LOOP:
IN R16, PIND
SBRC R16, 7
RJMP UP
IN R16, PIND
SBRC R16, 6
RJMP DOWN
;RJMP LOOP
LDI R30, 0x00 // UP
LDI R31, 0x00 // DOWN
LDI R19, 0x00 // TURBO_DEVAGAR
RJMP EXIBIR
;IN R16, PINB
;CPI R16, 0b00000001
;BREQ VPP

TURBO:
IN R17, TCNT0			; Read the timer
CP R17, R26				; Compare with previous value
MOV R26, R17			; Save current value
BRSH TURBO		; Unless the timer has decreased, repeat
DEC R22
BRNE EXIBIR
LDI R22, 16
SBRS R30, 0
RJMP CONTAR_DOWN
RJMP CONTAR_UP

ZERAR_COUNTER:
CLR R18					
;LDI R20,255	
LDI R22, 16 // 0.3 segundos	
CLR R26
;CLR R15
LDI R21, 0x00 // COUNTER 3SEG
LDI R19, 0x01		
LDI R20, 60 // 1 segundo
SBRS R30, 0
RJMP DOWN
RJMP UP

UP:
SBRC R30, 0
RJMP BTS
LDI R30, 0x01
CONTAR_UP:
INC R27
CPI R27, 10
BREQ CARRY0UP
CPI R27, 6
BRNE EXIBIR
CPI R28, 5
BRNE EXIBIR
CPI R29, 2
BRNE EXIBIR
LDI R27, 0
LDI R28, 0
LDI R29, 0
RJMP EXIBIR

CARRY0UP:
LDI R27, 0x00
INC R28
CPI R28, 10
BREQ CARRY1UP
RJMP EXIBIR

CARRY1UP:
LDI R27, 0x00
LDI R28, 0x00
INC R29
RJMP EXIBIR

DOWN:
SBRC R31, 0
RJMP BTS
CONTAR_DOWN:
LDI R31, 0x01
DEC R27
CPI R27, 255
BREQ CARRY0DOWN
RJMP EXIBIR

CARRY0DOWN:
LDI R27, 9
DEC R28
CPI R28, 255
BREQ CARRY1DOWN
RJMP EXIBIR

CARRY1DOWN:
LDI R27, 9
LDI R28, 9
DEC R29
CPI R29, 255
BRNE EXIBIR
LDI R27, 0x00
LDI R28, 0x00
LDI R29, 0x00

EXIBIR:
MOV R24, R29 ;;;;;;;;;;;;;;;;;;;;; R27
OUT PORTB, R24
SBI PORTD, 2
LDI R25, 20
RCALL DELAY
CBI PORTD, 2
MOV R24, R28 ;;;;;;;;;;;;;;;;;;;;; R28
SBI PORTD, 3
OUT PORTB, R24
LDI R25, 20
RCALL DELAY
CBI PORTD, 3
MOV R24, R27 ;;;;;;;;;;;;;;;;;;;;; R29
SBI PORTD, 4
OUT PORTB, R24
LDI R25, 20
CALL DELAY
CBI PORTD, 4
;RJMP EXIBIR

RJMP LOOP

DELAY:
LDI R16, 1

OUTER_LOOP:
LDI R24, 0x10;LOW(RAMEND)
LDI R25, 0xE0;LOW(RAMEND)

DELAY_LOOP:
ADIW R24, 1
BRNE DELAY_LOOP
DEC R16
BRNE OUTER_LOOP
RET