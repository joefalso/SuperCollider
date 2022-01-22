# Notas para Nodes en SuperCollider

Cuando creamos un sintetizador, SC lo aloja en un nodo, esto es, en un sector de la memoria. Estos estarán vinculados entre sí a través de una lista. Se pueden crear como cabezas (heads) o colas (tails) o en cualquier otro lugar. Hay que tener en cuenta que los números y el orden de los nodos no están relacionados. El número es la dirección de los nodos.

`  (
Node.addActions.at(\addToHead)
);
// regresa 0 `

` (
Node.addActions.at(\addToTail)
);
// regresa 1 `

Cuando uno no determina los números o el orden de los numeros, SCSynth lo hará por nosotros. Pero es posible tomar control de la situación. Esto no tiene que ver con el orden en que los sintetizadores son enviados al servidor, sino al orden en que estos son creados y empiezan a generar sonido en el servidor.

Los nodos no son creados explicítamente, son una super clase de Synth y Group (por ende estos son subclases).
