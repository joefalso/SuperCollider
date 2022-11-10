

////////////////////////////////////
///    Seteo y partida de servidor
////////////////////////////////////

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

//s.boot;
)


(
SynthDef.new(\sinte1, {
	arg freq = 200, pan = 0.0, amp = 0.2, out = 0;
	var sig, env;
	env = Line.kr(\linestart.kr(0.00001),\lineend.kr(0.5),\linedur.kr(1.0), doneAction: Done.freeSelf);
	sig = VarSaw.ar(freq);
	sig = sig * env * EnvGen.kr(Env.linen(0.002, 2.0, 3.0), 1.0, doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(~sinte1 = Synth(\sinte1, [
	\instrument, \sinte1,
	\freq, 200,
	\linedur, 10,
	\amp, 0.5
]);
)

p.pop;
p.push;
currentEnvironment;

({~sinte1
	.play
	.quant(0.0)
}
)

t.schedAbs(t.nextBar, {t.beatsPerBar_(4)});
t.schedAbs(t.beats.ceil, { ~beat = ~beat + 1; ~beat.postln; 1 });
t.schedAbs(t.beatInBar.ceil, { arg beat, sec; [beat, sec].postln; 1 });
t.bar;

(t.schedAbs(t.nextBar,
	Routine{
		~sinte1 = Synth(\sinte1, [
			\instrument, \sinte1,
			\scale, Scale.minor,
			\octave, [95],
			\degree, Prand([70], 2),
			\linestart, 0.001,
			\lineend, 1.0,
			\linedur, 10.0,
			\amp, 0.4
		]).waitForFree;
		1.wait;
		~sinte1 = Synth(\sinte1, [
			\instrument, \sinte1,
			\freq, 200,
			\linestart, 0.001,
			\lineend, 1.0,
			\linedur, 10.0,
			\amp, 0.7
		]).waitForFree;
	});
)
p.pop;
~sinte1.(\set, [\gate, 1]);
{Line.kr(0.0001,1.0,10.0)}.plot(10.0);