/* A class to act on the particles, aim is for attraction and repulsion
 inversely proportional to the square of the distance */
class Interactor {
  // Global variables
  PVector loc, vel, acc, dest;  // Vectors for vector info
  float force, rad;             // floats for the desired acting force and the radius of the image
  Boolean mouseOver;            // To check for mouseover to enable movement
  int r, g, b;                  // Colours

  Interactor(PVector startPos, float amt, int R, int G, int B) {
    loc = startPos;            // Starting location
    vel = new PVector(0, 0);   // Do not want movement
    acc = new PVector(0, 0);   //  ∆
    dest = startPos;           // ∆ ∆

    force = amt;               // set force
    rad = 30;                  // radius
    mouseOver = false;         // Default

    r = R;                     // Colours
    g = G;
    b = B;
  } 

  void update() {              
    loc.add(vel);            // Location advances by velocity
    vel.add(acc);            // Velocity adances by acceleration
    vel.limit(5);            // Top speed
    vel.mult(0.999);         // Damping


    acc = PVector.sub(dest, loc);// Set direction of acceleration
    acc.normalize();             // Normalise
    acc.mult(0.1);               // Scale
  }  

  // Function to calculate force for on a given location
  PVector influence(PVector inputLoc) {
    float distance = PVector.dist(inputLoc, loc); // Distance between particle and force

    PVector one = PVector.sub(inputLoc, loc);// Get direction (ratio of x to y)
    one.normalize();                         // Normalize 
    one.mult(-force);                        // Scale to give desired force (negative to make a positive input attraction)



    return PVector.div(one, (distance*distance));// Return the forceover the square of the distance
  }

  void direct(int x, int y) {
    dest.set(x, y, 0);// Get the ball rolling, as it were
  }

  void draw() {
    ellipseMode(CENTER);             // Just checking
    fill(r, g, b, 127);                   // Color
    ellipse(loc.x, loc.y, rad, rad); // Draw the thing
  }

// Function to check if the mouse is over
  Boolean mouseCheck(int x, int y) { // easier to input x and y than a PVector
    PVector mouse = new PVector(x, y);// When we can just make one here

    if (dist(mouse.x, mouse.y, loc.x, loc.y) < rad) { // If the distance between the input
      mouseOver = true;                               // and the centre is less than the
      return true;                                    // radius, the input is over the circle
    } 
    else {
      return false; // If it isn't it isn't
    }
  }
}

