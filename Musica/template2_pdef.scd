
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

///// boot
s.boot;

)

///// espectrografo
SpectrogramWindow.new.waitForBoot;

///////////////////////////////
///     Sintetizadores
//////////////////////////////

(
SynthDef.new(\sinte1 , {

}).add;
)


///////////////////////////////
///     Patrones
///////////////////////////////


(t.schedAbs(t.nextBar,
	{
		Pdef(\nombre_distinto_a_sinte1,
			Pbind(
				\instrument, \sinte1
			)
		).play(t);
	};
))

