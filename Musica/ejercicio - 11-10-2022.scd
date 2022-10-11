(
t = TempoClock(84/60, 0);

t.schedAbs(t.nextBar, {t.beatsPerBar_(4)});
t.schedAbs(t.beatInBar.ceil, { arg beat, sec; [beat, sec].postln; 1 });

p = ProxySpace.new(s, clock: t);
p.push;

)


t.beatsPerBar;

t.beatInBar;
t.bar;


(
SynthDef.new(\bass, {
	| gate=1, curve= -8.0 |
	var sig, env;
	sig = SinOsc.ar(\freq.kr(100));
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;

SynthDef.new(\drum, {
	| gate=1, curve= -8.0, mul=1 |
	var sig, env;
	sig = WhiteNoise.ar(mul);
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;

(
SynthDef.new(\coin, {
	arg prob=0.1;
    var trig;
	trig = Impulse.ar(\freqimp.kr(9.0), 0, SinOsc.kr(0.01, 0, 1, 1));
	trig = EnvGen.ar(Env.perc(0.01, 1.0, 1.0, -8.0), doneAction: Done.freeSelf) * trig;
	trig = Mix.fill(7.0, {Ringz.ar(CoinGate.ar(prob, trig), #[0.5, 0.75] * Rand(3000, 9000), 0.05)});
	trig = NHHall.ar(trig, rt60: 0.45, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
    Out.ar(0, trig * 0.75)
}).add;
)
)

({
~bass
	.quant
	.play
};
{
~drum
	.quant
	.play
};
{
~wood
	.quant
	.play
};
)

t;

t.schedAbs(t.beatInBar.ceil, { arg beat, sec; [beat, sec].postln; 1 });
t.schedAbs(t.beatInBar.ceil, { .postln});
t.beatInBar.ceil;

(
t.schedAbs(t.nextBar,
	{
	~bass = Pbind(
		\instrument, \bass,
		\scale, Scale.minor,
		\degree, Pseq([0,4,6,\], inf),
		\octave, [4],
		\dur, Pseq([1], inf),
		\pan, Pwhite(-1,1, inf),
		\amp, 0.7
	);
	}
)
);

(
t.schedAbs(t.nextBar,
	{
	~drum = Pbind(
		\instrument, \drum,
		\scale, Scale.minor,
		\degree, Pseq([1], inf),
		\octave, [1],
		\dur, Pseq([1], inf),
		\pan, Pwhite(-1,1, inf),
		\amp, 0.075
	);
	}
)
);

(
t.schedAbs(t.nextBar,
	{
	~wood = Pbind(
		\instrument, \coin,
		\dur, Pseq([2], inf),
		\scale, Scale.minor,
		\degree, Pseq([12, 16, 24], inf),
		\octave, [5],
		\pan, Pwhite(-1,1, inf),
		\amp, 1.4
	).trace;
	}
);
)
