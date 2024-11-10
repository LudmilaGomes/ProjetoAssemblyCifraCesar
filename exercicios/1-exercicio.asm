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

; somar os numeros de 1 a 100 e exibir o resultado na tela
; usar registrador; não usar variaveis
; comentar

.data
i dd 0
variavel dd 0
comparar dd 100

.code
start:
    mov eax, variavel
    mov ebx, i

    laco_somatorio:
        add ebx, 1
        add eax, ebx
        cmp ebx, comparar
        jl laco_somatorio

    printf("valor final = %d\n", eax)
    invoke ExitProcess, 0

end start