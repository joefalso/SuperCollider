s.boot;
s.plotTree;

(
SynthDef.new(\sin, {
	arg out=0, gate=1;
	var freq, sig, tenv, env;
	freq = LFDNoise0.kr(16!2).exprange(150,4000);
	sig = SinOsc.ar(freq);
	tenv = EnvGen.ar(Env.perc(0.001, 0.06), Dust.kr(6!2));
	env = EnvGen.kr(Env.asr(5, 1, 5), gate, doneAction:2);
	sig = sig * tenv * env * 0.1;
	Out.ar(out, sig);
}).add;

SynthDef.new(\pn, {
	arg out=0, gate=1;
	var sig, env, mod;
	sig = PinkNoise.ar(1!2);
	mod = LFPulse.kr(0.6, 0, 0.02);
	sig = sig * mod;
	env = EnvGen.kr(Env.asr(0, 1, 5), gate, doneAction:2);
	sig = sig * env * 0.4;
	Out.ar(out, sig);
}).add;
)

~sin = Synth(\sin);
~sin.set(\gate, 0);

~pn = Synth(\pn);
~pn.set(\gate, 0);

