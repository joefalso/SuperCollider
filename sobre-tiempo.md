# Notas sobre tiempo en SC 

En SuperCollider extiste una super clase llamada Clock, con tre subclases: AppClock, SystemClock, TempoClock.

## TempoClock

Con las siguientes líneas podemos obtener información valiosa para ser usada.

```SuperCollider
t = TempoClock.new;  //inicia un reloj lógico con un tempo de 60 BPM por defecto
t.isRunning;  //retorna un valor booleano con el estado del reloj
t.beats;  //regresa el valor flotante del beat actual, desde que se inicia el reloj
t.bar;  //regresa el compás actual
t.beatDur;  //regresa la duración de los beats en segundos 
t.timeToNextBeat;  //regresa el valor, en segundos, de cuanto falta para el próximo beat
t.beats.floor;  //regresa el valor del beat actual, aproximado a la unidad
t.beats.ceil;  //regresa el valor del próximo beat, aproximado a la unidad
```

Usando el método __.asInteger__ se puede convertir los valores regresados, desde flotantes a enteros, de ser necesario.
