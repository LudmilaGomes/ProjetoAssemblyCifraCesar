.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

; a = b + c + 100

.data
    var_a dd ?
    var_b dd 30
    var_c dd 50

.code
start:
    mov eax, var_a
    add eax, var_b
    add eax, var_c
    add eax, 100
    mov var_a, eax
    printf("var_a = %d\n", var_a)
    invoke ExitProcess, 0
end start