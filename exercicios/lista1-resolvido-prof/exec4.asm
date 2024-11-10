.686                    
.model flat, stdcall    ; INDICAMOS A FORMA COMO OS PARÂMETROS SÃO PASSADOS PARA AS FUNÇÕES
option casemap :none    ; LABELS 'SENSÍVEIS AO CONTEXTO' (OU SEJA, CASE SENSITIVE)

; INCLUSÃO DE BIBLIOTECAS PARA FUNCIONAMENTO DO ASSEMBLY E PARA 'PRINTF()'
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
    num1 dd 8

.code
start:
    mov ebx, 2
    mov eax, num1
    xor edx, edx
    
    ; DIVIDE EDX:EAX / REG -> QUOCIENTE VAI PARA EAX, RESTO VAI PARA EDX
    div ebx
    
    cmp edx, 0
    je eh_par

    printf("%d eh impar\n", num1)
    jmp fim_programa

    eh_par:
        printf("%d eh par\n", num1)

    fim_programa:
        invoke ExitProcess, 0
end start

;
;   mov eax, num1
;   and eax, 1
;   cmp eax, 0
;