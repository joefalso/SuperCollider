
///////////////////////////////
///    Seteo de servidor
//////////////////////////////

(
/////  Limpiar servidor

s.freeAll;
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;

///// asignar más buffers y memoria virtual
s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;

///// clock y observadores
t = TempoClock(84/60).permanent_(true);

//t.schedAbs(t.nextBar, {t.beatsPerBar_(4)});
//t.schedAbs(t.beats.ceil, { ~beat = ~beat + 1; ~beat.postln; 1 });
//t.schedAbs(t.beatInBar.ceil, { arg beat, sec; [beat, sec].postln; 1 });

///// automatización de nodos

p = ProxySpace.new(s, clock: t);
p.push;

//p.fadeTime_(2.5);
//p.quant_(2.5);
)


///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\saw , {
	var sig, env;
	sig = Saw.ar(\freq.kr(100));
	sig = Mix.ar([sig]);
	//sig =
	env = EnvGen.kr(Env.perc(\atk.kr(0.25), \rel.kr(1.0), 1.0, \curve.kr(-12.0)), 1.0, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	sig = NHHall.ar(sig, rt60: 0.425, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
	Out.ar(0, sig)
}).add;
)

(
SynthDef.new(\saw , {
	var sig, sig2, env;
	sig = Saw.ar(\freq.kr(100));
	sig2 = VarSaw.ar(\freq2.kr(\freq), \iphase.kr(0.5), \width.kr(0.2));
	sig = Mix.ar([sig,sig2]);
	//sig =
	env = EnvGen.kr(Env.perc(\atk.kr(0.25), \rel.kr(1.0), 1.0, \curve.kr(-12.0)), 1.0, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	sig = NHHall.ar(sig, rt60: 0.325, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
	Out.ar(0, sig)
}).add;
)

(
SynthDef.new(\saw , {
	var sig, sig2, env;
	sig = Saw.ar(\freq.kr(100));
	sig2 = VarSaw.ar(\freq2.kr(\freq), \iphase.kr(0.5), \width.kr(0.2));
	sig = Mix.ar([sig,sig2]);
	//sig =
	env = EnvGen.kr(Env.perc(\atk.kr(0.25), \rel.kr(1.0), 1.0, \curve.kr(-12.0)), 1.0, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	sig = NHHall.ar(sig, rt60: 0.425, lowRatio: 0.01, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
	Out.ar(0, sig)
}).add;
)

(
SynthDef.new(\saw , {
	var sig, sig2, sig3, env;
	sig = Saw.ar(\freq.kr(100));
	sig2 = VarSaw.ar(\freq2.kr(\freq), \iphase.kr(0.5), \width.kr(0.8));
	sig3 = SinOsc.ar(\freq3.kr(\freq));
	sig = Mix.ar([sig,sig2,sig3]);
	//sig =
	env = EnvGen.kr(Env.perc(\atk.kr(0.25), \rel.kr(1.0), 1.0, \curve.kr(-12.0)), 1.0, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	sig = NHHall.ar(sig, rt60: 0.325, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
	Out.ar(0, sig)
}).add;
)


///////////////////////////////
///     Alojar variables
//////////////////////////////

({
~saw
	.play
	.quant_(0.0)
	.fadeTime_(0.5)
}
)


///////////////////////////////
///     Patrones
///////////////////////////////

(t.schedAbs(t.nextBar,
	{
		~saw = Pbind(
			\instrument, \saw,
			\dur, 1,
			\freq, 100,
			\freq2, 50,
			\pan, 0,
			\amp, 0.2
	);
	}
);
)


(t.schedAbs(t.nextBar,
	{
		~saw = Pbind(
			\instrument, \saw,
			\dur, 1/2,
			\midinote, Pseq([28,28,30,\], inf) + [0.0,0.1] + 2,
			\pan, 0,
			\amp, 0.2
	);
	}
);
)

(t.schedAbs(t.nextBar,
	{
		~saw = Pbind(
			\instrument, \saw,
			\dur, 1/4,
			\scale, Scale.minorPentatonic,
	\octave, [5],
	\degree, Pseq([
		Pseq([
			Pseq([0,4,2], 2),
			Pxrand([2,8,\], 1),
			Pxrand([0,4,\], 2),
	], 10),
		Pseq([
			Pseq([3,7,5], 2),
			Pxrand([3,9], 1),
			Pxrand([1,7], 2),
	], 10)
	], inf) + [0.0,0.01,0.005] - 8,
			\atk, 0.25,
			\rel, 1.0,
			\curve, -4.0,
			\pan, 0,
			\amp, 0.1
	);
	}
);
)