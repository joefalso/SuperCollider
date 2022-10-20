
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


///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\sinte1 , {
	var sig, sig1, sig2, sig3, env;
	sig1 = VarSaw.ar(\freq1.kr(100));
	sig2 = VarSaw.ar(\freq2.kr(100));
	sig3 = VarSaw.ar(\freq3.kr(100));
	sig = sig1 * \a1.kr(0) + sig2 * \a2.kr(0) + sig3 * \a3.kr(0);
	//sig = Mix.fill(8, [sig1, sig2, sig3]);
	env = EnvGen.kr(Env.linen(1, 2, 3, 0.6), 1.0, doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig);
}).add;
)

EnvGen.new().
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


///////////////////////////////
///     Patrones
///////////////////////////////

(t.schedAbs(t.nextBar,
	{
		~sinte1 = Pbind(
			\instrument, \sinte1,
			\dur, Pseq([1], 1),
			\freq1, Prand([400,405], 1),
			\freq2, Prand([800,605], 1),
			\freq3, Prand([802,200], 1),
			\a1, 0.06,
			\a2, 0.06,
			\a3, 0.06,
			\pan, Pwhite(-0.2,0.2,inf),
			\amp, 0.9
	);
	}
);
)

Env.linen(0.1, 0.2, 0.1, 0.6).test.plot;
Env.linen(1, 2, 3, 0.6).test.plot;
Env.linen(1, 2, 3, 0.6, \sine).test.plot;
Env.linen(1, 2, 3, 0.6, \welch).test.plot;
Env.linen(1, 2, 3, 0.6, -3).test.plot;
Env.linen(1, 2, 3, 0.6, -3).test.plot;
Env.linen(1, 2, 3, 0.6, [[\sine, \welch, \lin, \exp]]).test.plot;

(
{
    var env = Env([0.0, 0.5, 0.0, 1.0, 0.9, 0.0], [0.05, 0.1, 0.01, 1.0, 1.5], -4);
    var envgen = EnvGen.ar(env, doneAction: Done.freeSelf);
    SinOsc.ar(
        envgen * 1000 + 440
    ) * envgen * 0.1
}.play
)