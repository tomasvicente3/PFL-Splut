# Splut!

## Trabalho por:
Grupo 'Splut_6':
- Adriano Alexandre dos Santos Machado (up202105352)
- Tomás Alexandre Soeiro Vicente (up202108717)

## Instalação and Execução

Para proceder à instalação do Splut!, basta descomprimir a pasta compactada fornecida para um diretório de escolha. De seguida deve consultar o ficheiro "main.pl" e invocar o predicado play/0.

```prolog=
? - consult('main.pl').
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

O *StoneTroll* é uma peça com duas habilidades distintas: puxar e atirar uma rocha.

####    Puxar

Se exitir uma pedra adjacente no sentido oposto ao movimento o *StoneTroll* pode escolher movimentá-la consigo.

<img src="doc/Troll_Pull.png" height="290">


####    Atirar

O StoneTroll tem a capacidade de deslocar-se para uma casa já ocupada por uma pedra e lançar a pedra numa determinada direção.

Essa ação termina imediatamente o turno do jogador. A pedra só é parada pela borda do tabuleiro, por uma pedra ou um *StoneTroll*. Se a pedra colidir com um *Sorcerer*, o jogador que possuía essa peça perde o jogo.

<img alt="Troll Pull Example" src="doc/Troll_Throw.png" height=270>


### Sorcerer

Quando o Sorcerer se move, pode escolher levitar uma pedra qualquer na mesma direção que executa o seu movimento, desde que:

* A pedra escolhida não tenha sido movida no turno anterior por qualquer jogador.
* A casa para onde a pedra escolhida se vá mover esteja livre.
* O *Sorcerer* não deixou de levitar a pedra continuamente, ou seja, no mesmo turno não pode levitar, não levitar e querer voltar a levitar a pedra.

<img alt="Continuous levitation example" src="doc/Sorcerer_Levitate.png" height=300>

