// practica 12-07-2022

// desde pag 152 (Synth definitions)
//Three separate nodes of "SH" with different arugments.
//Run these three lines in sequence then stop.
a = Synth("SH", [\rate, 10, \offset, 200]);
b = Synth("SH", [\offset, 400, \att, 3.0, \decay, 0]);
c = Synth("SH", [\rate, 30, \offset, 2000]);
//Let them die out or run these lines to stop them.
a.free;
b.free;
c.free;
//Changing a parameter of an existing node. Run these lines in sequence.
a = Synth("SH", [\rate, 23, \offset, 30, \decay, 20]);
a.set(\offset, 1000)
a.set(\offset, 300)
a.set(\offset, 800)
a.free;
//Two nodes with arguments
a = Synth("SH", [\rate, 7, \offset, 200, \decay, 20]);
b = Synth("SH", [\rate, 23, \offset, 1200, \decay, 20]);

a.set(\offset, 40)
b.set(\offset, 1000)
a.set(\offset, 800)
b.set(\offset, 600)
a.set(\offset, 1200)
b.set(\offset, 50)
a.free; b.free;

(
SynthDef("SH",
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan;
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
Blip.ar(LFNoise0.ar(rate, min(100, offset), offset),
(env)*12 + 1, 0.3),
pan)*env;
Out.ar(0, out)
},
[0.5, 0.1, 0, 4] //transition for each argument above
).play
)
a = Synth("SH", [\rate, 6, \decay, 20, \offset, 200]);
a.set(\rate, 18);
a.set(\offset, 1000);
a.stop(3);

// este
(
r = Task({
{
Synth("SH", [
\rate, exprand(3.0, 22.0),
\decay, rrand(0.5, 15.0),
\att, [0, rrand(0, 3.0)].choose,
\offset, rrand(100, 2000)]);
rrand(1.0, 5.0).wait; //wait time between repetitions
}.loop; //repeat this function
}).play
)
r.stop(5);