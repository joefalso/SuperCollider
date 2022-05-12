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


