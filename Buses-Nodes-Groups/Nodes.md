# Notas para Nodes en SuperCollider

Cuando creamos un sintetizador, SC lo aloja en un nodo, esto es, en un sector de la memoria. Estos estarán vinculados entre sí a través de una lista. Se pueden crear como cabezas (heads) o colas (tails) o en cualquier otro lugar. Hay que tener en cuenta que los números y el orden de los nodos no están relacionados. El número es la dirección de los nodos.

```supercolider
Node.addActions.at(\addToHead);  // regresa 0
```

```supercollider
Node.addActions.at(\addToTail);  // regresa 1
```

Cuando uno no determina los números o el orden de los numeros, SCSynth lo hará por nosotros. Pero es posible tomar control de la situación. Esto no tiene que ver con el orden en que los sintetizadores son enviados al servidor, sino al orden en que estos son creados y empiezan a generar sonido en el servidor.

Los nodos no son creados explicítamente, son una super clase de Synth y Group (por ende estos son subclases). A continuación, un ejemplo donde se puede verificar la estructura del árbol de nodos:

```supercollider
x = Synth("default");
x.group;
x.nodeID;
```

Se pueden cambiar los valores de los grupos o los nodos, pero al tratar de apagar el sintetizador, este no responderá.

```supercollider
s.boot; 
x = Synth("default");
s.queryAllNodes;  // note the root node (ID 0) and the default group (ID 1)
x.nodeID = 1001;
x.free;
```

Luego de inciar el servidor y un sintetizador por defecto, aloja en un nodo con número 1000, grupo defecto 1 y el nodo raíz 0. Usando el método nodeID, cambiará el nodo por defecto. Luego, si trata de liberar la variable, la terminal indicará que no ha encontrado el nodo. Para liberar la variable, debe retornar x a su nodo verdadero.


