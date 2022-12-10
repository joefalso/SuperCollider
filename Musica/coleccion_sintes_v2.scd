(
SynthDef.new(\sinmix, {
	var sig, env;
	//sig = SinOsc.ar(rrand(200, 1000));
	sig = Mix.fill(20, {VarSaw.ar(rrand(200, 2000), 0)});
	env = EnvGen.kr(Env.linen(1, 2, 3, 0.6), doneAction: Done.freeSelf);
	sig = sig * env;
	//sig = Resonz.ar(sig, \freqres.kr(440), \bwr.kr(1.0));
	//sig = RHPF.ar(sig, \freqres.kr(440), \rq.kr(1.0));
	sig = RHPF.ar(sig, MouseY.kr(1000,4000), MouseX.kr(0.1,1.0));
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;

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

SynthDef.new(\drum2, {
	| gate=1, curve= -8.0, mul=1 |
	var sig, env;
	sig = WhiteNoise.ar(mul);
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

SynthDef.new(\bass2, {
	| gate=1, curve= -8.0 |
	var sig, env;
	sig = SinOsc.ar(\freq.kr(100));
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.ir(1), curve: curve), gate, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = FreeVerb.ar(sig, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5));
	sig = Pan2.ar(sig, \pan.ir(0.0), \amp.ir(0.3));
	Out.ar(0, sig)
}).add;


SynthDef.new(\coin, {
	arg prob=0.1;
    var trig;
	trig = Impulse.ar(\freqimp.kr(9.0), 0, SinOsc.kr(0.01, 0, 1, 1));
	trig = EnvGen.ar(Env.perc(0.01, 1.0, 1.0, -8.0), doneAction: Done.freeSelf) * trig;
	trig = Mix.fill(7.0, {Ringz.ar(CoinGate.ar(prob, trig), #[0.5, 0.75] * Rand(3000, 9000), 0.05)});
	trig = NHHall.ar(trig, rt60: 0.45, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
    Out.ar(0, trig * 0.75)
}).add;

SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1, pan=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar([0,1], sig);
}).add;

SynthDef.new(\blips, {
	var sig, env;
	sig = Blip.ar(\freq.kr(200), \harm.kr(30));
	env = EnvGen.kr(Env.perc(\atk.kr(0.001), \rel.kr(0.5)), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;

SynthDef.new(\klang, {
	arg n;
	var sig, env;
	sig = Klang.ar(`[ {exprand(400, 2000)}.dup(12) * n, nil, nil ], 1, 0);
	env = EnvGen.kr(Env([0,1,0], curve: 'lin'), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;

SynthDef.new(\klang2, {
	arg n;
	var sig, env;
	sig = Klang.ar(`[ {exprand(400, 2000)}.dup(24) * n, nil, nil ], 1, 0);
	env = EnvGen.kr(Env.sine(6), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;

SynthDef.new(\twobandsq, {
	arg n, d, f;
	var sig, env;
	//env = XLine.kr(8000,200,2, doneAction: Done.freeSelf);
	env = EnvGen.kr(Env([8000,1000,50]), doneAction: Done.freeSelf) * n;
	sig = Impulse.ar([100,250] * d);
	sig = RLPF.ar(sig, env * f, \rq.kr(0.05));
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;

SynthDef(\reswhite, {
	var sig, env;
	sig = ClipNoise.ar;
	env = XLine.kr(1, 0.0001, \dur.kr(8), doneAction: Done.freeSelf);
	sig = Resonz.ar(sig, \freq.kr(2000), env);
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;

SynthDef(\buf_grain_test, {arg gate = 1, sndbuf, amp = 1;
    Out.ar(0,
        BufGrain.ar(Impulse.kr(10), 0.2, sndbuf, MouseX.kr(0.5, 8), PinkNoise.kr.range(0, 1), 2,
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: amp,
                doneAction: 2)
        )
    )
}).add;
)


//////////////////////
// Samples
// (ojo con el path)
////////////////////

(
d = Dictionary.new;
d.add(\cajon -> PathName("C:/Users/Administrador/OneDrive/Escritorio/Diego HN/SuperCollider/material/Cajon").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\conga -> PathName("C:/Users/Administrador/OneDrive/Escritorio/Diego HN/SuperCollider/material/Conga").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\djembe -> PathName("C:/Users/Administrador/OneDrive/Escritorio/Diego HN/SuperCollider/material/Djembe").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\quote -> PathName("C:/Users/Administrador/OneDrive/Escritorio/Diego HN/SuperCollider/material/movie quotes").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
);
)