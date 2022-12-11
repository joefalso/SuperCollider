(
SynthDef.new(\ay, {
	| gate=1, curve= -8.0 |
	var sig, env;
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = AY.ar(
		tonea: AY.freqtotone(\tonea.kr(100)),
		toneb: AY.freqtotone(\toneb.kr(100)),
		tonec: AY.freqtotone(\tonec.kr(100)),
		noise: \noise.kr(1),
		control: \ctrl.kr(3),
		vola: \vola.kr(14),
        volb: \volb.kr(14),
        volc: \volc.kr(14),
		envfreq: \envfreq.kr(4),
		envstyle: \envstyle.kr(1),
		chiptype: \chiptype.kr(0),
    );
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)

(
SynthDef.new(\ay, {
	| gate=1, curve= -8.0 |
	var sig, env;
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = AY.ar(
		tonea: AY.freqtotone(\tonea.kr(100)),
		toneb: AY.freqtotone(\toneb.kr(100)),
		tonec: AY.freqtotone(\tonec.kr(100)),
		noise: \noise.kr(1),
		control: \ctrl.kr(3),
		vola: \vola.kr(14),
        volb: \volb.kr(14),
        volc: \volc.kr(14),
		envfreq: \envfreq.kr(4),
		envstyle: \envstyle.kr(1),
		chiptype: \chiptype.kr(0),
    );
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)

(
t.schedAbs(t.nextBar,
	{
	~ay = Pbind(
			\instrument, \ay,
			\dur, Pseq([1/4],inf),
			\tonea, Pxrand((#[25,28,35]-12).midicps,inf),
			\toneb, Pxrand((#[25,28,35]-2).midicps,inf),
			\tonec, Pxrand((#[25,28,35]+0).midicps,inf),
			\noise, Pwhite(0,31,inf),
			\chiptype, 0,
			\atk, 0.001,
			\rel, 0.13,
			\amp, 0.1
		);
	}
)
)
t.tempo = 1.55