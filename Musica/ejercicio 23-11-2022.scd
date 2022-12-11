t = TempoClock(84/60).permanent_(true);
t.tempo;
p = ProxySpace.new(s, clock: t);
p.push;
p.pop;
currentEnvironment;

(
Pdef(
	\bajo,
	Pbind(
		\instrument, \bass,
		\dur, Pseq([1/4],inf),
		\note, Pxrand([0,3,5,9,11,13]-10,inf),
		\atk, 0.001,
		\rel, 0.4,
		\amp, Pxrand([0.3,0.4,0.5],inf)
	)
).play(t).quantBeat = 0.0;
)
Pdef(\bajo).stop;

t.beatInBar;
(
Pdef(
	\melodia,
	Pbind(
		\instrument, \mel,
		\dur, Pseq([1,1,1,1],2),
		\note, Pseq([0,\,\,\]-4,inf),
		\amp, Pxrand([0.3,0.4,0.1],inf)
	)
).play(t).quantBeat = t.nextBar;
)
Pdef(\melodia).stop;

(
Pdef(
	\resonador,
	Pbind(
		\instrument, \reswhite,
		\dur, Pseq([1/4],inf),
		\amp, Pxrand([0.08,0.2,0.3],inf)
	)
).play(t);
)
Pdef(\resonador).stop;

(
Pdef(
	\sinusoides1,
	Pbind(
		\instrument, \klang2,
		\dur, Pseq([1],2),
		\amp, Pxrand([0.005],inf)
	)
).play(t).sched(t.nextBar);
)
Pdef(\sinusoides1).stop;

t.beatInBar;

(
Pdef(
	\cuadrada,
	Pbind(
		\instrument, \twobandsq,
		\dur, Pseq([1],4),
		\note, Pseq([0,2]),
		\amp, Pxrand([0.2],inf)
	)
).play(t);
)
Pdef(\cuadrada).stop;



t.tempo = 1.5
Pdef(\bajo).stop;
Pdef(\caja).stop;
(
Pdef(
	\bajo,
	Pbind(
		\instrument, \bass,
		\dur, 1,
		\note, Pxrand([0,3,5,9,11,13]-8,inf),
		\atk, 0.1,
		\rel, 0.1,
		\amp, 0.2
	)
).quant(t.nextBar);
)
~bajo

(
~bass = Pbind(
	\instrument, \bass,
	\dur, Pseq([1],4),
	\amp, 0.2
)
)

t.tempo_(1.4);
t.beatInBar;

(
Pdef(\caja,
	Pbind(
		\instrument, \drum,
		\dur, Pseq([1],inf),
		\amp, Pxrand([0.09,0.3],inf)
	)
).play(t);
)


(
Pdef(\caja,
	Pbind(
		\instrument, \drum,
		\dur, Pseq([1],inf),
		\amp, Pseq([0.4,\,\,\],inf)
	)
).play(t).quantBeat = t.nextBar;
)

Pdef(\caja).stop;

(
Pdef(\caja,
	Pbind(
		\instrument, \drum,
		\dur, Pseq([1],inf),
		\amp, Pxrand([0.3,0.5],inf)
	)
).quant(t.nextBar);
)

Env.perc(0.001, 1.0, curve: -8.0).plot;

(
// timing offset = 0
p = Pbind(\freq, 440, \pan, -1, \delta, 1.0, \sustain, 0.1).play(quant: [2, 0, 0]);
// timing offest = 0.1
q = Pbind(\freq, 880, \pan, 1, \delta, 0.5, \sustain, 0.1).play(quant: [2, 0, 0.1]);
)

// p's nextBeat is x.0 - q's is x.4 or x.9 (e.g., halves of a beat minus 0.1)
[p.nextBeat, q.nextBeat]

p.stop; q.stop;


// schedule for a random number of beats after the next integer
(Pfuncn({ thisThread.clock.beats.debug("scheduled for"); nil }, 1)
    .play(quant: (
        nextTimeOnGrid: { |self, clock|
            clock.beats.roundUp(1).debug("clock beats") + rrand(self.lo, self.hi).debug("rand")
        },
        lo: 0, hi: 4
    ));
)