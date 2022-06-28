class DNA_S {
  float[] genes;
  float fitness;
  
  //Constructor-makes a random DNA
  DNA_S() {
    //DNA determines that size and speed of this species
    //DNA is random floating point values between 0 and 1
    genes = new float[3];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(0,1);
    }
  }
  
  DNA_S(float[] newgenes) {
    genes = newgenes;
  }
  
 

  
  DNA_S crossover(DNA_S partner) {
    float[] child = new float[genes.length];
    // Pick a midpoint
    int crossover = int(random(genes.length));
    // Take "half" from one and "half" from the other
    for (int i = 0; i < genes.length; i++) {
      if (i > crossover) child[i] = genes[i];
      else               child[i] = partner.genes[i];
    }    
    DNA_S newgenes = new DNA_S(child);
    return newgenes;
  }
  
  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
        genes[i] = random(0,1);
      }
    }
  }
}
