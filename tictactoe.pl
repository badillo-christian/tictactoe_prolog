/*pinta una casilla, el guion bajo es vacio*/
pinta_casilla(N) :- o(N), write(' o ').
pinta_casilla(N) :- x(N), write(' x ').
pinta_casilla(N) :- casilla_libre(N), write(' _ ').

/*Pinta el tablero*/
pinta_tablero :-    pinta_casilla(1), pinta_casilla(2), pinta_casilla(3), nl,
                    pinta_casilla(4), pinta_casilla(5), pinta_casilla(6), nl,
                    pinta_casilla(7), pinta_casilla(8), pinta_casilla(9), nl.

/*Limpia el tablero*/
limpiar_tablero :- retractall(x(_)), retractall(o(_)).                    

/*condiciones de victoria*/
condicion_victoria(1, 2, 3). 
condicion_victoria(4, 5, 6). 
condicion_victoria(7, 8, 9).
condicion_victoria(1, 4, 7). 
condicion_victoria(2, 5, 8). 
condicion_victoria(3, 6, 9).
condicion_victoria(1, 5, 9). 
condicion_victoria(3, 5, 7).

/*Linea actual contra las permutaciones de las condiciones de victoria*/
linea_actual(A, B, C) :- condicion_victoria(A, B, C). 
linea_actual(A, B, C) :- condicion_victoria(A, C, B).
linea_actual(A, B, C) :- condicion_victoria(B, A, C). 
linea_actual(A, B, C) :- condicion_victoria(B, C, A).
linea_actual(A, B, C) :- condicion_victoria(C, A, B). 
linea_actual(A, B, C) :- condicion_victoria(C, B, A).

/*Metodos para establecer la casilla*/
establece_casilla(A) :- x(A). 
establece_casilla(A) :- o(A). 
casilla_libre(A) :- \+(establece_casilla(A)).

jugada(C) :- regla1(C).
jugada(A) :-    valida(A), casilla_libre(A), !. 
                valida(1). valida(3). valida(7). valida(9). valida(5). 
                valida(2). valida(4). valida(6). valida(8).

/*tablero lleno*/                
tablero_lleno :-    establece_casilla(1), establece_casilla(2), establece_casilla(3), 
                    establece_casilla(4), establece_casilla(5), establece_casilla(6), 
                    establece_casilla(7), establece_casilla(8), establece_casilla(9).

/*
    Heuristica del juego
    1. Se busca bloquear una linea ganadora si ya se tienen dos casillas consecutivas.
    2. Si ya tenemos dos casillas consecutivas, se tomara la que falta si se encuentra libre.
    3. Si esta libre la casilla 5, se intentara tomar.
    4. Si las casillas de la esquina estan libres (1, 3, 7 o 9) se trataran de tomar.
*/
regla1(C) :- linea_actual(A,B,C), o(A), o(B), casilla_libre(C), !.
regla1(C) :- linea_actual(A,B,C), x(A), x(B), casilla_libre(C), !.
regla1(5) :- casilla_libre(5).
regla1(C) :- o(A), A \= 2, A \= 4, A \= 6, A \= 8, regla2(C).
regla2(C) :- casilla_libre(C), C \= 1, C \= 3, C \= 7, C \= 9. 

/*Si tiro la computadora y logro condicion de victuria, ella gana y fin*/
fin :- condicion_victoria(A, B, C), x(A), x(B), x(C), write('Yo gano.'), nl.

/*Si se lleno el tablero y no hay condicion de victoria es un empate*/
fin :- tablero_lleno, write('Empate.'), nl.

/*solicita movimiento del jugador*/
obtener_movimiento_jugador :- repeat, write('Tu turno, eres los circulos  : '), read(X), casilla_libre(X), assert(o(X)).

/*hace jugada de la computadora X*/
jugada_computadora :- jugada(X), !, assert(x(X)).
jugada_computadora :- tablero_lleno.

/*
Main

1. Se inicializa el juego con la funcion jugar.
2. Se limpia el tablero
3. Se obtiene el movimiento del jugador
4. Se realiza la jugada del jugador
5. Se valida si la jugada cumple con alguna de las condiciones de victoria, de ser así, se muestra Ganaste y fin,
en caso contrario la computadora juega su turno,

*/
jugar :- limpiar_tablero, repeat, obtener_movimiento_jugador, jugada_jugador.
jugada_jugador :- condicion_victoria(A, B, C), o(A), o(B), o(C), pinta_tablero, write('Ganaste'), nl. 
jugada_jugador :- jugada_computadora, pinta_tablero, fin.