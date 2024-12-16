/*
 * File:   %<%NAME%>%.%<%EXTENSION%>%
 * Author: %<%USER%>%
 *
 * Created on %<%DATE%>%, %<%TIME%>%
 */

    .include "p33fj32mc202.inc"

    ; _____________________Configuration Bits_____________________________
    ;User program memory is not write-protected
    #pragma config __FGS, GWRP_OFF & GSS_OFF & GCP_OFF
    
    ;Internal Fast RC (FRC)
    ;Start-up device with user-selected oscillator source
    #pragma config __FOSCSEL, FNOSC_FRC & IESO_ON
    
    ;Both Clock Switching and Fail-Safe Clock Monitor are disabled
    ;XT mode is a medium-gain, medium-frequency mode that is used to work with crystal
    ;frequencies of 3.5-10 MHz
  ; #pragma config __FOSC, FCKSM_CSDCMD & POSCMD_XT
    
    ;Watchdog timer enabled/disabled by user software
    #pragma config __FWDT, FWDTEN_OFF
    
    ;POR Timer Value
    #pragma config __FPOR, FPWRT_PWR128
   
    ; Communicate on PGC1/EMUC1 and PGD1/EMUD1
    ; JTAG is Disabled
    #pragma config __FICD, ICS_PGD1 & JTAGEN_OFF

;..............................................................................
;Program Specific Constants (literals used in code)
;..............................................................................

    .equ SAMPLES, 64         ;Number of samples



;..............................................................................
;Global Declarations:
;..............................................................................

    .global _wreg_init       ;Provide global scope to _wreg_init routine
                                 ;In order to call this routine from a C file,
                                 ;place "wreg_init" in an "extern" declaration
                                 ;in the C file.

    .global __reset          ;The label for the first line of code.

;..............................................................................
;Constants stored in Program space
;..............................................................................

    .section .myconstbuffer, code
    .palign 2                ;Align next word stored in Program space to an
                                 ;address that is a multiple of 2
ps_coeff:
    .hword   0x0002, 0x0003, 0x0005, 0x000A




;..............................................................................
;Uninitialized variables in X-space in data memory
;..............................................................................

    .section .xbss, bss, xmemory
x_input: .space 2*SAMPLES        ;Allocating space (in bytes) to variable.



;..............................................................................
;Uninitialized variables in Y-space in data memory
;..............................................................................

    .section .ybss, bss, ymemory
y_input:  .space 2*SAMPLES




;..............................................................................
;Uninitialized variables in Near data memory (Lower 8Kb of RAM)
;..............................................................................

    .section .nbss, bss, near
var1:     .space 2               ;Example of allocating 1 word of space for
                                 ;variable "var1".




;..............................................................................
;Code Section in Program Memory
;..............................................................................

.text                             ;Start of Code section
__reset:
    MOV #__SP_init, W15       ;Initalize the Stack Pointer
    MOV #__SPLIM_init, W0     ;Initialize the Stack Pointer Limit Register
    MOV W0, SPLIM
    NOP                       ;Add NOP to follow SPLIM initialization

    CALL _wreg_init           ;Call _wreg_init subroutine
                                  ;Optionally use RCALL instead of CALL

; Práctica 2
; 15.10.24
; Para A, B, ..., I :  <15:0>
; Switch (W11)
; Case 0: OrdenaAscendente(A, B, ..., I)
; Case 1: OrdenaDescendente(A, B, ..., I)
; Case 2: ObtenerPares(A, B, ..., I)
; Case 3: ObtenerImpares(A, B, ..., I)

; Selector
MOV #0x0, W11

;ABCDFGHI
MOV #0xA,W1     ; A
MOV #0xE,W2	; B
MOV #0x3,W3     ; C
MOV #0x8,W4     ; D
MOV #0x2,W5     ; E
MOV #0x6,W6	; F
MOV #0xC,W7     ; G
MOV #0xB,W8     ; H
MOV #0x9,W9	; I
				  
;Switch Case
CP W11, #0x0    ;Case 0
BRA Z, OrdenaAscendente

CP W11, #0x1    ;Case 1
BRA Z, OrdenaDescendente

CP W11, #0x2    ;Case 2
BRA Z, ObtenerPares

CP W11, #0x3     ;Case 3
BRA Z, ObtenerImpares

OrdenaAscendente:
        MOV #8, W10      ; contador externo (número de registros - 1)
    
    LoopExterno:
        CP W10, #0
        BRA Z, EndSort   ; Si W10 es 0, sal del bucle y termina la ordenación
    
        ; Inicializamos el índice interno
        MOV #1, W12      ; W12 será el índice interno de comparación
    
    LoopInterno:
        ; Compara W1 con W2, W2 con W3, ..., W8 con W9
    
        CP W1, W2
        BRA LE, Swap1
        EXCH W1, W2
    Swap1:
    
        CP W2, W3
        BRA LE, Swap2
        EXCH W2, W3
    Swap2:
    
        CP W3, W4
        BRA LE, Swap3
        EXCH W3, W4
    Swap3:
    
        CP W4, W5
        BRA LE, Swap4
        EXCH W4, W5
    Swap4:
    
        CP W5, W6
        BRA LE, Swap5
        EXCH W5, W6
    Swap5:
    
        CP W6, W7
        BRA LE, Swap6
        EXCH W6, W7
    Swap6:
    
        CP W7, W8
        BRA LE, Swap7
        EXCH W7, W8
    Swap7:
    
        CP W8, W9
        BRA LE, Swap8
        EXCH W8, W9
    Swap8:
    
        ; Fin del bucle interno
    
        DEC W10, W10          ; Reducimos el contador externo
        BRA LoopExterno  ; Repetimos el proceso hasta que el array esté ordenado
    
    EndSort:
        RETURN
    
  
OrdenaDescendente:
        MOV #8, W10      ; contador externo (número de registros - 1)
    
    LoopExterno2:
        CP W10, #0
        BRA Z, EndSort2   ; Si W10 es 0, sal del bucle y termina la ordenación
    
        ; Inicializamos el índice interno
        MOV #1, W12      ; W12 será el índice interno de comparación
    
    LoopInterno2:
        ; Compara W1 con W2, W2 con W3, ..., W8 con W9
    
        CP W1, W2
        BRA GE, DSwap1
        EXCH W1, W2
    DSwap1:
    
        CP W2, W3
        BRA GE, DSwap2
        EXCH W2, W3
    DSwap2:
    
        CP W3, W4
        BRA GE, DSwap3
        EXCH W3, W4
    DSwap3:
    
        CP W4, W5
        BRA GE, DSwap4
        EXCH W4, W5
    DSwap4:
    
        CP W5, W6
        BRA GE, DSwap5
        EXCH W5, W6
    DSwap5:
    
        CP W6, W7
        BRA GE, DSwap6
        EXCH W6, W7
    DSwap6:
    
        CP W7, W8
        BRA GE, DSwap7
        EXCH W7, W8
    DSwap7:
    
        CP W8, W9
        BRA GE, DSwap8
        EXCH W8, W9
    DSwap8:
    
        ; Fin del bucle interno
    
        DEC W10, W10          ; Reducimos el contador externo
        BRA LoopExterno2  ; Repetimos el proceso hasta que el array esté ordenado
    
    EndSort2:
        RETURN
    
ObtenerPares:
    MOV #0x2, W10
    MOV W1, W15
    MOV #0x0, W1
    MOV #0x0, W0
    
    Repeat #17
    DIV.U W15,W10
    
    CP W1, #0
    
        BRA Z, Clear1
        CLR W15
    Clear0:
        Repeat #17
	DIV.U W2,W10
	
	CP W1, #0
    
        BRA Z, Clear1
        CLR W2
    Clear1:
    
        Repeat #17
	DIV.U W3,W10
	
	CP W1, #0
    
        BRA Z, Clear2
        CLR W3
    Clear2:
        Repeat #17
	DIV.U W4,W10
	
	CP W1, #0
    
        BRA Z, Clear3
        CLR W4
    Clear3:
        Repeat #17
	DIV.U W5,W10
	
	CP W1, #0
    
        BRA Z, Clear4
        CLR W5
    Clear4:
        Repeat #17
	DIV.U W6,W10
	
	CP W1, #0
    
        BRA Z, Clear5
        CLR W6
    Clear5:
        Repeat #17
	DIV.U W7,W10
	
	CP W1, #0
    
        BRA Z, Clear6
        CLR W7
    Clear6:
        Repeat #17
	DIV.U W8,W10
	
	CP W1, #0
    
        BRA Z, Clear7
        CLR W8
    Clear7:
        Repeat #17
	DIV.U W9,W10
	
	CP W1, #0
    
        BRA Z, Clear8
        CLR W9
    Clear8:
	RETURN

ObtenerImpares:
    MOV #0x2, W10
    MOV W1, W15
    MOV #0x0, W1
    MOV #0x0, W0
    
    Repeat #17
    DIV.U W15,W10
    
    CP W1, #0
    
        BRA NZ, NClear1
        CLR W15
    NClear0:
        Repeat #17
	DIV.U W2,W10
	
	CP W1, #0
    
        BRA NZ, NClear1
        CLR W2
    NClear1:
    
        Repeat #17
	DIV.U W3,W10
	
	CP W1, #0
    
        BRA NZ, NClear2
        CLR W3
    NClear2:
        Repeat #17
	DIV.U W4,W10
	
	CP W1, #0
    
        BRA NZ, NClear3
        CLR W4
    NClear3:
        Repeat #17
	DIV.U W5,W10
	
	CP W1, #0
    
        BRA NZ, NClear4
        CLR W5
    NClear4:
        Repeat #17
	DIV.U W6,W10
	
	CP W1, #0
    
        BRA NZ, NClear5
        CLR W6
    NClear5:
        Repeat #17
	DIV.U W7,W10
	
	CP W1, #0
    
        BRA NZ, NClear6
        CLR W7
    NClear6:
        Repeat #17
	DIV.U W8,W10
	
	CP W1, #0
    
        BRA NZ, NClear7
        CLR W8
    NClear7:
        Repeat #17
	DIV.U W9,W10
	
	CP W1, #0
    
        BRA NZ, NClear8
        CLR W9
    NClear8:
	RETURN
	
    RETURN

;..............................................................................
;Subroutine: Initialization of W registers to 0x0000
;..............................................................................

_wreg_init:
    CLR W0
    MOV W0, W14
    REPEAT #12
    MOV W0, [++W14]
    CLR W14
    RETURN




;--------End of All Code Sections ---------------------------------------------

.end                               ;End of program code in this file
