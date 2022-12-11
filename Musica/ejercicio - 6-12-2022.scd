(
t = TempoClock(84/60, 0).permanent_(true);

t.schedAbs(t.nextBar, {t.beatsPerBar_(4)});
t.schedAbs(t.beatInBar.ceil, { arg beat, sec; [beat, sec].postln; 1 });

p = ProxySpace.new(s, clock: t);
p.push;

)


t.beatsPerBar;

t.beatInBar;
t.bar;


(
t.schedAbs(t.nextBar,
	{
	~bass = Pbind(
			\instrument, \bass,
			\scale, Scale.minor,
			\degree, Pxrand([
				2,4,7,10,12
			], inf) + [0.0,0.01] - 4,
			\octave, [4],
			\atk, 0.001,
			\rel, 1.0,
			\curve, -12.0,
			\width, 0.05,
			\dur, Pseq([1/4], inf),
			\pan, Pwhite(-1.0,1.0, inf),
			\amp, Pxrand([0.15,0.25,0.5],inf) * 0.7
		);
	}
)
)

t.tempo_(0.8);
72/60

(
t.schedAbs(t.nextBar,
	{
	~drum = Pbind(
			\instrument, \drum,
			\dur, Prand([1/8,1/4], inf),
			\atk, 0.001,
			\rel, 0.5,
			\pan, Pwhite(-0.2,0.2, inf),
			\amp, Pxrand([0.05,0.2,0.3,0.5],inf)*0.2
		);
	}
);
)


(
t.schedAbs(t.nextBar,
	{
	~drum2 = Pbind(
			\instrument, \drum2,
			\dur, Pseq([1],inf),
			\atk, 0.0001,
			\amp, 0.2
		);
	}
)
)

(
t.schedAbs(t.nextBar,
	{
	~bass2 = Pbind(
			\instrument, \bass2,
			\dur, Pseq([1],inf),
			\note, -4 + [0.0,0.01],
			\atk, 0.0001,
			\amp, 0.3
		);
	}
)
)


(
t.schedAbs(t.nextBar,
	{
	~bass2 = Pbind(
			\instrument, \blips,
			\dur, Pseq([1/4],inf),
			\harm, Pxrand([5,10,15,17,19,20],inf) - 12,
			\note, -4 + [0.0,0.01] - 20,
			\atk, 0.0001,
			\amp, Pwhite(0.05,0.4,inf)
		);
	}
)
)

(
t.schedAbs(t.nextBar,
	{
	~wood = Pbind(
		\instrument, \coin,
		\dur, Pseq([2], inf),
		\freqimp, 40,
		\prob, 0.05,
		\pan, Pwhite(-1,1, inf),
			\amp, Pwhite(0.5,1.0,inf)
	);
	}
);
)

(
SynthDef.new(\klang3, {
	arg fact, rate;
	var sig, env;
	sig = Klang.ar(`[ {exprand(400, 2000)}.dup(12) * fact, nil, nil ], 1, 0);
	env = EnvGen.kr(Env([0,0.3,0.5,1,0.1,0], curve: 'lin'), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig , \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)

(
t.schedAbs(t.nextBar,
	{
	~klang = Pbind(
			\instrument, \klang,
			\dur, Pseq([1],4),
			\fact, Pwhite(0.2,1.0,4),
			\rate, 20000,
			\pan, Pxrand([-1,1],4),
			\amp, Prand([0.05,0.1],4) * 0.1
		);
	}
)
)
p.push

~bass.clear(3);
~drum.clear(3);
~wood.clear(3);

p.pop
s.boot;

// Default...
x = {AY.ar * 0.1}.play(s);
x.free;

// Mouse-controlled tones
(
x = {
    Pan2.ar(AY.ar(
        tonea:     MouseY.kr(10, 3900, 1),
        toneb:     MouseX.kr(10, 3900, 1),
        control:     3,
        vola:     14,
        volb:     14,
        volc:     0,
        mul: 0.1
    ))
}.play;
)

(
x = {
    var rate = MouseX.kr(0.1, 10); // You control your wandering speed
    Pan2.ar(AY.ar(
        tonea:     LFDNoise3.kr(rate).range(10, 3900),
        toneb:     LFDNoise3.kr(rate).range(10, 3900),
        tonec:     LFDNoise3.kr(rate).range(10, 3900),
        noise:     LFDNoise3.kr(rate).range(0, 31),
        control:     LFDNoise0.kr(rate).range(0, 31),
        vola:     LFDNoise3.kr(rate).range(0, 15),
        volb:     LFDNoise3.kr(rate).range(0, 15),
        volc:     LFDNoise3.kr(rate).range(0, 15),
        envfreq:     LFDNoise3.kr(rate).range(0, 4095),
        envstyle:     LFDNoise3.kr(rate).range(0, 15),
        mul: 0.1
    ))
}.play;
)


// try wiggling mouse quickly:
// LFNoise2 overshoots when going from high to low freqs, LFDNoise changes smoothly.

{  SinOsc.ar(LFNoise2.ar(MouseX.kr(0.1, 1000, 1), 200, 500), 0, 0.2)  }.play

{  SinOsc.ar(LFDNoise3.ar(MouseX.kr(0.1, 1000, 1), 200, 500), 0, 0.2)  }.play


// LFNoise quantizes time steps at high freqs, LFDNoise does not:

{ LFNoise2.ar(XLine.kr(2000, 20000, 8), 0.1) }.scope;

{ LFDNoise3.ar(XLine.kr(2000, 20000, 8), 0.1) }.scope;

// use as frequency control
(
{
        SinOsc.ar(
            LFDNoise3.ar(4, 400, 450),
            0, 0.2
        )
}.play;
)

{ Streson.ar(LFSaw.ar([220, 180], 0, mul:EnvGen.kr(Env.asr(0.5, 1, 0.02), 1.0) * 0.2), LinExp.kr(LFCub.kr(0.1, 0.5*pi), -1, 1, 280, 377).reciprocal, 0.9, 0.3) }.play