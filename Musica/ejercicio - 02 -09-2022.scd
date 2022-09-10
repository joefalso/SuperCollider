(
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;

//asignar más memoria virtual
s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;

/*tempos usuales:
84/60 : 1.4
96/60 : 1.6
*/

t = TempoClock.new(84/60).permanent_(true);

p = ProxySpace.new(s, clock: t);
p.push;
p.fadeTime_(1.5);
p.quant_(0.0);

s.freeAll;
s.boot;
)

(
SynthDef.new(\sinte1, {
	var sig, env;
	sig = Blip.ar(\freq.kr(100), \harm.kr(100));
	sig = RLPF.ar(sig, \freqflt.kr(100), \rq.kr(0.5));
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: \curve.kr(-8.0)), \gate.kr(1), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.3));
	Out.ar(0, sig)
}).add;

SynthDef.new(\sinte2, {
	var sig, env;
	sig = LFTri.ar(\freq.kr(100));
	env = EnvGen.kr(Env([0,1,0], [\timelo.kr(1), \timehi.kr(1)], curve: 'lin'), \gate.kr(1), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.3));
	Out.ar(0, sig)
}).add;

)

({
~sinte1
	.play
	.fadetime_(0.0)
	.quant_(0.0)
};
{
~sinte2
	.play
	.fadetime_(0.0)
	.quant_(0.0)
};
)

(
p.fadeTime_(3);
p.quant_(3);
)

Scale.all.put(\catastrophic, Scale([0, 0.01, 0.04, 11.2]));
Scale.at(\catastrophic); // access the scale

(
~sinte1 = Pbind(
	\instrument, \sinte1,
	\dur, 1/4,
	\scale, Scale.minorPentatonic,
	\octave, [6],
	\degree, Pseq([
		Pseq([
			Pseq([0,4,2], 2),
			Pxrand([2,8], 1),
			Pxrand([0,4], 2),
	], 10),
		Pseq([
			Pseq([3,7,5], 2),
			Pxrand([3,9], 1),
			Pxrand([1,7], 2),
	], 10)
	], inf) + [0.0,0.01],
	\harm, 700,
	//\freqflt, Pseq([50,75,100,125,150,175,200,225,250,275,300,325,350,375,400,375,350,325,300,275,250,225,200,175,150,125,100,75], inf),
	\freqflt, Pseq([Phprand(50,400,20), Plprand(50,400,20)],inf),
	\rq, 0.01,
	\atk, 0.001,
	\rel, 0.75,
	\curve, -8.0,
	\gate, 1,
	\pan, Pwhite(-0.5,0.5, inf),
	\amp, 0.7,
);
)


(
~sinte2 = Pbind(
	\instrument, \sinte2,
	\dur, 4,
	\scale, Scale.minorPentatonic,
	\octave, [2],
	\degree, Pseq([4,\,8,\,12], inf),
	//\freqflt, Pseq([50,75,100,125,150,175,200,225,250,275,300,325,350,375,400,375,350,325,300,275,250,225,200,175,150,125,100,75], inf),
	\gate, 1,
	\pan, Pwhite(-0.5,0.5, inf),
	\amp, 0.05,
).trace;
)


(Pbind(\scale, a, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1), \dur, 0.25).play;)


(
var a, x;
a = Pfunc({ exprand(0.1, 2.0) + #[1, 2, 3, 6].choose }, { \reset.postln });
x = a.asStream;
x.nextN(20).postln;
x.reset;
)

// with argument passed to nextFunc
(
x = Pfunc({ |inval| (10 ** inval.value) * rrand(1, 9) }).asStream;
[2, 3, 2].do { |i| x.next(i).postln };
x.nextN(5, (:0..)).postln;
)

MarkovSet.help

m = MarkovSet.fill(100, Pseq([1, 2, 3, 4, Prand([5, 55, 555])], inf).asStream);

8.do { m.next(1).postln };
8.do { m.next(4).postln };
8.do { m.next(55).postln };


// event streams
(
SynthDef("mark", { arg out, freq, sustain=1, amp=0.1, pan;
    var env, u=1;
    env = EnvGen.kr(Env.perc(0.03, sustain, 5), 1, doneAction:2);
    3.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * 300, u, rrand(0.1, 0.4) * d, 1) };
    Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));

}).store;
)

(
a = Pbind(
    \freq, Pshuf([203, 490, 231, 764, 234], inf),
    \dur, Pshuf([0.5, 0.5, 1.0, 0.25, 0.125, 0.5], inf)
);
m = MarkovSet.fill(20, Pevent(a, Event.default).asStream);
)

m.dict.keysValuesDo { |key, val| postf("key: %\t\tvalue: %\n", key, val) }; ""

// compare:
b = Pchain(Pfsm2(m), (instrument: \mark));
c = Pchain(a, (instrument: \mark));

Ppar([b, c]).play;