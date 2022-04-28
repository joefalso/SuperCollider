//*****************************************************************************
//basado en https://www.youtube.com/watch?v=DRswylPuDQU - Eli Fieldsteel
//Week 6: Introduction to Audio Coding with SuperCollider – MUS 499C Fall 2021
//*****************************************************************************

s.boot;
s.plotTree;
s.meter(numIns: 8, numOuts: 8);

(
	SynthDef.new(\sin, {
		arg out=0, gate=1;
		var freq, sig, tenv, env;
		freq = LFDNoise0.kr(16!2).exprange(150,4000);
		sig = SinOsc.ar(freq);
		tenv = EnvGen.ar(Env.perc(0.001, 0.06), Dust.kr(6!2));
		env = EnvGen.kr(Env.asr(5, 1, 5), gate, doneAction:2);
		sig = sig * tenv * env * 0.1;
		Out.ar(out, sig);
		}).add;

	SynthDef.new(\pn, {
		arg out=0, gate=1;
		var sig, env, mod;
		sig = PinkNoise.ar(1!2);
		mod = LFPulse.kr(0.6, 0, 0.02);
		sig = sig * mod;
		env = EnvGen.kr(Env.asr(0, 1, 5), gate, doneAction:2);
		sig = sig * env * 0.4;
		Out.ar(out, sig);
		}).add;
)

~sin = Synth(\sin);
~sin.set(\gate, 0);

~pn = Synth(\pn);
~pn.set(\gate, 0);

(
	SynthDef.new(\rev, {
		arg in=0, wetamp=0.3, out=0;
		var sig, wet;
		sig = In.ar(in, 2);    //está leyendo dos canales desde el bus cero, o sea, lee los buses 0 y 1
		wet = FreeVerb2.ar(
			sig[0], sig[1],
			mix: 1.0,
			room: 1.0,
			damp: 0.85,
			mul: wetamp
		);
		sig = sig + wet;
		Out.ar(out, sig);
		}).add;
)

~rev = Synth(\rev, [\in, 6, \out, 0]);

~sin = Synth(\sin, [\out, 6]);

~sin.set(\gate, 0);
~rev.free;

(
~rev = Synth(
	\rev,
	[\in, 6, \out, 0],
	s.defaultGroup,
	\addToHead
);
)

(
~sin = Synth(
	\sin,
	[\out, 6],
	s.defaultGroup,
	\addToHead
);
)

~sin.set(\gate, 0);

~sin = Synth(\sin, [\out, 6]);
~rev = Synth(\rev, [\in, 6, \out, 0], ~sin, \addAfter); //con addAfter el nodo aparece en la cola, en vez de la cabeza


~sin = Synth(\sin, [\out, 6]);
~rev = Synth(\rev, [\in, 6, \out, 0], s.defaultGroup, \addAfter);  //aparece en la cola del defaultGroup


(
~sourceGroup = Group.new;  //genera un grupo dentro del defautGroup
~fxGroup = Group.new(~sourceGroup, \addAfter); //genera un grupo luego del grupo source
)

// como los grupos están hechos y ordenados,
// el orden en que se ejecutan las líneas no importa,
// ya que los sintes están 'targeteados' convenientemente:
(
~sin = Synth(\sin, [\out, 6], ~sourceGroup);
~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);
)

// se arma igual a este:
(
~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);
~sin = Synth(\sin, [\out, 6], ~sourceGroup);
)

(
~sourceGroup.free;
~fxGroup.free;
)


~fxGroup = Group.new;
Synth(\sin, [\out, 6], ~fxGroup, \addBefore);
~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);


s.defaultGroup.set(\gate, 0);
~rev.free;


(
~sourceGroup = Group.new;
~fxGroup = Group.new(~sourceGroup, \addAfter);
)

~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);

Synth(\sin, [\out, 6], ~sourceGroup);

~sourceGroup.set(\gate, o)

Bus.help;
ServerOptions.defaultValues; // numAudioBusChannels = 1024
s.options.numAudioBusChannels;

n = s.options.numOutputBusChannels + s.options.numInputBusChannels; // cantidad de canales reservados (4)
s.options.numInputBusChannels;
s.options.numOutputBusChannels;

// la siguiente línea es como crear un atado de cables etiquetados como fxBus,
// de los 1024 toma desde los que están disponibles
~fxBus = Bus.audio(s, 2);


(
~sourceGroup = Group.new;
~fxGroup = Group.new(~sourceGroup, \addAfter);
~rev = Synth(\rev, [\in, ~fxBus, \out, 0], ~fxGroup);
~sin = Synth(\sin, [\out, ~fxBus], ~sourceGroup);
)

~sourceGroup.set(\gate, 0);
~rev.free;


~extraBus = Bus.audio(s, 2);  //toma los siguientes dos buses libres (si está en 4, toma desde el 6)

// la siguiente función da error,
// se intentan tomaer 2000 buses.
// no se pueden tomar tantos (máx: 1024, ver arriba)
(
1000.do(
	{Bus.audio(s,2);
})
)

s.newBusAllocators;  // 'resetea' los buses
~fxBus = Bus.audio(s, 2);  // empieza desde 4 (por los reservados)


// para asegurar el orden de los mensajes en el servidor,
// eli recomienda hacer un bundle-OSC, usando el método .bind:
(
s.bind({
	~sourceGroup = Group.new;
	~fxGroup = Group.new(~sourceGroup, \addAfter);
	~rev = Synth(\rev, [\in, ~fxBus, \out, 0], ~fxGroup);
	~sin = Synth(\sin, [\out, ~fxBus], ~sourceGroup);
});
)

~sourceGroup.set(\gate, o)
~rev.free;

//fin del video
s.freeAll;
s.quit;
