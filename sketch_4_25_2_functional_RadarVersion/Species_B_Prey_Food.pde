class SpeciesB {
  
  ArrayList<PVector> speciesBs;
  
  SpeciesB(int num) {
    speciesBs = new ArrayList();
    for (int i = 0; i < num; i++) {
      speciesBs.add(new PVector(random(width),random(height)));
    }
  }
  
  //add some food at a position
  void add(PVector l) {
    speciesBs.add(l.copy());
  }
  
  //Display the food
  void run() {
    for (PVector b:speciesBs) {
      rectMode(CENTER);
      stroke(0);
      fill(175);
      rect(b.x, b.y, 8, 8);
    }
    
    //There's a small chance food will appear randomly
    if (random(1) < 0.01) {
      speciesBs.add(new PVector(random(width), random(height)));
    }
    
  }
  
  //return the list of food
  ArrayList getSpeciesB() {
    return speciesBs;
  }
}
