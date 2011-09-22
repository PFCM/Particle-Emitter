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
    gravity = new PVector(0, .1);
    gravOn = true;
  }

  void update() {
    // Run through the particles, update and check the edges
    Iterator<Particle> p = particleList.iterator(); // To count for us
    
    if (gravOn) {
      gravity.y =0.1;
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
          part.vel.x *= -random(0.7, 1);// damp on reflection for realism
        } 
        if (part.loc.x < 0) {          // Check boundary, left
          part.loc.x = 1;
          part.vel.x *= -random(0.7, 1);
        }
        if (part.loc.y > height) {     // Check boundary, bottom
          part.loc.y = height-1;
          part.vel.y *= -random(0.7, 1);
          oscSendCol(part.version, (int)part.loc.x);
        }
        if (part.loc.y < 0) {          // Check boundary, top
          part.loc.y = 1;
          part.vel.y *= -random(0.7, 1);
        }
      }
    }
    Iterator<Interactor> i = interactorList.iterator();
    while(i.hasNext()) {
      Interactor inter = i.next();
       inter.update();
    }
  }

  // Actually draw the system
  void draw() {
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
  void addParticles(int amt, PVector startPos, int type) {
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

  void oscSendCol(int i, int i2) {
    OscMessage myMessage = new OscMessage("/collision"); // New message and address pattern
    myMessage.add(i); // Add input, just sending one int at time on bottom collision
    myMessage.add(i2);
    oscP5.send(myMessage, myRemoteLocation); // Send
  }
  
  void checkDirect(int x, int y) {
     Iterator<Interactor> i = interactorList.iterator(); 
     while (i.hasNext()) {
        Interactor inter = i.next();
        if (inter.mouseCheck(x,y)) {
           inter.direct(x,y);
        } 
     }
  }
}

