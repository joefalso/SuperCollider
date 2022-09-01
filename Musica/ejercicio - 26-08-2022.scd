(
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;

//asaignar más memoria virtual
s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;

p = ProxySpace.push(s);
p.makeTempoClock;
p.clock.tempo_(96/60);
p.fadeTime_(2.5);
p.quant_(2.5);

s.freeAll;
)

s.boot;

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
	var sig, env, rlpf;
	sig = BrownNoise.ar(mul);
	sig = RHPF.ar(sig, \freq.kr(100), \rq.kr(1.0));
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;

SynthDef.new(\mel, {
	| gate=1, curve= -8.0, mul=1 |
	var sig, env;
	sig = VarSaw.ar(\freq.kr(100));
	env = EnvGen.kr(Env([0,1,0], [1,1]), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;
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
~mel
	.quant
	.play
}
);

(
~bass = Pbind(
	\instrument, \bass,
	\scale, Scale.minor,
	\degree, Pseq([0,4,6,\], inf),
	\octave, [4],
	\dur, Pseq([1/4], inf),
	\pan, Pwhite(-1,1, inf),
	\amp, 0.2,
);
)

(
~bass = Pbind(
	\instrument, \bass,
	\scale, Scale.minor,
	\degree, Pseq([
		Prand([0,3,5,7],2),
		Prand([2,4,6,\],1)
	], inf) + [0.0,0.02] + 0,
	\octave, [3],
	\dur, Prand([
		Pseq([1/4],2),
		Pseq([1/2],1)
	],inf),
	\pan, Pwhite(-1,1,inf),
	\amp, 0.5,
	\mix, 0.5,
	\room, 0.5,
	\damp, 0.5
);
)

(
~drum = Pbind(
	\instrument, \drum,
	\mul, Pseq([1], inf),
	\dur, Prand([
		Pseq([3/4,1/4], 1),
		Pseq([1/2,1/2], 1),
		Pseq([1/4], 4)
	], inf),
	\pan, Pwhite(-0.2,0.2, inf),
	\amp, 0.3,
	\mix, 0.5,
	\room, 0.2,
	\damp, 0.8,
	\midinote, Pseq([77], inf)+ [0.0,0.1],
	\rq, Pwhite(0.2,0.5, inf)
);
)

(
~drum = Pbind(
	\instrument, \drum,
	\mul, Pseq([1], inf),
	\dur, Pseq([2], inf),
	\pan, Pwhite(-0.2,0.2, inf),
	\amp, 0.025,
	\mix, 0.2,
	\room, 0.5,
	\damp, 0.1
);
)

(
~drum = Pbind(
	\instrument, \drum,
	\mul, Pseq([1], inf),
	\dur, Pseq([
		Pseq([\,1,\,1],inf),
	], inf),
	\pan, Pwhite(-0.2,0.2, inf),
	\amp, 0.025,
	\mix, 0.1,
	\room, 0.1,
	\damp, 0.5
);
)

(
~mel = Pbind(
	\instrument, \mel,
	\scale, Scale.minor,
	\degree, Pseq([0,\,\,3,\,\,5], inf) + [0.0,0.009],
	\octave, [3],
	\dur, Pseq([2.2],inf),
	\pan, Pwhite(-1,1, inf),
	\amp, Pwhite(0.05,0.3, inf)
);
)

(
~mel.free(3);
~bass.free(3);
~drum.free(3);
)

BLo
NHHall