/* A Particle with the movement modulated by a circle 
        all we have to do is add vertical cosine modulation to the SineParticle class */
class SineCosParticle extends SineParticle {
  float c; // Variable for the cosine
  
  SineCosParticle(PVector input) {
    super(input);
    c = 0.0; // Initialise
    version = 5; // 5th particle type
  } 
  
  // Update - same as the parent, adds cosine modulation to y velocity
  void update(PVector force, Boolean die) {
    super.update(force, die);
    c = cos(frameCount/freqOffset + phaseOffset) / ampOffset;
    
    vel.y += c;
  }
  
  // Override the draw because we want the difference to be obvious
  void draw() {
    rectMode(CENTER); // Just in case
    fill(255, 127, 0, 127); // Unique colour
    pushMatrix();  // Store matrix pos
    translate(loc.x,loc.y);// Translate
    rotate(c); // rotate by the cosine
    rect(0, 0, rad, rad);// draw square
    popMatrix(); // restore matrix
  }
}
