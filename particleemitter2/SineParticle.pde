/* A particle that floats around a bit on the way down
  achieved by modulating the horizontal veloity with a sin function */
class SineParticle extends Particle {
  float phaseOffset, ampOffset, freqOffset, s; // Give each instance a unique period, amplitude and phase
  
  SineParticle(PVector input) {
    super(input);
    
    // In addition to standard things
    phaseOffset = random(TWO_PI);  // Randomise phase between 0 and 360 degress
    ampOffset = random(4,8);       // Randomise amplitude by some numbers that seem to work
    freqOffset = random(8,15);     // Same with frequency, not too fast, not too slow
    s = 0.0;   // This will store the sin info to reuse in the rotation for a nicer effect
    version = 4; // 4th particle type
  } 

  void update(PVector force, Boolean die) {
    super.update(force, die);
    
    // Same as usual plus sine wave modulation of velocity's x component
    s = sin(frameCount/freqOffset + phaseOffset) / ampOffset;
    vel.x += s;
  }

  // Override the draw for a more unique experience
  void draw() {
    rectMode(CENTER);        // Just in case
    fill(255, 0, 150, 127);  // Colour is important
    pushMatrix();            // Store starting matrix
    translate(loc.x,loc.y);  // Translate to location
    rotate(s);               // Rotate by the sine, gives a fluttery effect
    rect(0, 0, rad, rad);    // Draw the rectangle
    popMatrix();             // Put everything back the way it was
  }
}

