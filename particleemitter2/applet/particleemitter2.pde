// Particle emitter, Paul Mathews

//things to do - arraylist for interactors, add and remove them automatically/on input

import oscP5.*;  // Import OSC and net libraries
import netP5.*;

ParticleSystem particleController; // Instance of the system


void setup() {
  size(screen.width, screen.height);    // Size
  smooth();          // Anti-aliasing
  frameRate(25);     // Sensible frame rate

  particleController = new ParticleSystem();// All systems are go
}



// Actually loop
void draw() {
  background(0); // Background
  
  // We want add to loop with draw
  if (mousePressed) {
    click(mouseX, mouseY);
  }

  update();// Make sure things update
}

// Function to update and draw
void update() {
  particleController.update();
  particleController.draw();
}

// Funtion to deal with mouse input
void click(int x, int y) {
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

void mousePressed() {
  if (keyPressed && key == 'w') {
    particleController.checkDirect(mouseX, mouseY);
  }
}

void mouseDragged() {
  if (keyPressed && key == 'w') {
    particleController.checkDirect(mouseX, mouseY);
  }
}

// Reset the interactor mouseOvers just in case
void mouseReleased() {
  Iterator<Interactor> i = particleController.interactorList.iterator();
  while(i.hasNext()) {
    i.next().mouseOver = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    if (particleController.gravOn) {
      particleController.gravOn = false;
    } 
    else if (!particleController.gravOn) {
      particleController.gravOn = true;
    }
  }
}

