(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

(
p = Pbind(
	\type, \note,
	\instrument, \sine,
).play;
)

//es lo mismo que:
(
p = Pbind(
	\type, \note,
	\instrument, \sine,
	\dur, 1,
).play;
)

p.play;
p.stop;
s.plotTree;



(
p = Pbind(
	\instrument, \sine,
	\dur, 0.5,
).play;
)


(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pseq([330, 247, 370], inf).trace,
).play;
)


(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], 4).trace,
	\freq, Pseq([330, 247, 370], 2).trace,
).play;
)

//modulaciones midi
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pseq([60, 65, 67, 74].midicps, inf).trace,
).play;
)


(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\midinote, Pseq([60, 65, 67, 74], inf).trace,
).play;
)

(
SynthDef.new(\sine2, {
	arg hz=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(hz);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

(
p = Pbind(
	\instrument, \sine2,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\hz , Pseq([330, 247, 370, 220], inf).trace,
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pexprand(50, 2000, inf).trace,
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf).trace, //inf: lo hace sin termino; cualquier otro valor: lo hace esa cantidad de veces
	\freq, Pexprand(50, 2000, inf).trace,
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 2000, inf).trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf),
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\mininote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf),
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\mininote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.008,
	\pan, Pwhite(-0.8, 0.8, inf),
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\mininote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.008,
	\pan, Pwhite(-0.8, 0.8, inf),
).play;
)

//para tener control en tiempo real se encierra el pbind en un pdef, esto quiere decir, que se puede reevaluar Pdef sin que se duplique
(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([30], inf).trace,
		\harmonic, Pexprand(1, 100, inf).round,
		\atk, Pwhite(0.5, 1.5, inf),
		\rel, Pwhite(1.0, 3.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.05,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play;
)


// ejemplos con samples

(
d = Dictionary.new;
d.add(\cajon -> PathName("C:/Users/diego/OneDrive/Escritorio/SuperCollider/material/samples/percusion/Cajon").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\conga -> PathName("C:/Users/diego/OneDrive/Escritorio/SuperCollider/material/samples/percusion/Conga").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\djembe -> PathName("C:/Users/diego/OneDrive/Escritorio/SuperCollider/material/samples/percusion/Djembe").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
)

(
d = Dictionary.new;
d.add(\test -> PathName("C:/Program Files/SuperCollider-3.12.2/sounds").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath, );
});
);
)

/*
Catarina Campos
hace 6 años
hi! why this is happening all the time?
"Buffer UGen channel mismatch: expected 2, yet buffer has 1 channels"
how can i change the channels, I really thought that I did right xD
can you help me?


Eli Fieldsteel
hace 6 años
Ana Catarina Campos This error means your audio file is a 1-channel file (mono), but you are specifying 2 channels (stereo) in your Buffer UGen. These numbers need to match. I suspect you have a PlayBuf.ar(2, ...) or BufRd.ar(2, ... ) somewhere in your code. Change that 2 to a 1 (optionally change it to a 1!2 if you want to multichannel expand the UGen into dual mono). Or, use a stereo audio file instead of a mono file.
*/

d[\test].choose.play;
d[\conga].choose.play;
d[\djembe].choose.play;

(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar([0,1], sig);
}).add;
)

(
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1, pan=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar([0,1], sig);
}).add;
)

Synth.new(\bufplay, [\buf, d[\cajon].choose.bufnum]);
Synth.new(\bufplay, [\buf, d[\conga].choose.bufnum]);
Synth.new(\bufplay, [\buf, d[\djembe].choose.bufnum]);

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([0.12], inf),
		\buf, Prand(d[\cajon]++d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, 0.5,
	);
).play;
)

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([0.42], inf),
		\buf, Prand(d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, 0.5,
	);
).play;
)

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([0.72], inf),
		\buf, d[\test],
		\rate, 1,
		\amp, 0.5,
	);
).play;
)

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Prand(d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, 0.5,
	);
).play;
)

//Pxrand no tomará 2 veces el mismo valor
(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Prand(d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, 0.5,
	);
).play;
)

//Pwrand alternará los samples según los pesos que se indiquen
(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Pwrand([d[\conga][0], d[\djembe][0]],[0.8, 0.2], inf), // \conga tiene 80% y \djembe 20%
		\rate, 1,
		\amp, 0.5,
	);
).play;
)

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Prand(d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, Pseq([0.8, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1], inf),
	);
).play;
)

//es lo mismo que abajo
(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Prand(d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, Pseq([0.8]++([0.1]!7), inf),
	);
).play;
)

// PATRONES ANIDADOS.

//el siguiente tiene una secuencia de 8 valores en amplitud y 7 aleatorios entre 0.005 y 0.2. sentir la diferencia con los demas ejemplos
(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Prand(d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).play;
)

// el siguiente anidamiento da problemas con los canales, los del cajón parecen ser monofónicos

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Pseq(
			[
				Prand(d[\conga], 2),
				Prand(d[\djembe]++d[\cajon], 7),
				Prand(d[\djembe], 2),
				Prand(d[\conga]++d[\djembe], 7),
			], inf,
		),
		\rate, 1,
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).play;
)

// pattrones con cuantización

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Pseq(
			[
				Prand(d[\conga], 2),
				Prand(d[\djembe]++d[\cajon], 7),
				Prand(d[\djembe], 2),
				Prand(d[\conga]++d[\djembe], 7),
			], inf,
		),
		\rate, Pexprand(0.8, 1.25, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).play(quant: 1.875);
)

// si se quiere realizar un cambio mientras está activo
// (los cambios se activan al siguiente compás)

(
Pdef(
	\ritmo,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,  //60/128 * 4
		\buf, Pseq(
			[
				Prand(d[\conga], 2),
				Prand(d[\djembe]++d[\cajon], 7),
				Prand(d[\djembe], 2),
				Prand(d[\conga]++d[\djembe], 7),
			], inf,
		),
		\rate, Pexprand(1, 1.75, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).quant_(1.875);
)

(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\note, Pxrand([0,3,5,9,10,12], inf),
		\atk, 0.005,
		\rel, Pexprand(0.01, 0.5, inf),
		\amp, Pexprand(0.05, 0.5, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play(quant: 1.875);
)


(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\note, Pxrand([0,3,5,9,10,12], inf),
		\atk, 0.005,
		\rel, Pexprand(0.01, 0.5, inf),
		\amp, Pexprand(0.05, 0.5, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).quant_(1.875);
)




Pdef(\ritmo).stop;
Pdef(\sinepat).stop;



p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);

// now play it
(
x = SynthDef(\help_Buffer, { arg out = 0, bufnum;
	Out.ar( [out,1],
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
    )
}).play(s,[\bufnum, b]);
)
x.free; b.free;