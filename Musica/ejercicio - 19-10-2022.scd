
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
s.boot;
)

p.pop;

///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\sinte1 , {
	arg out = 0, gate = 1, a1, a2, a3;
	var sig, sig1, sig2,sig3;
	sig1 = SinOsc.ar(\freq1.kr(100) + MouseY.kr(-100,100));
	sig2 = SinOsc.ar(\freq2.kr(150));
	sig3 = SinOsc.ar(\freq3.kr(200) + MouseX.kr(-100,100));
	sig = sig1 * a1 + sig2 * a2 + sig3 * a3;
	//sig = sig * XLine.kr(0.01,1.7, 1.0, doneAction: Done.freeSelf);
	sig = sig * EnvGen.kr(Env.perc, gate, doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.4));
	Out.ar(out, sig)
}).add;
)

p.pop;
(
~sinte1 = Synth(\sinte1, [
	\instrument, \sinte1,
	\freq1, 102,
	\freq2, 300,
	\freq3, 200,
	\a1, 0.48,
	\a2, 0.35,
	\a3, 0.35,
	\amp, 0.3,
]);
)

p.push;


///////////////////////////////
///     Alojar variables
//////////////////////////////

({
~sinte1
	.play
	.quant_(0.0)
	.fadeTime_(0.0)
}
)

currentEnvironment;
///////////////////////////////
///     Patrones
///////////////////////////////
~sinte1.clear(3);

(t.schedAbs(t.nextBar,
	{
		~sinte1 = Pbind(
			\instrument, \sinte1,
			\dur, 1,
			\freq1, 102,
			\freq2, 300,
			\freq3, 200,
			\a1, 0.48,
			\a2, 0.35,
			\a3, 0.35,
			\amp, 0.3
	);
	}
);
)

s.quit;