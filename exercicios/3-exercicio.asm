.686                    
.model flat, stdcall    ; INDICAMOS A FORMA COMO OS PARAMETROS SAO PASSADOS PARA AS FUNCOES
option casemap :none    ; LABELS 'SENSIVEIS AO CONTEXTO' (OU SEJA, CASE SENSITIVE)

; INCLUSAO DE BIBLIOTECAS PARA FUNCIONAMENTO DO ASSEMBLY E PARA 'PRINTF()'
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

; temos duas variaveis; testamos qual eh maior e exibimos o seu valor
; se sao iguais, exibimos qualquer uma

.data
variavel1 dd 24
variavel2 dd 12

.code

start:

    mov eax, variavel1
    mov ebx, variavel2

    cmp eax, ebx ; o primeiro menos o segundo

    je label1 ; testa se sao iguais
    jl label2 ; testa se o primeiro eh menor que o segundo
    jg label3 ; testa se o primeiro eh maior que o segundo

    label1:
        printf("caso 1 - sao iguais; valor = %d\n", eax)
    label2:
        printf("caso 2 - variavel2 eh maior; variavel2 = %d\n", ebx)
    label3:
        printf("caso 3 - variavel1 eh maior; variavel1 = %d\n", eax)
    invoke ExitProcess, 0

end start