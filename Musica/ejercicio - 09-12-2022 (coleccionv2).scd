t = TempoClock.new(72/60).permanent_(true);
p = ProxySpace.new(s, clock: t);
p.push;

(
~caja = Pbind(
	\instrument, \drum,
	\dur, Pseq([1/2,1/2,1],10),
	\pan, Pseq([-1,1],inf),
	\amp, Pwhite(0.1,0.3, inf)
)
)
~caja.free(2)

(
~bass = Pbind(
	\instrument, \bass,
	\dur, Pxrand([1],inf),
	\note, Pseq([0],inf) + [0.0,0.01] - 12,
	\pan, 0.0,
	\amp, Pseq([1.0,0.5], inf) * 1.2
)
)
~bass.free(2)

(
~sq2b = Pbind(
	\instrument, \twobandsq,
	\dur, Pxrand([1],inf),
	\note, Pseq([1,3,7,9,12],inf) + [0.0,0.01,0.001] - 10,
	\rq, Pwhite(0.04,0.06,inf),
	\d, Pwhite(0.01,0.5,inf),
	\f, Pwhite(0.3,0.5,inf),
	\n, Pwhite(0.1,0.7,inf),
	\pan, Pwhite(-1,1, inf) ,
	\amp, Pwhite(0.2,0.6, inf) * 2.0
)
)
~sq2b.free(2)

(
~blips = Pbind(
	\instrument, \blips,
	\dur, Prand([1/8,1/4],inf),
	\note, Pxrand([0], inf) + [0.0,0.01] - 10,
	\harm, Pxrand([1,3,5,9,10,12,15], inf) + 6,
	\atk, 0.001,
	\rel, 0.15,
	\curve, -12,
	\pan, Pwhite(-0.8,0.8, inf),
	\amp, Pwhite(0.2,0.6, inf)
)
)
~blips.free(2)

t.tempo = 0.8;

(
~klang = Pbind(
	\instrument, \klang2,
	\dur, Pxrand([1],4),
	\n, Pwhite(0.2,5,inf),
	\pan, Pwhite(-1,1,inf),
	\amp, Pwhite(0.01,0.07, inf) * 0.2
)
)
~klang.free(2)

(
~reson = Pbind(
	\instrument, \reswhite,
	\dur, Pxrand([1/8], inf),
	\note, Pseq([1,3,5,7,9],inf),
	\pan, Pwhite(-0.5,0.5,inf),
	\amp, Pxrand([0.2,0.5,0.7,0.9],inf)
)
)
~reson.free(2)

~sq2b.free(3);
~reson.free(3);
~bass.free(3);
~blips.free(3);
~caja.free(3);
