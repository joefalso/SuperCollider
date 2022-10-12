(
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;

//asignar más memoria virtual
s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;

// clock
t = TempoClock(84/60, 0);

t.schedAbs(t.nextBar, {t.beatsPerBar_(4)});
//t.schedAbs(t.beats.ceil, { ~beat = ~beat + 1; ~beat.postln; 1 });
//t.schedAbs(t.beatInBar.ceil, { arg beat, sec; [beat, sec].postln; 1 });

p = ProxySpace.new(s, clock: t);
p.push;

//p.fadeTime_(2.5);
//p.quant_(2.5);

s.freeAll;
)



(
SynthDef(\res, {
	var sig, env;
	env = EnvGen.kr(Env.perc(\atk.kr(0.0), \rel.kr(0.7), 1, \curve.kr(-4.0)), 1.0, doneAction: Done.freeSelf);
	sig = Mix([Saw.ar(\freq.kr(100)), Pulse.ar(\freqpulse.kr(1) / 2, 0.5)]);
	sig = RLPF.ar(sig, LFNoise1.kr(0.75, 200, 1500), \rq.kr(0.1), env);
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)

({
~res
	.quant
	.play
};
)

(t.schedAbs(t.nextBar,
	{
		~res = Pbind(
			\instrument, \res,
			\scale, Scale.minor,
			\degree, Prand([Pseq([2,-2], 16), Pseq([0,-2], 16), Pseq([-2,0], 16)], inf),
			\atk, 0.2,
			\rel, 0.25,
			\curve, -8.0,
			\freqpulse, 1.25,
			\rq, 0.25,
			\octave, Pseq([4, 5], inf) - 1,
			\dur, 1/4,
			\pan, Pwhite([-0.05,0.05], inf),
			\amp, 0.035
	);
	}
);
)

~res.clear(3);
Server.killAll;