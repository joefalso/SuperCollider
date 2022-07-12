// práctica 11-Jul-2022

// D. Cottle - Noise, Sub. Synthesis, Debugging, Modifying the Source

// Noise

{rrand(1, 1000).round(1)}.dup(100).sort; //rrand 100 cifras entre 1 y 1000

{exprand(1, 1000).round(1)}.dup(100).sort;

{Mix.fill(1000, {SinOsc.ar(rrand(1.0, 20000))})*0.01}.play;

{Mix.fill(1000, {SinOsc.ar(exprand(1.0, 20000))})*0.01}.play;


//rrand y exprand están siendo usado para generar una cifra aleatoria

SequenceableCollection.help; // info sobre rran, expran y otros math support


{PinkNoise.ar}.play;

{WhiteNoise.ar}.play;

{BrownNoise.ar}.play;

{(GrayNoise.ar) * 0.05}.play;

{Dust.ar([100, 48]) * 0.5}.scope(2);



// Sub. Synthesis

(
{
	var signal, filtar, cutoff, resonance;

	signal = PinkNoise.ar(mul: 0.7);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);

	RHPF.ar(signal, cutoff, resonance)}.scope(1);
)

(
{
	var signal, filtar, cutoff, resonance;

	signal = PinkNoise.ar(mul: 0.7);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);

	RLPF.ar(signal, cutoff, resonance)}.scope(1);
)

(
{
	var signal, filtar, cutoff, resonance;

	signal = PinkNoise.ar(mul: 0.7);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);

	BPF.ar(signal, cutoff, resonance)}.scope(1);
)


(
{
	var signal, filtar, cutoff, resonance;

	signal = Saw.ar([50, 75], mul: 0.6);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);

	RHPF.ar(signal, cutoff, resonance)}.scope(2);
)

(
{
	var signal, filtar, cutoff, resonance;

	signal = Saw.ar([50, 75], mul: 0.6);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);

	RLPF.ar(signal, cutoff, resonance)}.scope(2);
)

(
{
	var signal, filtar, cutoff, resonance;

	signal = Saw.ar([50, 75], mul: 0.6);
	cutoff = MouseX.kr(40, 10000, 1);
	resonance = MouseY.kr(0.01, 2.0);

	BPF.ar(signal, cutoff, resonance)}.scope(2);
)

{RLPF.ar(Saw.ar([100,250],0.1), XLine.kr(8000,400,5), 0.05) }.play;
XLine.help;

// control de frecuencia
{SinOsc.ar([LFNoise0.kr(12, 500, 500), LFNoise0.kr(12, 500, 500)], mul: 0.3)}.play;

{RLPF.ar(PinkNoise.ar(0.3), LFNoise0.kr([12, 12], 500, 500), 0.02)}.play;

{RLPF.ar(PinkNoise.ar(0.9), LFNoise0.kr([12, 12], 500, 500), 0.5)}.play;

{RLPF.ar(BrownNoise.ar(0.05), LFNoise0.kr([12, 12], 500, 500), MouseY.kr(0.001, 2.0))}.play;


(
{
Klank.ar(
`[[100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], //freq array
[0.05, 0.2, 0.04, 0.06, 0.11, 0.01, 0.15, 0.03, 0.15, 0.2]],
PinkNoise.ar(MouseX.kr(0.01, 0.1)))
}.scope(1)
)

(
{
Klank.ar(
`[Array.series(10, 50, 50),
Array.series(10, 1.0, -0.1)],
ClipNoise.ar(0.01)
)
}.scope(1)
)

(
{
Klank.ar(
`[{exprand(60, 10000)}.dup(15)],
PinkNoise.ar(0.005)
)
}.scope(1);
)


(
{
var burstEnv, att = 0, burstLength = 0.0001, signal; //Variables
burstEnv = Env.perc(0, burstLength); //envelope times
signal = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); //Noise burst
signal;
}.play
)

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;
freqSpecs = `[
{rrand(100, 1200)}.dup(totalHarm), //freq array
{rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.01), //amp array
{rrand(2.0, 4.0)}.dup(totalHarm)]; //decay rate array
burstEnv = Env.perc(0, burstLength); //envelope times
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); //Noise burst
Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.6)
}.scope(1)
)


(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;
freqSpecs = `[
{rrand(1, 30)*100}.dup(totalHarm),
{rrand(0.1, 0.9)}.dup(totalHarm).normalizeSum,
{rrand(1.0, 3.0)}.dup(totalHarm)];
burstEnv = Env.perc(0, burstLength);
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1)));
Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.6)
}.scope(1)
)

Array.fill(5, {exprand(10, 100)}).round(1) * ([1, 2, 5, 7].choose)


(
[[60, 62, 68], [65, 67], [61, 63, 55, 23]]
.choose.postln
.midicps.postln
.round(0.1).postln
.reciprocal.postln
.round(0.0001).postln
)


(
// unintelligible
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose.post;
duration = 4.0.rand.round(0.1).post;
amplitude = 1.0.rand.round(0.1).post;
voice = 10.rand.post;
}))


(
// too spread out
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose.postln;
duration = 4.0.rand.round(0.1).postln;
amplitude = 1.0.rand.round(0.1).postln;
voice = 10.rand.postln;
})
)

(
// cumbersome
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose.post;
" ".post;
duration = 4.0.rand.round(0.1).post;
" ".post;
amplitude = 1.0.rand.round(0.1).post;
" ".post;
voice = 10.rand.postln;
})
)

(
// adequate
var pitch, duration, amplitude, voice;
"pitch, duration, amplitude, voice".postln;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
[pitch, duration, amplitude, voice].postln;
})
)

(
// better?
var pitch, duration, amplitude, voice;
"pitch, duration, amplitude, voice".postln;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
"P, D, A, V ".catArgs(pitch, duration, amplitude, voice).postln
}))


(
// useful
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
"pch %\tdur %\tamp %\tvce %\n".postf(pitch, duration, amplitude, voice)
})
)
(
// useful
var pitch, duration, amplitude, voice;
"pch\t\tdur\t\tamp\t\tvce".postln;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
"%\t\t%\t\t%\t\t%\n".postf(pitch, duration, amplitude, voice)
})
)

(
{
var totalInst, totalPartials, baseFreq, ampControl, chimes, cavern;
totalInst = 5; //Total number of chimes
totalPartials = 12; //Number of partials in each chime
baseFreq = rrand(200, 1000); //Base frequency for chimes
chimes =
Mix.ar(
{
Pan2.ar(
Klank.ar(`[
{baseFreq*rrand(1.0, 12.0)}.dup(totalPartials),
Array.rand(totalPartials, 0.3, 0.9),
Array.rand(totalPartials, 0.5, 6.0)],
Decay.ar(
Dust.ar(0.2, 0.02), //Times per second, amp
0.001, //decay rate
PinkNoise.ar //Noise
)), 1.0.rand2) //Pan position
}.dup(totalInst)
);
cavern =
Mix.ar(
{
var base;
base = exprand(50, 500);
Klank.ar(
`[ //frequency, amplitudes, and decays
{rrand(1, 24) * base *
rrand(1.0, 1.1)}.dup(totalPartials),
Array.rand(10, 1.0, 5.0).normalizeSum
],
GrayNoise.ar( [rrand(0.03, 0.1), rrand(0.03, 0.1)])
)*max(0, LFNoise1.kr(3/rrand(5, 20), mul: 0.005))
}.dup(5));
cavern + chimes
}.play
)