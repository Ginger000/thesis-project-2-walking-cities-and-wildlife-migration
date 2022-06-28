class SpeciesA {
  PVector position;
  PVector velocity;
  PVector acceleration;
  DNA_A dna_A;
  
  float energy;
  //float lifespan;
  float xoff;
  float yoff;
  
  // DNA will determine size, maxspeed, age, and genger
  float r;
  float maxSpeed;
  float maxAge;
  float birthday;
  float currentTime;
  float currentAge;
  float gender; //0.0 or 1.0
  
  float maxForce;
  
  
  

  //create a wildlife species
  SpeciesA(PVector l, DNA_A dna_a) {
    //acceleration = new PVector(random(-0.05, 0.05), random (-0.05, 0.05));
    //velocity = new PVector(random(-1, 1), random(-2, 2));
    position = l.copy();
    velocity = new PVector(random(-1,1),random(-1,1));
    acceleration = new PVector(0,0);
    maxForce = 0.05;
    energy = 255.0;
    xoff = random(1000);
    yoff = random(1000);
    dna_A = dna_a;
    r = map(dna_A.genes[0], 0, 1, 0, 15);
    maxSpeed = map(dna_A.genes[1], 0, 1, 3, 15);
    gender = map(dna_A.genes[3], 0, 1, 0, 2);
    maxAge = map(dna_A.genes[2], 0, 1, 60000, 72000);
    birthday = millis();
  }
  
  void run() {
    update();
    display();
    wrapper();
  }
  
  void flockRun(ArrayList<SpeciesA> speciesAs) {
    flock(speciesAs);
    update();
    display();
    wrapper();
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(position);
    // Scale it up by maxspeed
    desired.mult(maxSpeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    applyForce(steer);
  }
  
  void eat(SpeciesB b) {
    ArrayList<PVector> speciesBs = b.getSpeciesB();
    //Are the wildlife touching any food objects?
    for (int i = speciesBs.size() - 1; i >= 0; i--) {
      PVector speciesB_Postion = speciesBs.get(i);
      float d = PVector.dist(position, speciesB_Postion);
      if (d < r/2) {
        energy += 50;
        speciesBs.remove(i);
      }
    }
  }
  
  //create a new generation
  
  
  void aging() {
    currentTime = millis();
    currentAge = currentTime - birthday;
  }
  

  
  /*
  //perlin noise movement
  void update() {
    //simple movement based on perlin noise
    float vx = map(noise(xoff),0,1,-maxSpeed,maxSpeed);
    float vy = map(noise(yoff),0,1,-maxSpeed,maxSpeed);
    PVector velocity = new PVector(vx, vy);
    xoff += 0.01;
    yoff += 0.01;
    
    position.add(velocity);
    //velocity.add(acceleration);
    //position.add(velocity);
    
    //0.2 is daily energy consumption
    energy -= 0.2;
  }
  */
  
  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxSpeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
    //0.2 is the energy consumption for each frame
    //energy -= 0.2;
  }
  
  void wrapper() {
    if (position.x < -30*r)  position.x = width+r;
    if (position.y < -r)  position.y = height + r;
    if (position.x > width + r)  position.x = -r;
    if (position.y > height + r) position.y = -r;
  }

  
  /*
  void wrapper() {
    if (position.x < -width/2)  position.x = width+width/2;
    if (position.y < -height/2)  position.y = height + height/2;
    if (position.x > width + width/2)  position.x = -width/2;
    if (position.y > height + height/2) position.y = -height/2;
  }
  */
  void display() {
    ellipseMode(CENTER);
    stroke(0, energy);
    if(gender < 0.5) {
      fill(255, energy);
    } else {
      fill(0, energy);
    }
    
    ellipse(position.x, position.y, r, r);
  }
  
  boolean isDead() {
    if (energy < 0.0) {
      return true; //die of hunger
    } else if (currentAge >= maxAge){
      return true; //die of aging
    } else {
      return false;
    }
  }
  

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<SpeciesA> speciesAs) {
    PVector sep = separate(speciesAs);   // Separation
    PVector ali = align(speciesAs);      // Alignment
    PVector coh = cohesion(speciesAs);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxSpeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    return steer;
  }
  
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<SpeciesA> speciesAs) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (SpeciesA other : speciesAs) {
      float d = PVector.dist(position,other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position,other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<SpeciesA> speciesAs) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (SpeciesA other : speciesAs) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0,0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<SpeciesA> speciesAs) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (SpeciesA other : speciesAs) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0,0);
    }
  }
  
  
}
