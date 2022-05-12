

Server.allRunningServers;

s.boot;

Server.allRunningServers; // que server está corriendo

// Node Proxy

n = NodeProxy.new;

n.numChannels;

n.clear;

n.numChannels;

n.source = { RLPF.ar(Dust.ar([12,15]), LFNoise1.ar(1/[3, 4], 1500, 1600), 0.02)};

n.play



//// a <-- b : a está después del nodo b

b = NodeProxy.new.play;
b.source = { PinkNoise.ar(0.2.dup) };
// now I want to filter b through a new proxy.
a = NodeProxy.new;
a <-- b; a.source = { HPF.ar(b.ar, 7000) }; // pone el grupo del nodo a abajo del grupo dl nodo b
a.source = { HPF.ar(b.ar, 3000) };// changing the source
a.clear(5); b.clear(5); // vaciar a y b, pero no destruye el nodo, con fadetime 5 seg

b.play;  // b sigue siendo el nodo definido como NodeProxy.new.play;
b.class;
a.class;

