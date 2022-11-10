
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

///// para automatización de nodos y grupos

p = ProxySpace.new(s, clock: t);
p.push;

//p.fadeTime_(2.5);
//p.quant_(2.5);
)

SpectrogramWindow.new;

///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\AY , {
	var sig, env;
	sig = AY.ar(\tonea.kr(1777), \toneb.kr(1666), \tonec.kr(1555), \noise.kr(1), \control.kr(3), \vola.kr(14), \volb.kr(15), \volc.kr(15), \envfreq.kr(4), \envstyle.kr(1), \chiptype.kr(0.0));
	env = EnvGen.kr(Env.perc(\atk.kr(), \rel.kr(1.0), curve: \curv.kr(-4.0)), doneAction: Done.freeSelf);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)


///////////////////////////////
///     Alojar variables
//////////////////////////////

({
~variable
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
		~variable = Pbind(
			\instrument, \AY,
			\dur, Pseq([1/4],inf),
			\tonea, Prand([200,1000,\,500,\], inf),
			\toneb, 500,
			\tonec, 5000,
			\noise, 0,
			\control, 7,
			\vola, 15,
			\volb, 12,
			\volc, 10,
			\envfreq, 0,
			\envstyle, 15,
			\chiptype, 0,
			\atk, 0.001,
			\rel, 1.2,
			\curv, -8.0,
			\pan, 0,
			\amp, 0.6,
	);
	}
);
)

~variable.free(3);