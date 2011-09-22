/* A class for a triangular particle which rotates depending on the input force */
class TriParticle extends Particle {
  float rot; // Will need this

  TriParticle (PVector input) {
    super(input);

    // Start randomly, won't matter anyway
    rot = random(PI);
    rad = rad*1.5; // Make a bit larger than standard, triangles have less area than circles
    life -= 30; // Last a bit less, for variety
    version = 3; // Third particle type
  } 

  void update(PVector force, Boolean die) {
    super.update(force, die);
    
    // Only one extra thing to update, get the direction of the force
    // with the heading2D() function
    rot = force.heading2D();
  }

  // Need to override the parent draw() method to produce a triangle and implement rotation
  void draw() {
    fill(255,255,137, 127);                // May as well change the colour while we're at it
    pushMatrix();                          // Store current matrix
    translate(loc.x, loc.y);               // Translate to location
    rotate(rot+PI/2);                      // Rotate, slightly offset to get a better facing angle
    triangle(0, rad, -rad/2, 0, rad/2, 0); // Draw a triangle 9not equilateral, but not bad
    popMatrix();                           // Restore matrix
  }
}

