;*******************************************************************************
; Bootloader Program
; Philip Wingemo
;
;*******************************************************************************

;+-------------------------------------------------------+
;| Address  | Contents                                   |
;+-------------------------------------------------------+
;| 0x7C00   | 0x0000                                     |
;| 0x7C02   | 0x0000                                     |
;| 0x7C04   | 0x0000                                     |
;| 0x7C06   | 0x0000                                     |
;| 0x7C08   | 0x0000                                     |
;| 0x7C0A   | 0x0000                                     |
;| 0x7C0C   | 0x0000                                     |
;| 0x7C0E   | 0x0000                                     |
;| 0x7C10   | 0x0000                                     |
;| 0x7C12   | 0x0000                                     |
;| 0x7C14   | 0x0000                                     |
;| 0x7C16   | 0x0000                                     |
;| 0x7C18   | 0x0000                                     |
;| 0x7C1A   | 'H'                                        |
;| 0x7C1C   | 'e'                                        |
;| 0x7C1E   | 'l'                                        |
;| 0x7C20   | 'l'                                        |
;| 0x7C22   | 'o'                                        |
;| 0x7C24   | ' '                                        |
;| 0x7C26   | 'W'                                        |
;| 0x7C28   | 'o'                                        |
;| 0x7C2A   | 'r'                                        |
;| 0x7C2C   | 'l'                                        |
;| 0x7C2E   | 'd'                                        |
;| 0x7C30   | '!'                                        |
;| 0x7C32   | 0x0D                                       |
;| 0x7C34   | 0x0A                                       |
;| 0x7C36   | 0x00                                       |
;| 0x0200   | 0xAA55                                     |
;+-------------------------------------------------------+

;+-------------------------------------------------------+
;| Register | Configuration                              |
;+-------------------------------------------------------+
;| AX       | 0x0000                                      |
;| BX       | 0x0000                                      |
;| CX       | 0x0000                                      |
;| DX       | 0x0000                                      |
;| SP       | 0x7C00                                      |
;| BP       | 0x0000                                      |
;| SI       | 0x7C1A                                      |
;| DI       | 0x0000                                      |
;+-------------------------------------------------------+

section .data
    msg_hello db 'Hello world!', 0
    ENDL db 0x0D, 0x0A, 0

;-------------------------------------------------------------------------------
; Set the origin point of the program to memory address 0x7C00.
; This address is commonly used for bootloaders to ensure proper memory location.
;-------------------------------------------------------------------------------
org 0x7C00

;-------------------------------------------------------------------------------
; Specify 16-bit instructions.
;-------------------------------------------------------------------------------
bits 16

;-------------------------------------------------------------------------------
; Entry point of the program.
; This is where the program execution begins.
;-------------------------------------------------------------------------------
global _main

_main:
    call _setup_stack  ; Call the subroutine to set up the stack
    push msg_hello     ; Push the address of the message onto the stack
    call _print_string ; Call the string printing subroutine
    add sp, 2          ; Restore the stack pointer after the call
    hlt                ; Halt the central processing unit (CPU)

;-------------------------------------------------------------------------------
; String Printing Subroutine
;-------------------------------------------------------------------------------
; This subroutine prints a null-terminated string pointed to by the top of the stack
; using BIOS interrupt 0x10.
;-------------------------------------------------------------------------------
_print_string:
    mov ah, 0x0E       ; Function to print character in AL
.print_loop:
    pop si             ; Pop the address of the next character from the stack to SI
    mov al, byte [si]  ; Load the character from the address in SI to AL
    cmp al, 0          ; Compare AL with null terminator
    je .print_done     ; If null terminator, printing is done
    int 0x10           ; Call BIOS interrupt to print character
    jmp .print_loop    ; Repeat the loop for the next character
.print_done:
    ret

;-------------------------------------------------------------------------------
; Stack Setup Subroutine
;-------------------------------------------------------------------------------
; This subroutine initializes the stack segment (SS) and stack pointer (SP) to
; establish a functional stack for the bootloader. The stack is crucial for
; temporarily storing data during program execution and subroutine calls.
;-------------------------------------------------------------------------------
_setup_stack:
    mov ss, ax         ; Initialize the Stack Segment (SS) with value in AX
    mov sp, 0x7C00     ; Set the Stack Pointer (SP) to memory address 0x7C00
    ret                ; Return from the subroutine

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
