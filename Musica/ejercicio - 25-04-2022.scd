//***********************************
//    EJERCICIO: 25-04-2022
//***********************************

s.boot;

(SynthDef.new(\saw, {
	arg freq=220, width=0.5, mul=0.7, atk=0.005, rel=0.3, amp=1, pan=0.0, mix= 0.33, room=0.5, damp=0.5;
	var sig, env;
	sig = VarSaw.ar(
		freq: freq,
		width: width,
		mul: mul
	);
	env = EnvGen.kr(
		Env.new(
			levels: [0,0.1,0.7,0.1,0],
			times: [atk,rel],
			curve: \sine,
		),
		//doneAction: 2,
		//gate: Impulse.kr(1),
		doneAction: 3,
	);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	sig = FreeVerb2.ar(
		in: sig[0],
		in2: sig[1],
		mix: mix,
		room: room,
		damp: damp,

	);
	Out.ar(0, sig);
}).add;
)

(
Pdef(
	\sawpat,
	Pbind(
		\instrument, \saw,
		\width, Pwhite(0.01, 0.7, inf),
		\dur, Pseq([1], inf),
		\stretch, 60/128 * 4,
		\note, Pxrand([0,4,6, 12], inf),
		\atk, Pwhite(0.01, 0.08, inf),
		\rel, Pexprand(0.05, 0.2, inf),
		\amp, Pexprand(0.05, 0.2, inf),
		\pan, Pwhite(-0.9, 0.9, inf),
		\mix, 0.1,
		\room, 0,
	);
).play(quant: 60/128 * 2);
)

(
Pdef(
	\sawpat,
	Pbind(
		\instrument, \saw,
		\rel, 0.05
	);
).quant_(1.875);
)

/*
(
{
	arg tk=0.005, rel=0.3;
    EnvGen.kr(
        Env.new(

            levels: [0,1,0],
            times: [0.1, 0.1, 0.1],
            curve: [1,-1]
        ),
        //gate: Impulse.kr(3)
    );
}.plot(duration: 1);
)


({
    VarSaw.ar(
        LFPulse.kr(3, 0, 0.3, 200, 200),
        0,
        LFTri.kr(1.0).range(0,1), //width
        0.1)
}.play);
*/

(
SynthDef.new(\noise, {
	arg freq=220, mul=0.7, pan=0.0, amp=1, mix=0.33, room=0.5, damp;
	var sig, sigNoise, env;
	env = Line.kr(1,0,2);
	sig = FSinOsc.ar(
		freq: freq,
		mul: mul
	);
	sigNoise = PinkNoise.kr(env);
	sig = Pan2.ar(
		in: sig * sigNoise,
		pos: pan,
		level: amp
	);
	sig = FreeVerb2.ar(
		in: sig[0],
		in2: sig[1],
		mix: mix,
		room: room,
		damp: damp,

	);
	FreeSelf.kr(TDelay.kr(Done.kr(env),2));
	Out.ar(0, sig);
}).add;
)



(
Pdef(
	\ruido,
	Pbind(
		\instrument, \noise,
		\dur, 1/16,
		\stretch, 60/128 * 4,
		\note, Pxrand([2,4,16], inf),
		\amp, Pexprand(0.05, 0.1, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
		\mix, Pexprand(0.05, 0.1, inf),
		\room, Pwhite(0.07, 0.1, inf),
	);
).play(quant: 60/128 * 2);
)

Pdef(\sawpat).stop;
Pdef(\ruido).stop;
s.quit;
	