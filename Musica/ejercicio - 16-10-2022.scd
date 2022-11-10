
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

s.boot;
)


///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\sinte1 , {
	var sig, env;
	//env = Line.kr(1, 1, , doneAction: Done.freeSelf);
	env = EnvGen.kr(Env.perc(0.01,1,1,-4) , doneAction: Done.freeSelf);
	sig = SinOsc.ar(\freq.kr(100));
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(0, sig)
}).add;
)
FreeSelf.help
(
SynthDef(\freeselftest, { arg out, t_trig;
    FreeSelf.kr(t_trig);
    Out.ar(out, SinOsc.ar(400,0,0.2));
}).add;
)

///////////////////////////////
///     Alojar variables
//////////////////////////////

({
~sinte1
	.play
	.quant_(0.0)
	.fadeTime_(0.0)
};
)


///////////////////////////////
///     Patrones
///////////////////////////////

(t.schedAbs(t.nextBar,
	{
		~sinte1 = Pbind(
			\instrument, \sinte1,
			\dur, 1,
			\freq, 300 + [0.0,0.5],
			\pan, 0.0,
			\amp, 0.1
	);
	}
);
)

(
r = Routine { arg inval;
    loop {

    }
}.play;
)

s.sendMsg("/s_new", \freeselftest, 1731);
s.sendMsg("/n_set", 1731, \t_trig, 1);