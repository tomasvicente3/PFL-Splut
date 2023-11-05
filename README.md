# Splut!

Grupo 'Splut_6':
- Adriano Alexandre dos Santos Machado (up202105352)
- Tomás Alexandre Soeiro Vicente (up202108717)

## Instalação and Execução

Para proceder à execução do Splut!, basta descomprimir a pasta compactada fornecida para um diretório de escolha. De seguida deve iniciar o SICStus Prolog 4.8 (caso não o tenha instalado siga as instruções neste [link](https://sicstus.sics.se/download4.html)). Uma vez iniciado deve consultar o ficheiro "main.pl" e invocar o predicado play/0.


```prolog=
? - consult('src/main.pl').
? - play.
```

## Descrição do Jogo

O jogo Splut! é um jogo de tabuleiro para dois a quatro jogadores. O objetivo do jogo é eliminar os *Sorcerers* adversários através do lançamento de pedras.

Em cada turno, o jogador pode mover as suas peças três vezes, com exceção do primeiro turno, no qual apenas é permitido um movimento, e do segundo turno, onde são permitidos dois movimentos.

No início, existem quatro pedras no tabuleiro, uma em cada canto, e cada jogador possui três peças (*Sorcerer*, *StoneTroll* e *Dwarf*).

Cada uma das três peças possui a capacidade de se deslocar para uma casa desocupada. Além disso, cada uma apresenta um conjunto de movimentos especiais.

### Dwarf

O *Dwarf* possui a capacidade de mover-se para uma casa já ocupada, desde que seja possível deslocar as peças adjacentes na direção desejada. Para isso, é necessário que exista uma casa vazia disponível no final do movimento para receber a peça deslocada.

<img src="doc/Dwarf_Push.png" height="260">

### StoneTroll

O *StoneTroll* é uma peça com duas habilidades distintas: arrastar e atirar uma rocha.

####    Arrastar

Se exitir uma pedra adjacente no sentido oposto ao movimento, o *StoneTroll* pode escolher movimentá-la consigo.

<img src="doc/Troll_Pull.png" height="260">


####    Atirar

O StoneTroll tem a capacidade de deslocar-se para uma casa já ocupada por uma pedra e lançar a pedra numa determinada direção.

Essa ação termina imediatamente o turno do jogador. A pedra só é parada pela borda do tabuleiro, por uma pedra ou por um *StoneTroll*. Se a pedra colidir com um *Sorcerer*, o jogador que possuía essa peça perde o jogo.

<img src="doc/Troll_Throw.png" height="260">


### Sorcerer

Quando o Sorcerer se move, pode escolher levitar uma pedra qualquer na mesma direção que executa o seu movimento, desde que:

* A pedra escolhida não tenha sido movida no turno anterior por qualquer jogador.
* A casa para onde a pedra escolhida se vá mover esteja livre.
* O *Sorcerer* não deixou de levitar a pedra continuamente, ou seja, no mesmo turno não pode levitar, não levitar e querer voltar a levitar a pedra.

<img src="doc/Sorcerer_Levitate.png" height="260">

###    Fontes
As regras e o funcionamento do jogo foram consultadas nas páginas [IgGameCenter](https://www.iggamecenter.com/en/rules/splut) e [BoardGameGeek](https://boardgamegeek.com/boardgame/64735/splut/images).

## Lógica do Jogo

### Representação interna do estado de jogo

O estado de jogo, *GameState* é representado por uma lista de três elementos:

* **Board** - Matriz quadrada que representa o tabuleiro. Esta matriz é composta por diferentes elementos que simbolizam as peças do jogo. As peças pertencentes ao jogador um são representadas por letras maiúsculas, enquanto as peças do jogador dois são representadas por letras minúsculas. A letra "R" representa uma rocha, "T" ou "t" representam um StoneTroll, "D" ou "d" representam um Dwarf, e "S" ou "s" representam um Sorcerer. Além disso, devido ao formato de losango do nosso tabuleiro, os números -1 e -2 são usados para representar os limites do mesmo, sendo ambos tratados da mesma forma na lógica do jogo. O número -2 é particularmente útil na exibição do tabuleiro.

* **Turn** - Turno atual do jogo, é incrementado sempre que ocorre a mudança de jogador.

* **Steps** - Indica o número de jogadas restantes disponíveis para o jogador.

#### Exemplos de representação do GameState:

*   Estado Inicial

No início do jogo, as quatro pedras encontram-se dispostas nas extremidades do tabuleiro e as peças dos jogadores estão situadas em lados opostos. O jogo tem início com o primeiro turno, onde o primeiro jogador tem disponível um único movimento.


```prolog=
[[-1,   -1,   -1,   'R',    -2,   -1,    -1],
 [-1,   -1,   't',  'd',   's',   -2,    -1],
 [-1,    0,    0,    0,      0,    0,    -2],
 ['R',   0,    0,    0,      0,    0,   'R'],
 [-1,    0,    0,    0,      0,    0,    -2],
 [-1,   -1,   'S',  'D',   'T',   -2,    -1],
 [-1,   -1,   -1,   'R',    -2,   -1,    -1], 1, 1]
```

*   Estado Intermédio

```prolog=
[[-1,   -1,   -1,  'R',  -2,   -1,   -1],
 [-1,   -1,    0,  't',   0,   -2,   -1],
 [-1,    0,    0,   0,   's',   0,   -2],
 ['R',   0,   'd', 'S',   0,    0,   'R'],
 [-1,    0,    0,  'T',   0,    0,   -2],
 [-1,   -1,    0,  'D',   0,   -2,   -1],
 [-1,   -1,   -1,  'R',  -2,   -1,   -1], 12, 3]
```

*   Estado Final

No Splut! não é possível a ocorrência de empates pelo que o estado final só é atingido quando uma das pedras atinge o "Sorcerer" do jogador adversário. No seguinte exemplo o jogador dois foi o vencedor.


```prolog=
[[-1,   -1,   -1,  't',  -2,   -1,   -1],
 [-1,   -1,    0,   0,   0,   -2,   -1],
 [-1,    0,    0,   0,   's',   0,   -2],
 ['R',   0,   'd', 'R',   0,    0,   'R'],
 [-1,    0,    0,  'T',   0,    0,   -2],
 [-1,   -1,    0,  'D',   0,   -2,   -1],
 [-1,   -1,   -1,  'R',  -2,   -1,   -1], 13, 3]
```
