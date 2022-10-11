s.boot;

t = TempoClock.new(60/60,4).permanent_(true);

(
p = ProxySpace.new(s, clock:t);
{p
	.fadeTime(4)
	.quant
	.push
})

(SynthDef.new(\noise, {
	var env, sin, noise, sig;
	env = EnvGen.kr(Env.perc(\atk.ir(0.001), \rel.ir(1.0), curve:-10), \gate.ir(1.0), doneAction: Done.freeSelf);
	sin = SinOsc.ar(\freq.kr(300));
	noise = LFNoise2.ar(\fqnoise.kr(0.3));
	sig = env * sin * noise;
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;
)

p.fadeTime_(4);
({
~nois
	.fadeTime_(10)
	.quant
	.play(10)
};
)

(
~nois = Pbind(
	\instrument, \noise,
	\dur, 0.15,
	\midinote, Pseq([20,20,30,20],inf) + [0,0.01] + 40,
	\fqnoise, Prand([0.1,0.3,0.5], inf),
	\pan, Pwhite(-1,1,inf),
	\amp, 0.3,
)
)

(
~nois = Pbind(
	\instrument, \noise,
	\dur, Pseq([
		Prand([1/2,1/3],1),
		Prand([1/4,1/5],1),
		Prand([1/16,1/17],1),
	],inf),
	\midinote, Pseq(
			[
			Prand([20,20], 3),
			Prand([28,28], 2),
			Prand([29,32], 4),
			Prand([32,34], 2),
			], inf,
		) + [0,0.1] + 60,
	\fqnoise, Prand([100,150,100], inf),
	\pan, Pwhite(-1,1,inf),
	\amp, 0.3,
)
)
