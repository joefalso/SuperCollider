
(
c = Routine {
    (0..).do { |i|
        i.yield;
    };
};
)
c.nextN(10);


d = Pseries(start: 0, step: 1, length: inf).asStream;

d.nextN(10);

MarkovSet.help;


p = Pseries(0, 5, 10);
p.next;    // always returns the Pseries, not actual numbers

q = p.asStream;
q.nextN(10);    // calling this repeatedly gets the desired increasing integers

r = p.asStream;
r.next;    // starts from zero, even though q already gave out some numbers

q.next;    // resumes where q left off, with no effect from getting values from r

[q.next, r.next]    // and so on...



// play at the next beat, with offset 0.4
(
Routine({ loop {
    "***".postln; 0.5.wait;
    "_*_".postln; 0.1.wait;
} }).play(quant:[1, 0.4]);
)


// play at the next beat, with offset 0.4
(
Routine({ loop {
    "///".postln; (delta:0.5).yield;
    "_/_".postln; (delta: 0.1).wait;
} }).asEventStreamPlayer.play;
)



// example
(
    x = Routine({
        1.yield;
        2.yield;
        3.yield;
    });
    4.do({ x.next.postln });
)



// compare:
// a function, returning 0.5
(
SystemClock.sched(0.0,
    { "***".postln; 0.5 }
);
)

// a stream, returning 0.5 and 0.1
(
SystemClock.sched(0.0,
    Routine({ loop {
        "***".postln; 0.5.yield;
        "_*_".postln; 0.1.yield;
    } });
);
)

// this is the reason why 'wait' works the same (for numbers) like 'yield'
(
SystemClock.sched(0.0,
    Routine({ loop {
        "***".postln; 0.5.wait;
        "_*_".postln; 0.1.wait;
    } });
);
)


// play at the next beat, with offset 0.4
(
Routine({ loop {
    "***".postln; 0.5.wait;
    "_*_".postln; 0.1.wait;
} }).play(quant:[1, 0.4]);
)

(
SystemClock.sched(0.0,{ arg time;
    time.postln;
    rrand(0.1,0.9);
});
)

SystemClock.help;