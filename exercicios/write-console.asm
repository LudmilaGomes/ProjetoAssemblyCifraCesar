.686

.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

.data

output db "Hello World!", 0ah, 0h
outputHandle dd 0 ; Variavel para armazenar o handle de saida
write_count dd 0; Variavel para armazenar caracteres escritos na console

.code
start:

push STD_OUTPUT_HANDLE
call GetStdHandle ;Call convention do tipo callee clean-up, nao precisa mover esp depois
mov outputHandle, eax
invoke WriteConsole, outputHandle, addr output, sizeof output, addr write_count, NULL
invoke ExitProcess, 0

end start
