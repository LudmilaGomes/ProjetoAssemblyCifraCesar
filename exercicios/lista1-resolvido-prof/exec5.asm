.686
.model flat, stdcall
option casemap:none

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

.code
start:
    mov ebx, 11
    mov ecx, 1000
    
    ; EM DIV, EDX:EAX / REG

    inicio_loop:
        mov eax, ecx
        xor edx, edx

        div ebx
        cmp edx, 5

        je imprimir
        
        continua_laco:
            inc ecx
            cmp ecx, 1999
            jbe inicio_loop
            jmp fim_programa

    imprimir:
        push ecx
        printf("%d ", ecx)
        pop ecx
        jmp continua_laco
    fim_programa:
        invoke ExitProcess, 0
end start