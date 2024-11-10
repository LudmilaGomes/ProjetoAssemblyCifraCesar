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

; le o valor da variavel e exibe na tela se o numero eh par ou impar

.data
variavel dd 50
nulo dd 0
operador dd 2

; 50 - 110010
; 51 - 110011

.code
start:

    ; a operacao de divisao separa o valor da variavel em duas partes que sao armazenadas nos registradores EDX e EAX
    ; passamos o operador guardado em um registrador: DIV reg; o quociente sera armazenado em EAX e o resto, em EDX

    ; como separar o valor da variavel (51) nos registradores EAX e EDX?

    mov edx, nulo
    mov eax, variavel
    mov ecx, operador

    div ecx

    ; esses testes abaixo nao funcionaram corretamente
    ;jpe label1  ; testa se eh par
    ;jnp label2  ; testa se eh impar

    cmp edx, nulo

    je label1
    jne label2

    label1:
        printf("%d eh par\n", variavel)
        invoke ExitProcess, 0
    label2:
        printf("%d eh impar\n", variavel)
        invoke ExitProcess, 0

end start