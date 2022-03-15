# Notas para Buses en SuperCollider

Por defecto, en SC hay 1024 buses para señales de audio y 16384 para señales de control. Las siguientes líneas sirven para consultar estos datos.

```supercollider
s.boot;
s.options.numAudioBusChannels;
s.options.numControlBusChannels;
```

El número de buses de control, audio, entradas y salidas no puede cambiarse una vez inicializado el servidor.

El siguiente ejemplo muestra como se puede colocar audio en un bus.

```supercollider
(
SynthDef(\sinth, {|out = 0, freq = 440, amp = 0.5|
	var sin;
	sin = SinOsc.ar(freq, 0, amp);
	Out.ar(out,sin);
    }).add;
)
```

