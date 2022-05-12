
// doneAction: Done.freeSelf , 2, 3
(
SynthDef(\subtractive, {
	arg out=0, freq=440, amp=0.5, pan=0.0;
	var sig;
	sig= LPF.ar(
            Pulse.ar(freq, 0.5, amp),    // the source to be filtered
            Line.kr(8000, 660, 6, doneAction: Done.freeSelf)
	);
	sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;


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


(
~rev = Synth(\rev, [
	\in, 6,
	\out, 0,
	\wetamp, 1.2
]);
)

(
Pdef(
	\subTest,
	Pbind(
		\instrument, \subtractive,
		\stretch, 60/128 * 4,
		\dur, Pseq([1/2], inf),
		\note, Pxrand([0,4,6,12,15,18], inf),
		\amp, Pexprand(0.05, 0.2, inf),
		\pan, Pwhite(-0.9, 0.9, inf),
		\out, 6
	)
).play(quant:60/128 * 4);
)








Pdef(\subTest).stop;

(
SynthDef("passLowFreqs2", { arg out;
    Out.ar(
        out,
        RLPF.ar(
            Saw.ar([220, 221] + LFNoise0.kr(1, 100, 200), 0.2),
            [LFNoise0.kr(4, 600, 2400), LFNoise0.kr(3, 600, 2400)],
            0.1
        )
    )
}).add;
)

Synth("passLowFreqs2")