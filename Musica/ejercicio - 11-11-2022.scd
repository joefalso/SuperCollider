(
SynthDef.new(\bass1, {
	| gate=1, curve= -8.0 |
	var sig, env;
	sig = SinOsc.ar(\freq.kr(100));
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;

SynthDef.new(\drum1, {
	| gate=1, curve= -8.0, mul=1 |
	var sig, env;
	sig = WhiteNoise.ar(mul);
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;

SynthDef.new(\coin, {
	arg prob=0.1;
    var trig;
	trig = Impulse.ar(\freqimp.kr(9.0), 0, SinOsc.kr(0.01, 0, 1, 1));
	trig = EnvGen.ar(Env.perc(0.01, 1.0, 1.0, -8.0), doneAction: Done.freeSelf) * trig;
	trig = Mix.fill(7.0, {Ringz.ar(CoinGate.ar(prob, trig), #[0.5, 0.75] * Rand(3000, 9000), 0.05)});
	trig = NHHall.ar(trig, rt60: 0.45, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
    Out.ar(0, trig * 0.75)
}).add;

SynthDef.new(\res, {
	var sig, env;
	env = EnvGen.kr(Env.perc(\atk.kr(0.0), \rel.kr(0.7), 1, \curve.kr(-4.0)), 1.0, doneAction: Done.freeSelf);
	sig = Mix([Saw.ar(\freq.kr(100)), Pulse.ar(\freqpulse.kr(1) / 2, 0.5)]);
	sig = RLPF.ar(sig, LFNoise1.kr(0.75, 200, 1500), \rq.kr(0.1), env);
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;


SynthDef.new(\blitsq, {
	var sig, env;
	env = EnvGen.kr(Env.linen(1, 2, 3, 0.6), doneAction: Done.freeSelf);
	sig = Mix.fill(30, {LFNoise1.kr(rrand(2,3)).range(0,36)+36.midicps});
	sig = BlitB3Square.ar(sig, 0.5.rand2);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)


(t.schedAbs(t.nextBar,
	{
		~sinte1 = Pbind(
			\instrument, \blitsq,
			\dur, Pseq([1], 10),
			\amp, 0.005
	);
	}
))