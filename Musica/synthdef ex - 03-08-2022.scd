

s.boot;

t = TempoClock.new(84/60).permanent_(true);
(
p = ProxySpace.new(s, clock:t);
p.quant_(4);
p.push;
)

Env.perc(0.05, 1, 1, -4).test.plot;
Env.perc(0.001, 1, 1, -4).test.plot;    // sharper attack
Env.perc(0.001, 1, 1, -8).test.plot;    // change curvature
Env.perc(1, 0.01, 1, 4).test.plot;    // reverse envelope

Env.pairs([[0, 1], [2.1, 0.5],  [3, 1.4]], \exp).plot;
Env.pairs([[0, 1], [3, 1.4], [2.1, 0.5], [3, 4]], \exp).plot; // *if possible*, pairs are sorted according to time
Env.pairs({ { 1.0.rand } ! 2 } ! 16, \exp).plot;

(
SynthDef.new(\saw, { |gate=1|
	var sig, env;
	sig = VarSaw.ar(\freq.kr(300));
	env = Env.perc(\atk.ir(0.002), \rel.ir(0.3)).ar(2);
	sig = sig * env;
	sig = Pan2.ar(
		sig,
		\pan.kr(0),
		\amp.kr(0.3));
	Out.ar(\out.ir(0), sig)
}).add;
//Env.perc(\atk.ir(0.002), \rel.ir(0.3)).ar(2)

SynthDef.new(\saw2, { |gate=1.0|
	var sig, env;
	sig = VarSaw.ar(\freq.kr(300));
	env = EnvGen.kr(
		Env.perc(0.001, 1, 1, -8),
		gate,
		doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(
		sig,
		\pan.kr(0),
		\amp.kr(0.3));
	Out.ar(\out.ir(0), sig)
}).add;
)

~sinte1.fadeTime_(6);
~sinte1.quant;
~sinte1.play(2);

(
~sinte1 = Pbind(
	\instrument, \saw,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1] - 0,
	\pan, Pwhite(-0.3,0.3,inf),
	\amp, 0.3
);
)

~sinte2.fadeTime_(6);
~sinte2.quant;
~sinte2.play(2);

(
~sinte2 = Pbind(
	\instrument, \saw2,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.1] - 2,
	\pan, Prand([-0.7,-0.5,-0.3,0,0.3,0.5,0.7], inf),
	\amp, 0.3
);
)

~sinte1.free(3)
~sinte1.stop;

~sinte2.free(3)
~sinte2.stop;
