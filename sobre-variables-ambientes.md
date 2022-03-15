# Notas sobre uso de constantes y tipos de variables

_Se usará el método recomendado en el GitHub oficial de SuperCollider para el uso de variables_

Un uso típico para las variables es para el alojamiento de sintetizadores. Para después poder usar diferentes métodos sobre estos. También sirve para reasignar valores a los ya determinados en la definición del sintetizador.

## Ejemplo 1

```supercollider
s.boot;
(
SynthDef(\sinte1, { |freq = 220, phase = 0, amp 0.5, busOut = 0|
	var sig;
	sig = SinOsc.ar(freq, phase, amp);
	Out.ar(busOut, sig);	
}).add;
)

~x = Synth.new(\sinte1).run(false);  //la variable de ambiente ~x actuando como variable globar, el sintetizador es alojado en un nodo, pero no corre debido a que esta 						 
~x.run.(true);  //
~x.run(false);
~sinth1 
```