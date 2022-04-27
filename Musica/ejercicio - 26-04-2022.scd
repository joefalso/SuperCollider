//*****************************************************************************
//basado en https://www.youtube.com/watch?v=DRswylPuDQU - Eli Fieldsteel
//Week 6: Introduction to Audio Coding with SuperCollider – MUS 499C Fall 2021
//*****************************************************************************

s.boot;
s.plotTree;
s.meter(numIns: 8, numOuts: 8);

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

(
	SynthDef.new(\rev, {
		arg in=0, wetamp=0.3, out=0;
		var sig, wet;
		sig = In.ar(in, 2);    //está leyendo dos canales desde el bus cero, o sea, lee los buses 0 y 1
		wet = FreeVerb2.ar(
			sig[0], sig[1],
			mix: 1.0,
			room: 1.0,
			damp: 0.85,
			mul: wetamp
		);
		sig = sig + wet;
		Out.ar(out, sig);
		}).add;
)

~rev = Synth(\rev, [\in, 6, \out, 0]);

~sin = Synth(\sin, [\out, 6]);

~sin.set(\gate, 0);
~rev.free;

(
~rev = Synth(
	\rev,
	[\in, 6, \out, 0],
	s.defaultGroup,
	\addToHead
);
)

(
~sin = Synth(
	\sin,
	[\out, 6],
	s.defaultGroup,
	\addToHead
);
)


//**no terminado
s.quit;
