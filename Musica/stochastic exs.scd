(
5.do({
    thisThread.randSeed = 4;
    Array.fill(10, { 1000.linrand}).postln;
});
)

// Just to check, no seeding:

(
5.do({ Array.fill(10, { 1000.linrand }).postln; });
)


// saw
(
{
	sum(
	{|i|
		var j = i + 1;
		SinOsc.ar(300 * j, 0, 1/j)
	} ! 100)
}.plot
)

// inverse saw
(
{
	sum(
	{|i|
		var j = i + 1 * 2;
		SinOsc.ar(300 * j, pi, 1/j)
	} ! 20)
}.plot
)


// pulse
(
{
	sum(
	{|i|
		var j = i * 2 + 1;
		SinOsc.ar(300 * j, 0, 1/j)
	} ! 20)
}.plot
)

// triangle
(
{
	sum(
	{|i|
		var j = i * 2 + 1;
		SinOsc.ar(300 * j, pi/2, 1 / j.squared) // cosine wave (phase shift)
	} ! 20)
}.plot
)


20.do({ 1.coin.postln }); //100% true, 20 times
20.do({ 0.coin.postln }); //100% false, 20 times

{ coin(SinOsc.ar(700)) * 0.05 }.play

(
a = SynthDef("help-TCoin", { arg out=0, prob=0.5;
    var trig;
    trig = CoinGate.kr(prob, Impulse.kr(10));
    Out.ar(out,
        SinOsc.ar(
            TRand.kr(300.0, 400.0, trig),0,0.2
        )
    )
}).play;
)

a.set(\prob, 1.0);
a.set(\prob, 0.0);
a.set(\prob, 0.1);


(
a = SynthDef(\coin, { arg out=0, prob=0.1;
    var trig;
    trig = Impulse.ar(7.0, 0, SinOsc.kr(0.01, 0, 1, 1));
	trig = EnvGen.kr(Env.perc(0.001, 1.0, 1.0, -8.0), doneAction: 2) * trig;
	trig = Mix.fill(7, {Ringz.ar(CoinGate.ar(prob, trig), [0.5, 0.75] * Rand(3000, 9000), 0.05)});
	trig = NHHall.ar(trig, rt60: 0.325, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
    Out.ar(out, trig * 0.75)
}).play;
)

(
a = SynthDef(\coin, { arg out=0, prob=0.1;
    var trig;
    trig = Impulse.ar(7.0, 0, SinOsc.kr(0.01, 0, 1, 1));
	trig = Mix.fill(7, {Ringz.ar(CoinGate.ar(prob, trig), [0.5, 0.75] * Rand(3000, 9000), 0.05)});
	trig = NHHall.ar(trig, rt60: 0.325, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
    Out.ar(out, trig * 0.75)
}).play;
)

(
a = SynthDef(\coin, { arg out=0, prob=0.1;
    var trig;
	trig = Impulse.ar(7.0, 0, LFNoise2.kr(0.05,0.25,0.5));
	trig = Mix.fill(7.0, {Ringz.ar(CoinGate.ar(prob, trig), #[0.5, 0.75] * Rand(3000, 9000), 0.05)});
	trig = NHHall.ar(trig, rt60: 0.45, lowRatio: 0.4, earlyDiffusion: 0.1, lateDiffusion: 0.65, modRate: 0.2, modDepth: 0.4);
    Out.ar(out, trig * 0.75)
}).play;
)

a.set(\prob, 1.0);
a.set(\prob, 0.0);
a.set(\prob, 0.1);


({ 100.0.linrand }!10).plot;     // probability decreases linearly from 0 to <number>.

{ 1.0.sum3rand }.dup(100).plot

({ 5.rand }!10).plot;
({ 5.0.rand2 }!20).plot;

({ 1.0.bilinrand }!20).plot;
({ 1.0.sum3rand  }!100).plot;

({ rrand(-1.0, 1.0) }!20).plot;
({ rrand(-1.0, 1.0).bilinrand }!100).plot;

({ rrand(24, 48) }!20).plot;

({ rrand(24, 48) }!20).plot;
({ rrand(24, 48) }!20).plot;

({ rrand(24, 48) }!20).plot;
({ rrand(24, 48) }!20).plot;

{ Crackle.ar(1.9, 0.5) }.play;
{ WhiteNoise.ar(0.05) }.play;

// modulate chaos parameter
{ Crackle.ar([Line.kr(0.5, 2.0, 3)]!2, 0.2, 0.0) }.play;

// default initial params
{ LatoocarfianN.ar(MouseX.kr(20, SampleRate.ir)) * 0.2 }.play(s);


// randomly modulate all params
(
{ LatoocarfianN.ar(
    SampleRate.ir/4,
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,0.5,1.5),
    LFNoise2.kr(2,0.5,1.5)
) * 0.05 }.play(s);
)

(
var a = 1, b = 3, c = 0.5, d = 0.5, xi = 0.5, yi = 0.5, size = 64;
plot(size.collect { var x = xi;
xi = sin(b * yi) + (c * sin(b * xi));
yi = sin(a * x) + (d * sin(a * yi));
xi
});
)

Platform.systemExtensionDir;

8.dup(10);

#[1,1.5]

(
{
    SinOsc.ar(
        EnvGen.kr(
            Env.circle([0, 1, 0, (2..4), 0, LFNoise1.kr(0.1 ! 5) * 10, 0], [0.01, 0.6])
        )
        * 240 + 300
    ).sum * 0.05
}.play;
)