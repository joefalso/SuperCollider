# Notas para Buses en SuperCollider

Por defecto, en SC hay 1024 buses para señales de audio y 16384 para señales de control. Las siguientes líneas sirven para consultar estos datos.


```supercollider
s.options.numAudioBusChannels;
s.options.numControlBusChannels;
```

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

