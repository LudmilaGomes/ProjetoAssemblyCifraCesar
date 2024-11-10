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
    xor eax, eax ; EAX ARMAZENA 0; FORMA MAIS EFICIENTE DE ATRIBUIR 0 AO REG
    mov ecx, 1   ; ECX ARMAZENA 1

    laco_somatorio:
        add eax, ecx ; SOMA EM EAX O CONTEUDO DE ECX
        inc ecx      ; ECX EH INCREMENTADO EM 1
        cmp ecx, 100 ; COMPARA O VALOR DE ECX COM 100
        ; USAMOS O JUMP [jbe] PARA OPERACOES SEM SINAL (UNSIGNED)

    jbe laco_somatorio ; SE ECX EH MENOR OU IGUAL A 100, VOLTA PARA O LABEL laco_somatorio

    printf("O resultado do somatorio eh: %d\n", eax)
    invoke ExitProcess, 0 ; SAÍDA DO PROGRAMA

end start