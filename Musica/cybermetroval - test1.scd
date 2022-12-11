
// read a soundfile from disk
b = Buffer.read(s, "C:/Users/diego/OneDrive/Escritorio/apuntes uv/etnografia 2/tomas tascam/220507_0962.wav");

(
d = Dictionary.new;
d.add(\tascam1 -> PathName("C:/Users/diego/OneDrive/Escritorio/apuntes uv/etnografia 2/tomas tascam").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
})
)
)

d[\tascam1].play;

(
// trigger one shot on each pulse
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var trig;
    trig = Impulse.kr(0.5);
    Out.ar(out,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), trig, 0, 0)
    )
}).play(s, [\out, 0, \bufnum, b]);
)

(
SynthDef.new(\tasc1, {
	arg buf=0, rate=1, amp=1, pan=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, \start.kr(0.0), doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar([0,1], sig);
}).add;
)

b;

(
Pdef(
	\metro1,
	Pbind(
		\instrument, \tasc1,
		\dur, Pseq([1], 1),
		//\buf, Prand(d[\cajon]++d[\conga]++d[\djembe], inf),
		\rate, 1,
		\start, 0,
		\bufnum, 181100160/2,
		\amp, 0.5,
	);
).play;
)

(
~metro2 = Pbind(
		\instrument, \tasc1,
		\dur, Pseq([1], 1),
		//\buf, Prand(d[\cajon]++d[\conga]++d[\djembe], inf),
		\rate, 1,
		\amp, 0.5,
).trace;
)



(
SynthDef.new(\tasc1, {
	arg buf=0, rate=1, amp=1, pan=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar([0,1], sig);
}).play(s, [\out, 0, \bufnum, b]);
)


