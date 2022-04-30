a = Routine {
    var    i = 0;
    loop {
        i.yield;
        i = i + 1;
    };
};

a.nextN(10);

(a = Routine {
    (0..).do { |i|
        i.yield;
    };
});

a.nextN(10);

(a = Routine {
    (0..).do { |i|
        i.yieldAndReset(reset: false);
    };
});

a.nextN(10);

f = (0..8).iter.loop;
f.nextN(9)


