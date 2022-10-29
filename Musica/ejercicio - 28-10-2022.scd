
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

///// boot
s.boot;

///// espectrografo
SpectrogramWindow.new.waitForBoot;
)


///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\sinte1 , {
	var sig, env;
	//sig = SinOsc.ar(rrand(200, 1000));
	sig = Mix.fill(20, {VarSaw.ar(rrand(200, 2000), 0)});
	env = EnvGen.kr(Env.linen(1, 2, 3, 0.6), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig);
}).add;
)

{EnvGen.kr(Env.linen(1.5, 2, 3, 0.6))}.plot(1);
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
			\amp, 0.1
	);
	}
);
)