;*******************************************************************************
; Bootloader Program
; Philip Wingemo
;
;*******************************************************************************

;+-------------------------------------------------------+
;| Address | Contents                                     |
;+-------------------------------------------------------+
;| 0x7C00 | 0x0000                                       |
;| 0x7C02 | 0x0000                                       |
;| 0x7C04 | 0x0000                                       |
;| 0x7C06 | 0x0000                                       |
;| 0x7C0A | 0x0000                                       |
;| 0x7C12 | 0x0000                                       |
;| 0x7C16 | 0x0000                                       |
;| 0x7C18 | 0x0000                                       |
;| 0x7C20 | 0x0000                                       |
;| 0x7C22 | 0x0000                                       |
;| 0x7C26 | 0x0000                                       |
;| 0x7C28 | 0x0000                                       |
;| 0x510  | 0xAA55                                       |
;+-------------------------------------------------------+

;+-------------------------------------------------------+
;| Register | Configuration                              |
;+-------------------------------------------------------+
;| AX | 0x0000                                           |
;| BX | 0x0000                                           |
;| CX | 0x0000                                           |
;| DX | 0x0000                                           |
;| SP | 0x7C00                                           |
;| BP | 0x0000                                           |
;| SI | 0x0000                                           |
;| DI | 0x0000                                           |
;+-------------------------------------------------------+

;-------------------------------------------------------------------------------
; Set the origin point of the program to memory address 0x7C00.
; This address is commonly used for bootloaders to ensure proper memory location.
;-------------------------------------------------------------------------------
[ORG 0x7C00]

;-------------------------------------------------------------------------------
; Specify 16-bit instructions.
;-------------------------------------------------------------------------------
[BITS 16]

;-------------------------------------------------------------------------------
; Entry point of the program.
; This is where the program execution begins.
;-------------------------------------------------------------------------------
global _main

;-------------------------------------------------------------------------------
; Call the subroutine to set up the stack
; Halts the central processing unit (CPU) 
;-------------------------------------------------------------------------------
_main:
    call _setup_stack  ; Call the subroutine to set up the stack
    hlt                ; Halts the central processing unit (CPU) 

;-------------------------------------------------------------------------------
; Stack Setup Subroutine
;-------------------------------------------------------------------------------
; This subroutine initializes the stack segment (SS) and stack pointer (SP) to
; establish a functional stack for the bootloader. The stack is crucial for
; temporarily storing data during program execution and subroutine calls.
;-------------------------------------------------------------------------------
_setup_stack:
    mov ss, 0         ; Initialize the Stack Segment (SS) with value 0
    mov sp, 0x7C00    ; Set the Stack Pointer (SP) to memory address 0x7C00
    ret               ; Return from the subroutine

;-------------------------------------------------------------------------------
; Fill the code with zeroes up to byte 510.
; This is done to ensure that the bootloader takes up the required space.
;-------------------------------------------------------------------------------
times 510 - ($ - $$) db 0

;-------------------------------------------------------------------------------
;  The boot signature is a two-byte value that marks this bootloader as a valid.
;  It is recognized by the BIOS to indicate bootable media.
;-------------------------------------------------------------------------------
dw 0xAA55            ; The boot signature is a two-byte value (0xAA55) 

;-------------------------------------------------------------------------------
; End of Bootloader Program
;*******************************************************************************
