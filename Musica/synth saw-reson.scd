
s.boot;

(
t = TempoClock.new(84/64).permanent_(true);
p = ProxySpace.new(s, clock:t);
p.quant_(4)
//p.push;
)



(
SynthDef.new(\saw1, {
	var sig, env;
	sig = VarSaw.ar(\freq.ir(300));
	sig = Resonz.ar(sig, 500, 1);
	env = EnvGen.kr(
		Env.perc(\atk.ir(0.001), \rel.ir(1), curve:-8.0),
		\gate.kr(1.0),
		doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(1.0));
	Out.ar(0, sig)
}).add;
)


({
~sinte1
	.fadetime(4)
	.quant
	.play(4)
})

(
~sinte1 = Pbind(
	\instrument, \saw1,
	\dur, 0.25,
	\midinote, Pseq([25,25,30,31],inf) + [0.1, 0.2] - 0,
	\pan, Pwhite(-1,1,inf),
	\amp, 1
);
)

~sinte1.free(4);



(
SynthDef.new(\saw2, { | freq=300, atk=0.001, rel=1.0, gate=1, pan=0.0, amp=1.0, out=0 |
	var sig, env;
	sig = VarSaw.ar(freq);
	sig = Resonz.ar(sig, 500, 1);
	env = EnvGen.kr(Env.perc(atk, rel, curve:-8.0), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig)
}).add;
)

({
~sinte2
	.fadetime(4)
	.quant
	.play(4)
})

(
~sinte2 = Pbind(
	\instrument, \saw2,
	\dur, 0.25,
	\midinote, Pseq([25,25,30,31],inf) + [0.1, 0.2] - 0,
	\pan, Pwhite(-1,1,inf),
	\amp, 1
);
)

~sinte2.free(4);

