; Ludmila Vinolia Guimaraes Gomes
.686
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

; STRINGS COM TEXTOS DO MENU, OPCOES ESCOLHIDAS E PARA DIGITAR ENTRADAS
menu db 0ah, 0ah, "             CIFRA DE CESAR             ", 0ah, 0ah, "================= MENU =================", 0ah, 0ah, "1- CRIPTOGRAFAR", 0ah, 0h, "2- DESCRIPTOGRAFAR", 0ah, 0h, "3- SAIR", 0ah, 0ah, 0h, "DIGITE A OPCAO DESEJADA: ", 0h
if_cript db 0ah, "============= CRIPTOGRAFAR =============", 0ah, 0ah, 0h
if_descript db 0ah, "=========== DESCRIPTOGRAFAR ============", 0ah, 0ah, 0h
if_sair db 0ah, "============== SAINDO ... ==============", 0ah, 0ah, 0h
text_entrada db "DIGITE O NOME DO ARQUIVO DE ENTRADA: ", 0h
text_saida db 0ah, "DIGITE O NOME DO ARQUIVO DE SAIDA: ", 0h
text_chave db 0ah, "DIGITE A CHAVE: ", 0h

; VARIAVEIS PARA LEITURA DA OPCAO DO USUARIO E PARA ARMAZENAR VALORES CONVERTIDOS
input_opcao db 3 dup(0)         
opcao_num dd ?                  ; salva o numero inteiro da entrada do usuario para menu apos conversao com atodw
input_arq_ent db 25 dup(0)      
input_arq_saida db 25 dup(0)    
input_chave db 5 dup(0)         
int_chave dd ?                  ; armazena inteiro para chave apos conversao com atodw

; VARIAVEIS AUXILIARES
fileBuffer db 512 dup(0)        ; armazena os bytes lidos do arquivo
count_bytes dd 0                ; armazena quantidade de bytes lidos do arquivo
fileHandle_leit dd 0            ; variavel para armazenar handle do arquivo de leitura
fileHandle_escr dd 0            ; variavel para armazenar handle do arquivo de escrita
count_pos_arq dd 0              ; contador para indicar a posicao correta do apontador de arquivo apos leituras do arquivo
inputHandle dd 0                
console_count dd 0              
outputHandle dd 0               
write_count dd 0                

.code
RemoveEspaco:
    ; PROLOGO DA FUNCAO; ALTERAMOS EBP E ESP, ALOCAMOS ESPACO PARA VARIAVEL LOCAL
    push ebp                    
    mov ebp, esp                
    sub esp, 4                  
    ; FUNCAO; ALOCAMOS A VARIAVEL LOCAL NO SEU ESPACO NA PILHA; EXECUCAO DO LOOP DA FUNCAO
    mov eax, DWORD PTR [ebp+8]  
    mov DWORD PTR [ebp-4], eax  
    mov esi, DWORD PTR [ebp-4]  
    ; VERIFICA CARACTERES DA STRING; CARACTERE '\n' OU '\0', QUANDO ENCONTRADOS, FAZEM LOOP CHEGAR AO FIM
    proximo:
        mov al, [esi]   
        inc esi         
        cmp al, 0       ; verificar se eh o caractere terminador de string (0)
        je desvio_term  
        cmp al, 13      ; verificar se eh o caractere ASCII CR - FINALIZAR
        jne proximo     
        dec esi         
        xor al, al      
        mov [esi], al   ; Inserir ASCII 0 no lugar do ASCII CR
    desvio_term:
        ; EPILOGO DA FUNCAO; DESALOCAMOS O ESPACO ALOCADO NA PILHA PARA AS VARIAVEIS LOCAIS DA FUNCAO
        mov esp, ebp    
        pop ebp         
        ret 4           

FuncCriptografia:
    ; PROLOGO DA FUNC; ALTERAMOS EBP E ESP, ALOCAMOS ESPACO PARA VARIAVEIS LOCAIS
    push ebp                    
    mov ebp, esp                
    sub esp, 12                 
    ; FUNCAO; SALVAMOS OS VALORES QUES ESTAO NA PILHA NOS ESPACOS ALOCADOS PARA AS VARIAVEIS DA FUNCAO NA PILHA
    mov eax, DWORD PTR [ebp+8]  
    mov DWORD PTR [ebp-4], eax  
    mov eax, DWORD PTR [ebp+12] 
    mov DWORD PTR [ebp-8], eax  
    mov eax, DWORD PTR [ebp+16] 
    mov DWORD PTR [ebp-12], eax 
    ; CRIPTOGRAFIA DO TEXTO; PERCORRE E SOMA BYTES LIDOS COM VALOR DA CHAVE
    mov edx, 0                  ; edx funcionara como contador; quando edx == count_bytes, ou seja, edx == ecx, a string chegou ao fim e a criptografia termina
    mov ebx, DWORD PTR [ebp-4]  
    mov ecx, DWORD PTR [ebp-8]  
    mov esi, DWORD PTR [ebp-12] 
    mov al, [esi]               ; salva o primeiro caractere em al
    seg_crip:
        add al, bl              ; criptografa o caractere
        mov [esi], al           ; salva o caractere criptografado de volta na string
        inc esi                 
        mov al, [esi]           
        inc edx                 
        cmp edx, ecx            ; comparamos contador (edx) com numero de bytes da string (ecx)
        jne seg_crip            ; loop enquanto nao chega ao fim da string
    ; EPILOGO DA FUNCAO; DESALOCAMOS O ESPACO ALOCADO NA PILHA PARA AS VARIAVEIS LOCAIS DA FUNCAO
    mov esp, ebp    
    pop ebp         
    ret 12          

FuncDescriptografia:
    ; PROLOGO DA FUNC; ALTERAMOS EBP E ESP, ALOCAMOS ESPACO PARA VARIAVEL LOCAL
    push ebp                     
    mov ebp, esp                 
    sub esp, 12                  
    ; FUNCAO; SALVAMOS OS VALORES QUES ESTAO NA PILHA NOS ESPACOS ALOCADOS PARA AS VARIAVEIS DA FUNCAO NA PILHA
    mov eax, DWORD PTR [ebp+8]   
    mov DWORD PTR [ebp-4], eax   
    mov eax, DWORD PTR [ebp+12]  
    mov DWORD PTR [ebp-8], eax   
    mov eax, DWORD PTR [ebp+16]  
    mov DWORD PTR [ebp-12], eax  
    ; DESCRIPTOGRAFIA DO TEXTO; PERCORRE E SUBTRAI BYTES LIDOS COM VALOR DA CHAVE
    mov edx, 0                   
    mov ebx, DWORD PTR [ebp-4]   
    mov ecx, DWORD PTR [ebp-8]   
    mov esi, DWORD PTR [ebp-12]  
    mov al, [esi]                
    seg_desc:
        sub al, bl            
        mov [esi], al            
        inc esi                  
        mov al, [esi]            
        inc edx                  
        cmp edx, ecx             
        jne seg_desc             
    ; EPILOGO DA FUNCAO; DESALOCAMOS O ESPACO ALOCADO NA PILHA PARA AS VARIAVEIS LOCAIS DA FUNCAO
    mov esp, ebp    
    pop ebp         
    ret 12          

start:
volta_menu:
    ; SALVAR INPUT_HANDLE E OUTPUT_HANDLE EM VARIAVEIS
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov outputHandle, eax
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax

    ; EXIBIMOS O MENU
    invoke WriteConsole, outputHandle, addr menu, sizeof menu, addr write_count, NULL

    ; USUARIO DIGITA A OPCAO DE ESCOLHA DO MENU
    invoke ReadConsole, inputHandle, addr input_opcao, sizeof input_opcao, addr console_count, NULL

    ; REMOVEMOS \n DA OPCAO DE ENTRADA DO USUARIO
    mov esi, offset input_opcao  
    push esi                     
    call RemoveEspaco            
    mov ebx, offset input_opcao  
    invoke atodw, ebx            
    mov opcao_num, eax           

    ; COMPARACAO DE ENTRADA DO USUARIO COM OS VALORES DO MENU
    cmp opcao_num, 1 
    je op_crip
    cmp opcao_num, 2 
    je op_descrip
    cmp opcao_num, 3 
    je op_sair

    ; DIRECIONA PARA AS OPCOES DE CRIPTOGRAFIA, DESCRIPTOGRAFIA E SAIR
    op_crip:
        invoke WriteConsole, outputHandle, addr if_cript, sizeof if_cript, addr write_count, NULL ; texto da opcao 1 - Criptografia
        jmp entrada_dados
    op_descrip:
        invoke WriteConsole, outputHandle, addr if_descript, sizeof if_descript, addr write_count, NULL ; texto da opcao 2 - Descriptografia

    ; AS OPCOES DE CRIPTOGRAFIA E DESCRIPTOGRAFIA PULAM PARA AS INSTRUCOES PARA RECEBER AS ENTRADAS (POIS EH PARTE DE CODIGO COMUM AS DUAS OPCOES)
    entrada_dados:
        ; LEITURA DO NOME DO ARQUIVO DE ENTRADA
        invoke WriteConsole, outputHandle, addr text_entrada, sizeof text_entrada, addr write_count, NULL
        invoke ReadConsole, inputHandle, addr input_arq_ent, sizeof input_arq_ent, addr console_count, NULL
        ; REMOVEMOS \n DA ENTRADA DO USUARIO
        mov esi, offset input_arq_ent       
        push esi                            
        call RemoveEspaco                 
        ; LEITURA DO NOME DO ARQUIVO DE SAIDA
        invoke WriteConsole, outputHandle, addr text_saida, sizeof text_saida, addr write_count, NULL
        invoke ReadConsole, inputHandle, addr input_arq_saida, sizeof input_arq_saida, addr console_count, NULL
        ; REMOVEMOS \n DA ENTRADA DO USUARIO
        mov esi, offset input_arq_saida         
        push esi                                
        call RemoveEspaco                       
        ; LEITURA DA CHAVE
        invoke WriteConsole, outputHandle, addr text_chave, sizeof text_chave, addr write_count, NULL
        invoke ReadConsole, inputHandle, addr input_chave, sizeof input_chave, addr console_count, NULL
        ; REMOVEMOS \n DA ENTRADA DO USUARIO
        mov esi, offset input_chave 
        push esi                    
        call RemoveEspaco           
        mov ebx, offset input_chave 
        invoke atodw, ebx           
        mov int_chave, eax          

        ; COMPARACAO DE ENTRADA DO USUARIO COM OS VALORES DO MENU (SAIMOS DA PARTE EM COMUM DE CODIGO DAS OPCOES DE CRIPTOGRAFIA E DESCRIPTOGRAFIA)
        cmp opcao_num, 1
        je criptografa
        cmp opcao_num, 2
        je descriptografa

    criptografa:
        ; ABERTURA DE UM ARQUIVO JA EXISTENTE (ESTE ARQUIVO SERA LIDO)
        invoke CreateFile, addr input_arq_ent, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
        mov fileHandle_leit, eax
        ; CRIACAO DE ARQUIVO (NESTE ARQUIVO, ESCREVEMOS MENSAGEM CRIPTOGRAFADA)
        invoke CreateFile, addr input_arq_saida, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
        mov fileHandle_escr, eax

        loop_crip:
            ; LEITURA DO ARQUIVO ABERTO
            invoke ReadFile, fileHandle_leit, addr fileBuffer, 512, addr count_bytes, NULL   ; le do arquivo
            ; SE NENHUM BYTE FOI LIDO DO ARQUIVO, CHEGAMOS AO FIM DA CRIPTOGRAFIA
            cmp count_bytes, 0     
            je fim_loop_crip 
            
            mov eax, count_bytes    ; movemos para eax o conteudo de count_bytes (quantidade de bytes lidos do arquivo)
            add count_pos_arq, eax  ; somamos quantidade de bytes lidos do arquivo a count_pos_arq (que eh usado para definir reposicionamento do apontador de arquivo)
            invoke SetFilePointer, fileHandle_leit, count_pos_arq, NULL, FILE_BEGIN

            ; CRIPTOGRAFIA DO TEXTO; PARAMETROS DA FUNCAO SAO PASSADOS PARA A PILHA
            push offset fileBuffer  
            push count_bytes        
            push int_chave   
            call FuncCriptografia   
            
            ; ESCRITA EM ARQUIVO; REPOSICIONAMENTO DO APONTADOR DE ARQUIVO
            invoke WriteFile, fileHandle_escr, addr fileBuffer, count_bytes, addr write_count, NULL
            invoke SetFilePointer, fileHandle_escr, count_pos_arq, NULL, FILE_BEGIN
            
            jmp loop_crip

        fim_loop_crip:
            xor eax, eax                        
            mov count_pos_arq, eax ; contador count_pos_arq eh reiniciado para ser reutilizado; recebe eax (0)
            invoke CloseHandle, fileHandle_leit 
            invoke CloseHandle, fileHandle_escr 
            jmp volta_menu                      

    descriptografa:
        ; ABERTURA DE UM ARQUIVO JA EXISTENTE
        invoke CreateFile, addr input_arq_ent, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
        mov fileHandle_leit, eax
        ; CRIACAO DE ARQUIVO
        invoke CreateFile, addr input_arq_saida, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
        mov fileHandle_escr, eax

        loop_descrip:
            ; LEITURA DO ARQUIVO ABERTO
            invoke ReadFile, fileHandle_leit, addr fileBuffer, 512, addr count_bytes, NULL

            cmp count_bytes, 0      
            je fim_loop_descrip
            
            mov eax, count_bytes    
            add count_pos_arq, eax  
            invoke SetFilePointer, fileHandle_leit, count_pos_arq, NULL, FILE_BEGIN  

            ; CRIPTOGRAFIA DO TEXTO
            push offset fileBuffer  
            push count_bytes        
            push int_chave   
            call FuncDescriptografia
            
            ; ESCRITA EM ARQUIVO
            invoke WriteFile, fileHandle_escr, addr fileBuffer, count_bytes, addr write_count, NULL  
            invoke SetFilePointer, fileHandle_escr, count_pos_arq, NULL, FILE_BEGIN
            
            jmp loop_descrip

        fim_loop_descrip:
            xor eax, eax                        
            mov count_pos_arq, eax              
            invoke CloseHandle, fileHandle_leit 
            invoke CloseHandle, fileHandle_escr 
            jmp volta_menu                      

    op_sair:
        invoke WriteConsole, outputHandle, addr if_sair, sizeof if_sair, addr write_count, NULL

    invoke ExitProcess, 0
end start