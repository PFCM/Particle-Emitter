/* Basic Drum machine 
   uses samples from an Electro-Harmonix DRM 16 */

OscRecv recv;              // Osc receiver
12000 => recv.port;        // Receive port
recv.listen();             // Get listening
recv.event("/collision, i") @=> OscEvent collisionEvent;// Set up event

JCRev r => dac; // Common reverb for all files
0.01 => r.mix;  // reverb mix

// Set up files for samples (too lazy to synthesise drums, maybe another time)
"data/HIHAT.wav" => string hihatFile;
"data/HIHAT2.wav" => string hihat2File;
"data/HIHAT3.wav" => string hihat3File;
"data/SNARE.wav" => string snareFile;
"data/KICK.wav" => string kickFile;

// Poller
fun void poller() {
    while (true) {
        collisionEvent => now; // Wait for messages
        if (collisionEvent.nextMsg() != 0) { // When they come and aren't null
            collisionEvent.getInt() => int type; // Store
            spork ~ noise(type);// Use
        }
    }
}

// Grouping function
fun void noise(int type) {
    if (type == 1) {
        kick(Math.rand2f(.4,.6));
    }
    if (type == 2) {
        hihat(Math.rand2f(.3,.5));
    }
    if (type == 3) {
        snare(Math.rand2f(.4,.6));
    }
    if (type == 4) {
        hihat2(Math.rand2f(.3,.5));
    }
    if (type == 5) {
        hihat3(Math.rand2f(.3,.5));
    }
}

// Play kick (quite high, wanted all the samples to occupy similar space as all the particles occupy similar space)
fun void kick(float f) {
    SndBuf s => r;
    kickFile => s.read;
    f => s.gain;
    Math.rand2f(5,7) => s.rate;
    s.samples()::samp => now;
}

// hihat 1
fun void hihat(float f) {
    SndBuf s => r;
    hihatFile => s.read;
    f => s.gain;
    Math.rand2f(.9,1.1) => s.rate;
    s.samples()::samp => now;
}

// hihat 2, actually a clap
fun void hihat2(float f) {
    SndBuf s => r;
    hihat2File => s.read;
    f => s.gain;
    Math.rand2f(.9,1.1) => s.rate;
    s.samples()::samp => now;
}

// hihat 3, low, mapped to least predictable particle
fun void hihat3(float f) {
    SndBuf s => r;
    hihat3File => s.read;
    f/2 => s.gain;
    Math.rand2f(.2,.3) => s.rate;
    s.samples()::samp => now;
}

// snare
fun void snare(float f) {
    SndBuf s => r;
    snareFile => s.read;
    f => s.gain;
    Math.rand2f(.9,3.1) => s.rate;
    s.samples()::samp => now;
}

// start the polling
spork ~ poller();

// Please don't leave me
while (true) {
    1::second => now;
}