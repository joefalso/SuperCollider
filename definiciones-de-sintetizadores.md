# Notas sobre definición y mánejo básico de Sintetizadores

Este es un borrador para el el manejo básico de sintetizadores en SC.

Para estos ejemplos se usará la clase ```SynthDef```. Los objetos creados de esta forma, son representaciones desde el lado del cliente.

Una forma simple para definir un sintetizador en SC puede ser de la siguiente forma:

```supercollider
(
SynthDef(\sinth, {|out = 0, freq = 440, amp = 0.5|
	var sin;
	sin = SinOsc.ar(freq, 0, amp);
	Out.ar(out,sin);
    }).add;
)
```
Luego de crearlo, se recomienda alojarlo en una variable dinámica.

``` supercollider
~x = Synth.new(\sinth);
```
Esto activará inmediatamente el sintetizador, alojándolo en el siguiente nodo disponible.

``` supercollider
~x = Synth.new(\sinth);
```

Algunos manejos básico de las variables dinámicas.

``` supercollider
~x.run(false);  //pausa (no libera el nodo)
~x.run(true);   //reactiva el sintetizador
~x.free;        //se libera
```