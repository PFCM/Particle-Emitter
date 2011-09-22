import processing.core.*; 
import processing.xml.*; 

import oscP5.*; 
import netP5.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class particleemitter2 extends PApplet {

// Particle emitter, Paul Mathews

//things to do - arraylist for interactors, add and remove them automatically/on input

  // Import OSC and net libraries


ParticleSystem particleController; // Instance of the system


public void setup() {
  size(screen.width, screen.height);    // Size
  smooth();          // Anti-aliasing
  frameRate(25);     // Sensible frame rate

  particleController = new ParticleSystem();// All systems are go
}



// Actually loop
public void draw() {
  background(0); // Background
  
  // We want add to loop with draw
  if (mousePressed) {
    click(mouseX, mouseY);
  }

  update();// Make sure things update
}

// Function to update and draw
public void update() {
  particleController.update();
  particleController.draw();
}

// Funtion to deal with mouse input
public void click(int x, int y) {
  PVector mouse = new PVector(mouseX, mouseY); // save some typing

  // If a key is pressed and mouse is clicked
  if (keyPressed) {
    switch(key) { // easier than a lot of ifs
      // Add standard particles
    case 'p':
      particleController.addParticles(2, new PVector(x, y), 0);
      break;
      // Add fast particles
    case 'f':
      particleController.addParticles(2, new PVector(x, y), 1);
      break;
      // Add triangle particles
    case 't':
      particleController.addParticles(2, new PVector(x, y), 2);
      break;
      // Add sine wave modulated square particles
    case 's':
      particleController.addParticles(2, new PVector(x, y), 3);
      break;
      // Add circle modulated square particles
    case 'c':
      particleController.addParticles(2, new PVector(x, y), 4);
      break;
    case 'w':
    // do nothing
      break;

      // In case a different key pushed
    default:
      particleController.addParticles(2, new PVector(x, y), frameCount%5);
      break;
    }
  } 
  // If no key
  else if (!keyPressed) {
    // Run through all the types of particles, one type per frame
    int type = frameCount%5;  // Modulo with the number of particle
    particleController.addParticles(2, new PVector(x, y), type);// And make some more
  }
}

public void mousePressed() {
  if (keyPressed && key == 'w') {
    particleController.checkDirect(mouseX, mouseY);
  }
}

public void mouseDragged() {
  if (keyPressed && key == 'w') {
    particleController.checkDirect(mouseX, mouseY);
  }
}

// Reset the interactor mouseOvers just in case
public void mouseReleased() {
  Iterator<Interactor> i = particleController.interactorList.iterator();
  while(i.hasNext()) {
    i.next().mouseOver = false;
  }
}

public void keyPressed() {
  if (key == ' ') {
    if (particleController.gravOn) {
      particleController.gravOn = false;
    } 
    else if (!particleController.gravOn) {
      particleController.gravOn = true;
    }
  }
}

/* A faster particle which doesn't last as long */
class FastParticle extends Particle { // May as well reuse what we wrote earlier

  FastParticle(PVector input) {
    super(input); // Run the normal one
    life /= 2;    // But with less life
    version = 2; // set version
  } 

  public void update(PVector force, Boolean die) {
    super.update(force, die); 
    vel.mult(1.03f);  //faster
  }

  // Override the draw so we can tell them apart better
  public void draw() {
    ellipseMode(CENTER); // Just in case
    fill(0, 255, 255, 127);   // Different colour to the basic
    ellipse(loc.x, loc.y, 2*rad/3, 2*rad/3);// Draw, 2/3rds size
  }
}
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
    acc = new PVector(0, 0);   //  \u2206
    dest = startPos;           // \u2206 \u2206

    force = amt;               // set force
    rad = 30;                  // radius
    mouseOver = false;         // Default

    r = R;                     // Colours
    g = G;
    b = B;
  } 

  public void update() {              
    loc.add(vel);            // Location advances by velocity
    vel.add(acc);            // Velocity adances by acceleration
    vel.limit(5);            // Top speed
    vel.mult(0.999f);         // Damping


    acc = PVector.sub(dest, loc);// Set direction of acceleration
    acc.normalize();             // Normalise
    acc.mult(0.1f);               // Scale
  }  

  // Function to calculate force for on a given location
  public PVector influence(PVector inputLoc) {
    float distance = PVector.dist(inputLoc, loc); // Distance between particle and force

    PVector one = PVector.sub(inputLoc, loc);// Get direction (ratio of x to y)
    one.normalize();                         // Normalize 
    one.mult(-force);                        // Scale to give desired force (negative to make a positive input attraction)



    return PVector.div(one, (distance*distance));// Return the forceover the square of the distance
  }

  public void direct(int x, int y) {
    dest.set(x, y, 0);// Get the ball rolling, as it were
  }

  public void draw() {
    ellipseMode(CENTER);             // Just checking
    fill(r, g, b, 127);                   // Color
    ellipse(loc.x, loc.y, rad, rad); // Draw the thing
  }

// Function to check if the mouse is over
  public Boolean mouseCheck(int x, int y) { // easier to input x and y than a PVector
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

  public void update(PVector force, Boolean die) {
    acc = force;      // Acceleration is determined by input force

      loc.add(vel);     // Location increment by velocity
    vel.add(acc);     // Velocity increment by acceleration

    vel.mult(.97f);    // Bit of resistance

    if (life == 0) {  // Everything has a time
      isDead = true;
    }

    if (die) {
      life--; // Countdown to the big event
      rad -= radPer;    // Shrivel
    }
  }

  public void draw() {         // Kind of like outlines
    fill(255, 100);    // Basic colour for a basic particle
    ellipseMode(CENTER);// Just in case
    ellipse(loc.x, loc.y, rad, rad);// Draw
  }
}

/* A class to manage our particles */
class ParticleSystem {
  ArrayList<Particle> particleList = new ArrayList<Particle>(); // Arraylist for the particles
  ArrayList<Interactor> interactorList = new ArrayList<Interactor>();// ArrayList for the interactors
  
  
  PVector gravity;  // Unavoidable really
  Boolean gravOn;

  // Will send osc from here as want direct access to the particles
  OscP5 oscP5;  // Set up osc
  NetAddress myRemoteLocation;
  
  ParticleSystem() {
    // Construct the initial interactors, one with a positive force one with a negative
    interactorList.add(new Interactor(new PVector(width/2+100, height/2), 100, 0, 0, 255));
    interactorList.add(new Interactor(new PVector(width/2-100, height/2), -100, 0, 255, 0));
    interactorList.add(new Interactor(new PVector(width/2+200, height/2), 100, 255, 0, 255));
    interactorList.add(new Interactor(new PVector(width/2-200, height/2), -100, 0, 255, 255));

    oscP5 = new OscP5(this, 12001); // Initialise OSC, give it a listen port
    myRemoteLocation = new NetAddress("127.0.0.1", 12000); // Init send

    // Gravity
    gravity = new PVector(0, .1f);
    gravOn = true;
  }

  public void update() {
    // Run through the particles, update and check the edges
    Iterator<Particle> p = particleList.iterator(); // To count for us
    
    if (gravOn) {
      gravity.y =0.1f;
    } else {
      gravity.y = 0;
    }

    while (p.hasNext()) { // and we're off
      Particle part = p.next();// set up the next

        if (part.isDead) { // No point keeping the dead around
        p.remove();
      } 
      // But for the living
      else {
        // Add up the forces to act on this particle
        PVector aggregate = new PVector(0,0);
        Iterator<Interactor> i = interactorList.iterator();
        while (i.hasNext()) {
           aggregate.add(i.next().influence(part.loc)); 
        }
        
        // Update it
        part.update(PVector.add(aggregate, gravity), gravOn);

        // Finally, check if we need to reflect
        if (part.loc.x > width) {      // Check boundary, right
          part.loc.x = width-1;  // Reset, helps avoid bugs at high velocities
          part.vel.x *= -random(0.7f, 1);// damp on reflection for realism
        } 
        if (part.loc.x < 0) {          // Check boundary, left
          part.loc.x = 1;
          part.vel.x *= -random(0.7f, 1);
        }
        if (part.loc.y > height) {     // Check boundary, bottom
          part.loc.y = height-1;
          part.vel.y *= -random(0.7f, 1);
          oscSendCol(part.version, (int)part.loc.x);
        }
        if (part.loc.y < 0) {          // Check boundary, top
          part.loc.y = 1;
          part.vel.y *= -random(0.7f, 1);
        }
      }
    }
    Iterator<Interactor> i = interactorList.iterator();
    while(i.hasNext()) {
       i.next().update(); 
    }
  }

  // Actually draw the system
  public void draw() {
    Iterator<Interactor> i = interactorList.iterator();
    while(i.hasNext()) {
       i.next().draw(); 
    }
    Iterator<Particle> p = particleList.iterator();  // Another iterator, to iterate throught the list
    while (p.hasNext()) { // Run through list
      p.next().draw();     // and draw this time
    }
  }

  // Function to add particles to the list
  //        takes amount, starting location and type of particle (as an int)
  public void addParticles(int amt, PVector startPos, int type) {
    // Do it the amount of times specified
    for (int i = 0; i < amt; i++) {
      // store a random offset for each one
      PVector rand = new PVector(random(10), random(10));

      // Easier than a lot of if else
      switch(type) {
        // Standard particles
      case 0:
        particleList.add(new Particle(PVector.add(startPos, rand)));
        break;
        // Fast Particles  
      case 1:
        particleList.add(new FastParticle(PVector.add(startPos, rand)));
        break;
        // Triangles
      case 2:
        particleList.add(new TriParticle(PVector.add(startPos, rand)));
        break;
        // Wavy Squares
      case 3:
        particleList.add(new SineParticle(PVector.add(startPos, rand)));
        break;
        // Fluttery Squares
      case 4:
        particleList.add(new SineCosParticle(PVector.add(startPos, rand)));
        break;
        // In case something goes wrong, just add basic ones
      default:
        particleList.add(new Particle(PVector.add(startPos, rand)));
        break;
      }
    }
  }

  public void oscSendCol(int i, int i2) {
    OscMessage myMessage = new OscMessage("/collision"); // New message and address pattern
    myMessage.add(i); // Add input, just sending one int at time on bottom collision
    myMessage.add(i2);
    oscP5.send(myMessage, myRemoteLocation); // Send
  }
  
  public void checkDirect(int x, int y) {
     Iterator<Interactor> i = interactorList.iterator(); 
     while (i.hasNext()) {
        Interactor inter = i.next();
        if (inter.mouseCheck(x,y)) {
           inter.direct(x,y);
        } 
     }
  }
}

/* A Particle with the movement modulated by a circle 
        all we have to do is add vertical cosine modulation to the SineParticle class */
class SineCosParticle extends SineParticle {
  float c; // Variable for the cosine
  
  SineCosParticle(PVector input) {
    super(input);
    c = 0.0f; // Initialise
    version = 5; // 5th particle type
  } 
  
  // Update - same as the parent, adds cosine modulation to y velocity
  public void update(PVector force, Boolean die) {
    super.update(force, die);
    c = cos(frameCount/freqOffset + phaseOffset) / ampOffset;
    
    vel.y += c;
  }
  
  // Override the draw because we want the difference to be obvious
  public void draw() {
    rectMode(CENTER); // Just in case
    fill(255, 127, 0, 127); // Unique colour
    pushMatrix();  // Store matrix pos
    translate(loc.x,loc.y);// Translate
    rotate(c); // rotate by the cosine
    rect(0, 0, rad, rad);// draw square
    popMatrix(); // restore matrix
  }
}
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
    s = 0.0f;   // This will store the sin info to reuse in the rotation for a nicer effect
    version = 4; // 4th particle type
  } 

  public void update(PVector force, Boolean die) {
    super.update(force, die);
    
    // Same as usual plus sine wave modulation of velocity's x component
    s = sin(frameCount/freqOffset + phaseOffset) / ampOffset;
    vel.x += s;
  }

  // Override the draw for a more unique experience
  public void draw() {
    rectMode(CENTER);        // Just in case
    fill(255, 0, 150, 127);  // Colour is important
    pushMatrix();            // Store starting matrix
    translate(loc.x,loc.y);  // Translate to location
    rotate(s);               // Rotate by the sine, gives a fluttery effect
    rect(0, 0, rad, rad);    // Draw the rectangle
    popMatrix();             // Put everything back the way it was
  }
}

/* A class for a triangular particle which rotates depending on the input force */
class TriParticle extends Particle {
  float rot; // Will need this

  TriParticle (PVector input) {
    super(input);

    // Start randomly, won't matter anyway
    rot = random(PI);
    rad = rad*1.5f; // Make a bit larger than standard, triangles have less area than circles
    life -= 30; // Last a bit less, for variety
    version = 3; // Third particle type
  } 

  public void update(PVector force, Boolean die) {
    super.update(force, die);
    
    // Only one extra thing to update, get the direction of the force
    // with the heading2D() function
    rot = force.heading2D();
  }

  // Need to override the parent draw() method to produce a triangle and implement rotation
  public void draw() {
    fill(255,255,137, 127);                // May as well change the colour while we're at it
    pushMatrix();                          // Store current matrix
    translate(loc.x, loc.y);               // Translate to location
    rotate(rot+PI/2);                      // Rotate, slightly offset to get a better facing angle
    triangle(0, rad, -rad/2, 0, rad/2, 0); // Draw a triangle 9not equilateral, but not bad
    popMatrix();                           // Restore matrix
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "particleemitter2" });
  }
}
