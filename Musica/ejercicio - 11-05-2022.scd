// basado en https://www.youtube.com/watch?v=fnMHDYzGkeU - Week 11: Intermediate Coding with SuperCollider – MUS 499C Spring 2021


// JITLib

NodeProxy.help;

s.boot;

s.meter;

n = NodeProxy.new(s, \audio, 2);  //tambien puede usarse el NodeProxy sin argumentos, y n iría modificándose luego
n.play;  // no tiene fuente

n.source = {SinOsc.ar([300, 302]) * 0.1};  // este nodo-fuente puede reemplazarse

n.source = {BPF.ar(PinkNoise.ar(0.5!2), 500, 0.1, 2)}; // por este, sin crear un nuevo nodo


n.source = nil; // este reemplaza el nodo por un nulo

n.clear;  // limpia el nodo proxy (ver el árbol)
n.stop;


n.play;

n.source = {SinOsc.ar([300, 302]) * 0.1};

n.release(5);
n.send

n.end;
n.clear;

n.clear(5);


n.fadeTime; // default = 0.02; este es el tiempo total que le toma realizar cambios entre reemplazo, es decir, el cambio es paulatino y fijado con fadeTime

n.fadeTime_(5); // redefiniendo este parámetro
n.fadeTime;


n.play;

n.source = {SinOsc.ar([300, 302]) * 0.1};

n.source = {BPF.ar(PinkNoise.ar(0.5!2), 500, 0.1, 2)};

n.source = {LFTri.ar([300, 302] * 0.5) * 0.06 * SinOsc.kr(0.5).range(0.2, 0.8)};

n.source = {LFTri.ar([300, 302]) * 0.06 * SinOsc.kr(0.5).range(0.2, 0.8)};

n.source = {LFTri.ar([300, 302] * -2.midiratio) * 0.06 * SinOsc.kr(0.5).range(0.2,0.8)};

n.source = nil;

n.clear(5);


// rythm and quantizing

n.fadeTime_(0.02);

n.play;
n.source = {LFTri.ar([300, 302] * 0.5) * 0.1 * LFPulse.kr(5, 0, 0.25)};
n.source = {LFTri.ar([300, 302] * 0.5) * 0.1 * LFPulse.kr(4, 0, 0.1)};
n.stop;

// LFPulse.kr([frecuencia de pulso], 0, 0.25) - para que haya una sincronización entre nodeproxys se debe controlar el reloj

t = TempoClock.new(84/60).permanent_(true);
t.tempo;
t.beatDur;

n.play;

(
n.source = {
	var sig, f;
	f = t.tempo;  // la frecuencia es (84/60)
	sig = LFTri.ar([300,302] * 5.midiratio);
	sig = sig * 0.1;
	sig = sig * LFPulse.kr(f*2, 0, 0.1)  // f nos permite tener una variable común entre nodeproxys
};
)

n.source = nil;

n.play;

n.clock_(t);
n.quant_(4);

(
n.source = {
	var sig, f;
	f = t.tempo;  // la frecuencia es (84/60)
	sig = LFTri.ar([300,302] * 0.midiratio);
	sig = sig * 0.1;
	sig = sig * LFPulse.kr(f*2, 0, 0.1)  // f nos permite tener una variable común entre nodeproxys
};
)


// con Ndef

n.clear;

Ndef(\n).play;
Ndef(\n).fadeTime_(4);
Ndef(\n).clock_(t);
Ndef(\n).quant_(1);

(
Ndef(\n, {
	var sig;
	sig = PinkNoise.ar(0.5!2);
	sig = BPF.ar(sig, SinOsc.kr(1).exprange(200,400), 0.4);
});
)

(
Ndef(\n, {
	var sig, f;
	f = t.tempo;
	sig = PinkNoise.ar(0.5!2);
	sig = BPF.ar(sig, SinOsc.kr(f/4).exprange(200,400), 0.2);
});
)

(
Ndef(\n, {
	var sig, f;
	f = t.tempo;
	sig = PinkNoise.ar(0.5!2);
	sig = BPF.ar(sig, SinOsc.kr(f/2).exprange(200,400), 0.4);
	sig = sig * LFPulse.kr(f*8, 0, 0.2);
});
)

(
Ndef(\n, {
	var sig, f;
	f = t.tempo;
	sig = PinkNoise.ar(0.5!2);
	sig = BPF.ar(sig, SinOsc.kr(f/2).exprange(200,400), 0.4);
	sig = sig * LFPulse.kr(f*4, [0,0.5], 0.2);
});
)


Ndef(\n).stop(4);
// ó
Ndef(\n).clear(2);
// ó
Ndef(\n, {nil});
// ó
Ndef(\n, {});  // {nil} = {}


// otra forma de definir Ndef
(
Ndef(\n)
.fadeTime_(4)
.clock_(t)
.quant_(1)
.play;
)

// ahora tocar esto:
(
Ndef(\n, {
	var sig, f;
	f = t.tempo;
	sig = PinkNoise.ar(0.5!2);
	sig = BPF.ar(sig, SinOsc.kr(f/4).exprange(200,400), 0.2);
});
)

/////////////
//proxyspace

currentEnvironment;

e = Environment.new;  //un nuevo ambiente
e.push;  // abre el stack en e
currentEnvironment;

~k = 8;
~drink = "fanta";  //alojo cosas en el ambiente
currentEnvironment;  // ver que cosas hay en e
e;  //lo mismo que currentEnvironment
e.pop;  //salir del ambiente e
currentEnvironment; // nada

e.push;
currentEnvironment.keys.do({arg key; currentEnvironment.removeAt(key)});
// -> Set[ k, drink ]   , vació las variables en e (las vuelve a nil)

currentEnvironment;

t = TempoClock.new(84/60).permanent_(true);
(
p = ProxySpace.new(s, clock:t);
p.quant_(4);
p.push;
)

currentEnvironment;

~sig;
currentEnvironment;
p;
/*-> ProxySpace (
~sig - ir(nil)
)
ir : initial rate(vacío), la variable ~sig esta lista par alojar sinths
*/

~sig.play;
~sig = {PinkNoise.ar(0.1!2)};
~sig.clear(3);
~sig = nil;

~sig.fadeTime_(4);
~sig.play;
~sig = {PinkNoise.ar(0.1!2)};  //empieza con fadein = 4 seg
~sig.clear(4);


~sig.clock;
~sig.quant;

p.clear; //limpia los nodos (nodeproxys)



(
SynthDef.new(\filtsaw, {
	var sig, env;
	sig = VarSaw.ar(\freq.kr(100), Rand(0.0, 1.0), 0.001);
	sig = RLPF.ar(sig, \cf.kr(500), \rq.kr(0.5));
	env = Env.perc(\atk.ir(0.002), \rel.ir(0.3)).ar(2);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	Out.ar(\out.ir(0), sig);
}).add;
)

(
x = Pbind(
	\instrument, \filtsaw,
	\dur, 0.2,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1],
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
).play;
)
x.stop;

//para setear en caliente:

~pat.play;

~pat.clock.tempo;
~pat.quant;
~pat.fadeTime_(4);

(
~pat = Pbind(
	\instrument, \filtsaw,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1],
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
);
)

(
~pat = Pbind(
	\instrument, \filtsaw,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1] + 4,
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
);
)

(
~pat = Pbind(
	\instrument, \filtsaw,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1] - 4,
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
);
)

// ver cambios en nodetree

(
~pat = Pbind(
	\instrument, \filtsaw,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1] + 1,
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
);
)

~pat.clear(4);
s.quit;