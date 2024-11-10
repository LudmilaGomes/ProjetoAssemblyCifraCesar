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

; EXERCÍCIO: A = B + C + 100;

; SEÇÃO PARA INDICARMOS NOSSOS DADOS:
.data
a dd 8
b dd 16
catita dd 32

; SEÇÃO PARA ESCREVERMOS NOSSO CÓDIGO:
.code
start:

    ; MOVEMOS PARA O REGISTRADOR O CONTEÚDO DA VARIÁVEL
    mov eax, a
    mov ebx, b 
    mov ecx, catita

    ; REALIZAMOS AS SOMAS E AS EXIBIMOS
    add ecx, 100

    ; ENVIAMOS OS VALORES PARA O TOPO DA PILHA, POIS O USO DO PRINTF ALTERA OS VALORES ARMAZENADOS NOS REGISTRADORES
    push ecx
    push eax
    push ebx
    ; COMO ESTÁ A PILHA: TOPO -> (EBX, EAX, ECX)

    printf("catita + 100 = %d\n", ecx)

    ; PEGAMOS OS VALORES DE VOLTA DA PILHA E OS ARMAZENAMOS NOS REGISTRADORES
    pop ebx
    ; COMO ESTÁ A PILHA: TOPO -> (EAX, ECX)
    pop eax
    ; COMO ESTÁ A PILHA: TOPO -> (ECX)
    pop ecx
    ; COMO ESTÁ A PILHA: TOPO -> ()

    add ebx, ecx

    push eax
    push ebx
    ; COMO ESTÁ A PILHA: TOPO -> (EBX, EAX)

    printf("b + catita = %d\n", ebx)

    pop ebx
    ; COMO ESTÁ A PILHA: TOPO -> (EAX)
    pop eax
    ; COMO ESTÁ A PILHA: TOPO -> ()

    add eax, ebx

    printf("a + b = %d\n", eax)
    invoke ExitProcess, 0

end start