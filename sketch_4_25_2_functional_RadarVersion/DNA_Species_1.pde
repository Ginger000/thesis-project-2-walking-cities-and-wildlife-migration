class DNA_A {
  
  //the genetic sequence
  //this animal has 5 genes: size, velocity, age, gengern, erengy
  float[] genes;
  
  //Constructor-makes a random DNA
  DNA_A() {
    //DNA determines that size and speed of this species
    //DNA is random floating point values between 0 and 1
    genes = new float[4];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(0,1);
      /*genes[0] = random(0,1);  // genes for maxSize
      genes[1] = random(0,1);  // genes for speed
      genes[2] = random(5,6);  // genes for age
      genes[3] = (int) random(2);  //genes for gender
      */
     
    }
  }
  
  DNA_A(float[] newgenes) {
    genes = newgenes;
  }
  
  DNA_A crossover(DNA_A partner) {
    // A new child
    DNA_A child = new DNA_A();
    int dividePoint = int(random(genes.length)); // pick a midpoint from the gene chain
    
    //Half from one parent, half from the other parent
    for (int i = 0; i < genes.length; i++) {
      if (i > dividePoint) {child.genes[i] = genes[i];}
      else {child.genes[i] = partner.genes[i];}
    }
    return child;
  }
  
  /* This is for asexual reproduction
    //this 
    DNA copy() {
    float[] newgenes = new float[genes.length];
    for (int i = 0; i < newgenes.length; i++) {
      newgenes[i] = genes [i];
    }
    return new DNA(newgenes);
  }*/
  
  //based on a mutation probability, picks a new random spot in gene array
  void mutate(float mutationRate) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < mutationRate) {
        genes[0] = random(0,1);  // genes for size
        genes[1] = random(0,1);  // genes for speed
        genes[2] = random(5,6);  // genes for age
        genes[3] = int(random(2));  //genes for gender
      }
    }
  }
}
