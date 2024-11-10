# Projeto com Linguagem Assembly

O presente projeto (arquivo `projeto-final.asm`) foi desenvolvido para o Trabalho com Linguagem Assembly solicitado na disciplina de Arquitetura de Computadores. 

O projeto foi implementado utilizando a linguagem Assembly no Windows (MASM 32 bits).

---

A Cifra de César é um dos algoritmos de criptografia mais simples de serem implementados, e também um dos mais simples de serem “quebrados”. O nome do algoritmo é uma homenagem ao imperador romano Júlio César, que utilizava essa técnica para proteger mensagens que continham segredos militares. A técnica original consistia em se trocar cada letra da mensagem original por uma outra letra que fosse listada no alfabeto em um número fixo de posições após a letra substituída.

Neste trabalho, iremos considerar uma variação da Cifra de César onde todos os bytes de um arquivo texto são deslocados para frente (deslocamento positivo) em uma constante que pode ser de 1 a 20 (essa constante será chamada de “chave”). Ou seja, o processo de criptografia consiste em somar o valor da chave a cada um dos bytes de um arquivo, e o processo de decifração consiste em subtrair o valor da chave de cada um dos bytes de um arquivo.

Assim, o programa apresenta um menu de opções para o usuário contendo os seguintes itens: “Criptografar”, “Descriptografar” e “Sair”.

---

### Entradas

As opções “Criptografar” e “Descriptografar” devem solicitar 3 entradas: o nome de um arquivo de entrada, o nome de um arquivo de saída e uma chave (de 1 a 20).

### Saída

“Criptografar” deve produzir como arquivo de saída uma versão do arquivo de entrada em que todos os bytes foram somados com o valor fornecido para a chave. Já a opção “Descriptografar” deve produzir como arquivo de saída uma versão do arquivo de entrada em que o valor da chave foi subtraído de todos os bytes. 

### Sobre o Menu

O menu de opções deve ser reapresentado para o usuário após a execução de “Criptografar” ou “Descriptografar”, até que o usuário selecione a opção “Sair” para encerrar a execução do programa.
