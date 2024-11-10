.686 ; 

.model flat,stdcall ; memória flat (algo único: mesmo espaço de endereçamento para instruções e dados
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

inputString db 10 dup(0)
endString db ?
inputHandle dd 0 ; Variavel para armazenar o handle de entrada
outputHandle dd 0 ; Variavel para armazenar o handle de saida
console_count dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string dd 0 ; Variavel para armazenar tamanho de string terminada em 0

.code

; FUNCAO PARA REMOVER \n DE STRINGS
; ATUALIZAMOS AS INSTRUCOES PARA GARANTIR QUE O LOOP CHEGA AO FIM (SE NAO ENCONTRAR UM \n NA STRING, VERIFICAR TERMINADOR DE STRING)

RemoveEspaco:

; PROLOGO DA FUNC

push ebp        ; antigo ebp eh salvo na pilha
mov ebp, esp    ; move o valor de esp para ebp
sub esp, 4      ; agora, alocamos o espaco para nossas variaveis locais; a variavel eh um endereco de string (4 bytes)

; FUNC

mov eax, DWORD PTR [ebp+8] ; salvamos em eax o conteudo de [ebp+8], que eh o endereco da nossa string
mov DWORD PTR [ebp-4], eax ; salvamos no espaco alocado na pilha o conteudo de eax

mov esi, DWORD PTR [ebp-4] ; Armazenar apontador da string em esi
proximo:
mov al, [esi] ; Mover caractere atual para al
inc esi ; Apontar para o proximo caractere
cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
jne proximo
dec esi ; Apontar para caractere anterior, onde o CR foi encontrado
xor al, al ; ASCII 0, terminado de string
mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR

mov eax, DWORD PTR [ebp-4] ; salvamos no reg eax o conteudo de [ebp-4], que eh o endereco da string

; para chamarmos a instrucao RET, precisamos ter o endereco de retorno no topo da pilha
; EPILOGO DA FUNC
; desalocamos o espaco armazenado na pilha para as variaveis locais
mov esp, ebp    ; move o valor de ebp para esp, que eh o antigo ebp
pop ebp         ; o valor que esta no topo da pilha eh o antigo ebp; usamos a instrucao 'pop ebp'
ret 4           ; retiramos o parametro da func que estava na pilha com 'ret 4'

start:

invoke GetStdHandle, STD_INPUT_HANDLE
mov inputHandle, eax
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov outputHandle, eax
invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL

; PASSAGEM DOS PARAMETROS: PASSAMOS O ENDERECO DA STRING PARA A PILHA
; LEMBRANDO - EAX: 4 BYTES, AX: 2 BYTES, AH E AL: 1 BYTE

mov esi, offset inputString
push esi
call RemoveEspaco ; usamos call e essa instrucao coloca no topo da pilha o endereco de retorno

; AS INSTRUCOES ABAIXO SAO A FUNCAO
; PASSAMOS OS PARAMETROS DA FUNCAO PARA A PILHA
;mov esi, offset inputString ; Armazenar apontador da string em esi
;proximo:
;mov al, [esi] ; Mover caractere atual para al
;inc esi ; Apontar para o proximo caractere
;cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
;jne proximo
;dec esi ; Apontar para caractere anterior, onde o CR foi encontrado
;xor al, al ; ASCII 0, terminado de string
;mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR
; O ENDERECO DE RETORNO EH ENVIADO PARA A PILHA POR MEIO DA INSTRUCAO CALL

mov ebx, eax
invoke StrLen, ebx
mov tamanho_string, eax
invoke WriteConsole, outputHandle, ebx, tamanho_string, addr console_count, NULL

invoke ExitProcess, 0

end start
