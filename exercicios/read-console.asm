.686

.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

inputString db 50 dup(0)
inputHandle dd 0 ; Variavel para armazenar o handle de entrada
outputHandle dd 0 ; Variavel para armazenar o handle de saida
console_count dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string dd 0 ; Variavel para armazenar tamanho de string terminada em 0

.code



start:

invoke GetStdHandle, STD_INPUT_HANDLE
mov inputHandle, eax
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov outputHandle, eax
invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL

mov esi, offset inputString ; Armazenar apontador da string em esi
proximo:
mov al, [esi] ; Mover caractere atual para al
inc esi ; Apontar para o proximo caractere
cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
jne proximo
dec esi ; Apontar para caractere anterior, onde o CR foi encontrado
xor al, al ; ASCII 0, terminado de string
mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR

invoke StrLen, addr inputString
mov tamanho_string, eax
invoke WriteConsole, outputHandle, addr inputString, tamanho_string, addr console_count, NULL
jmp start

invoke ExitProcess, 0

end start
