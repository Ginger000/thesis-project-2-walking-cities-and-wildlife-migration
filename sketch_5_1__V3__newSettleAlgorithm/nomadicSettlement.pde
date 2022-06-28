float mr = 0.01;

class NSettlement {
  PVector acceleration;
  PVector velocity;
  PVector position;
  float r;
  float maxspeedBase;
  float maxspeedNew;
  float maxforce;
  float health = 1;
  float dna[];

  NSettlement(float x, float y) {
    this(x, y, null);
  }

  NSettlement(float x, float y, float dna_[]) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, -2);
    position = new PVector(x, y);
    r = 300;
    maxspeedBase = 2;
    maxforce = 0.5;

    health = 1;

    dna = new float[4];
    if (dna_ == null) {
      // Resource weight
      dna[0] = random(-2, 2);
      // Wildlife weight
      dna[1] = random(-2, 2);
      // Resource perception
      dna[2] = random(30, 100);
      // Resource Percepton
      dna[3] = random(30, 100);
    } else {
      // Mutation
      dna[0] = dna_[0];
      if (random(1) < mr) {
        dna[0] += random(-0.1, 0.1);
      }
      dna[1] = dna_[1];
      if (random(1) < mr) {
        dna[1] += random(-0.1, 0.1);
      }
      dna[2] = dna_[2];
      if (random(1) < mr) {
        dna[2] += random(-10, 10);
      }
      dna[3] = dna_[3];
      if (random(1) < mr) {
        dna[3] += random(-10, 10);
      }
    }  
  }

  // Method to update location
  void update() {
    health -= 0.002;

    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeedNew);
    position.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

    void behaviors(List<PVector> good, List<Wildlife> bad) {
    PVector steerG = eat_food(good, 0.2, dna[2]);
    PVector steerB = eat_poison(bad, -1, dna[3]);

    steerG.mult(dna[0]);
    steerB.mult(dna[1]);

    applyForce(steerG);
    applyForce(steerB);
  }

  NSettlement clone() {
    if (random(1) < 0.002) {
      return new NSettlement(position.x, position.y, dna);
    } else {
      return null;
    }
  }

  PVector eat_food(List<PVector> list, float nutrition, float perception) {
    float record = Float.POSITIVE_INFINITY;
    PVector closest = null;
    for (int i = list.size() - 1; i >= 0; i--) {
      float d = position.dist(list.get(i));

      if (d < maxspeedNew) {
        list.remove(i);
        health += nutrition;
      } else {
        if (d < record && d < perception) {
          record = d;
          closest = list.get(i);
        }
      }
    }

    // This is the moment of eating!

    if (closest != null) {
      return seek(closest);
    }

    return new PVector(0, 0);
  }
  
  PVector eat_poison(List<Wildlife> list, float nutrition, float perception) {
    float record = Float.POSITIVE_INFINITY;
    PVector closest = null;
    for (int i = list.size() - 1; i >= 0; i--) {
      float d = position.dist(list.get(i).position);

      if (d < maxspeedNew) {
        list.remove(i);
        health += nutrition;
      } else {
        if (d < record && d < perception) {
          record = d;
          closest = list.get(i).position;
        }
      }
    }

    // This is the moment of eating!

    if (closest != null) {
      return seek(closest);
    }

    return new PVector(0, 0);
  }
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position); // A vector pointing from the location to the target

    // Scale to maximum speed
    desired.setMag(maxspeedNew);

    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce); // Limit to maximum steering force

    return steer;
    //applyForce(steer);
  }

  boolean dead() {
    return health < 0;
  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    //float angle = velocity.heading() + PI / 2;

    pushMatrix();
    translate(position.x, position.y);
    //rotate(angle);


    if (debug) {
      pushStyle();
      strokeWeight(3);
      stroke(0, 255, 0);
      noFill();
      line(0, 0, 0, -dna[0] * 25);
      strokeWeight(2);
      ellipse(0, 0, dna[2] * 2, dna[2] * 2);
      stroke(255, 0, 0);
      line(0, 0, 0, -dna[1] * 25);
      ellipse(0, 0, dna[3] * 2, dna[3] * 2);
      popStyle();
    }

    //color gr = color(0, 255, 0);
    //color rd = color(255, 0, 0);
    //color col = lerpColor(rd, gr, health);

    //fill(col);
    //stroke(col);
    //strokeWeight(1);
    //fill(150);
    //stroke(0);
    //strokeWeight(4);
    //ellipse(0, 0, r*2, r*2);
    if(health < 0.3) {
    fill(200);
    ellipse(0, 0, r/10, r/10);}
    
    /*
    //triangle shape
    beginShape();
    vertex(0, -r * 2);
    vertex(-r, r * 2);
    vertex(r, r * 2);
    endShape(CLOSE);
    */
    popMatrix();
  }


  void boundaries() {
    float d = 25;

    PVector desired = null;

    if (position.x < d) {
      desired = new PVector(maxspeedNew, velocity.y);
    } else if (position.x > width - d) {
      desired = new PVector(-maxspeedNew, velocity.y);
    }

    if (position.y < d) {
      desired = new PVector(velocity.x, maxspeedNew);
    } else if (position.y > height - d) {
      desired = new PVector(velocity.x, maxspeedNew);
    }

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeedNew);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }
};
