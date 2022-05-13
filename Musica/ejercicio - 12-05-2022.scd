

Server.allRunningServers;

s.boot;

Server.allRunningServers; // que server está corriendo

// Node Proxy

s.meter; s.

p = NodeProxy.new;

p.numChannels;

p.clear;

p.numChannels;

p.source = { RLPF.ar(Dust.ar([12,15]), LFNoise1.ar(1/[3, 4], 1500, 1600), 0.02)};

p.play



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


// supercollider + processing

/// basado en http://gewhere.github.io/sc3-to-processing-via-osc

//// código para processing:
/*
import oscP5.*;
import netP5.*;
OscP5 oscP5;

float x; // global variable

void setup() {
  size(400, 300);
  frameRate(24);
  background(0);
  smooth();

  OscProperties properties = new OscProperties();
  properties.setListeningPort(47120); // osc receive port (from sc)
  oscP5 = new OscP5(this, properties);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/sc3p5")) {
    x = msg.get(0).floatValue(); // receive floats from sc
  }
}

void draw() {
  background(x, x, x);
  println("POST: ", x);
  // draw rect
  stroke(256-x/2, 256-x*abs(sin(x)), 256-x/4);
  strokeWeight(4);
  fill(256-x/2, 256-x, 256-x*abs(sin(x)));
  translate(width/2, height/2);
  rotate(x%64);
  rect(x%64, x%64, x*abs(sin(x))%128, x*abs(sin(x))%128, 6);
}
*/

//// código para sc:

s.boot;

n = NetAddr("127.0.0.1", 47120);  // open 47120 on localhost server

(
SynthDef(\blip, { | freq = 440, amp = 0.85, att = 0.01, rel = 0.06, ffreq = 1000 |
    var sig, env, lfo;
    sig = SinOsc.ar(freq, 0, amp);
    env = EnvGen.ar(Env.perc(att, rel), doneAction:2);
    lfo = SinOsc.kr(rel * ffreq);

    Out.ar(0, Pan2.ar(RHPF.ar(sig*env, ffreq), SinOsc.kr(211*lfo)))
}).add;
)

Synth(\blip);

(
f = fork {
    loop {
        256 do: { |i|
            n.sendMsg("/sc3p5", i.asFloat); // send OSC message to P5
            Synth(\blip, [\freq, 440+i, \ffreq, 1000+i*2]);
            ((i+1).reciprocal*2).wait;
        }
    }
};
)

f.stop;

s.quit;

