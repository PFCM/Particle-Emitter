/* Generic Particle class*/
class Particle {
  PVector loc, vel, acc; // We'll need these to move
  float rad, radPer;     // Radius and radius decay
  Boolean isDead;        // Well is it?
  int life, version;     // How much left, keep track of what's what

  Particle(PVector initPos) {
    loc = initPos;                                // Start at the right place
    vel = new PVector(random(-1, 1), random(-1, 1)); // Random velocity in a random direction
    acc = new PVector(random(-1, 1), random(-1, 1)); // Random acceleration in a random direction

    isDead = false;                               // I'm not dead yet
    life = (int)random(200, 250);                  // How much longer
    rad = 10;                                     // Initial radius
    radPer = rad/life;                            // How much per step for a linear decay
    version = 1;
  } 

  void update(PVector force, Boolean die) {
    acc = force;      // Acceleration is determined by input force

      loc.add(vel);     // Location increment by velocity
    vel.add(acc);     // Velocity increment by acceleration

    vel.mult(.97);    // Bit of resistance

    if (life == 0) {  // Everything has a time
      isDead = true;
    }

    if (die) {
      life--; // Countdown to the big event
      rad -= radPer;    // Shrivel
    }
  }

  void draw() {         // Kind of like outlines
    fill(255, 100);    // Basic colour for a basic particle
    ellipseMode(CENTER);// Just in case
    ellipse(loc.x, loc.y, rad, rad);// Draw
  }
}

