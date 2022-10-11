
s.boot;

t = TempoClock.new(84/60).permanent_(true);

(
p = ProxySpace.new(s, clock:t);
p.fadeTime_(4);
p.quant;
p.push;
)

(
SynthDef.new(\sd, {
	var osc1, osc2, env, sig;
	osc1 = WhiteNoise.ar;
	osc2 = FSinOsc.ar(\freq.kr(200));
	env = EnvGen.kr(Env.perc(\atk.ir(0), \rel.ir(0.05)), doneAction: 2);
	sig = Pan2.ar(LPF.ar(Mix([osc1, osc2]), 12000), \pan.ir(0.0), env * \amp.ir(0.2));
	Out.ar(0, sig)
}).add;
)

({
~sintesd
	.fadeTime_(4)
	.quant
	.play(4)
})

(
~sintesd = Pbind(
	\instrument, \sd,
	\dur, Pseq([
		Prand([1/4,1/16],1)
	],inf),
	\midinote, Pseq([
		Prand([25,28],2),
		Prand([25,30],2),
		Prand([25,32],2),
	],inf),
	\pan, Pwhite(-0.5,0.5,inf),
	\amp, 0.2,
);
)

(
~sintesd = Pbind(
	\instrument, \sd,
	[\freq, \dur], Pseq([
		Pseq([[\, 1], [1, 1]], 6),
		Pseq([[\, 1], [1, 1], [\, 1], [1, 0.5], [1, 0.25], [1, 0.25]], 2)
	],inf),
	\pan, Pwhite(-1,1,inf),
	\amp, 0.5,
);
)


(
SynthDef.new(\saw, {
	var sig, env;
	sig = VarSaw.ar(\freq.kr(300));
	env = EnvGen.kr(Env.perc(\atk.ir(0.002), \rel.ir(0.3)), \gate.ir(1), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.3));
	Out.ar(0, sig)
}).add;
)

({
~sinte1
	.fadeTime_(3)
	.quant
	.play(2)
};
)

(
~sinte1 = Pbind(
	\instrument, \saw,
	\dur, 1/4,
	\midinote, Pseq([28,28,40,28,40], inf) + [0,0.2] + 3,
	\pan, Pwhite(-0.3,0.3,inf),
	\amp, 1
);
)

(
~sinte1 = Pbind(
	\instrument, \saw,
	\dur, 1/4,
	\midinote, Pseq([
		Pseq([28,28,40,28,38],4),
		Pseq([25,28],1),
		Prand([25,30],1),
	], inf) + [0,0.1] + 0,
	\pan, Pwhite(-0.3,0.3,inf),
	\amp, 1.5
);
)


~sinte1.free(3);
~sintesd.free(3);
s.quit;
