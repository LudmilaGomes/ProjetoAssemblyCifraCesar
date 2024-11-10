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

.data 
    num1 dd 10
    num2 dd 20

.code

start:
    mov eax, num1
    cmp eax, num2

    ; RESULTADO DA COMPARACAO AGORA PODE TER SINAL
    jg num1_eh_maior
    
    printf("O numero maior eh %d\n", num2)
    jmp fim_programa
    
    num1_eh_maior:
        printf("O numero maior eh %d\n", num1)

    fim_programa:
        invoke ExitProcess, 0
end start