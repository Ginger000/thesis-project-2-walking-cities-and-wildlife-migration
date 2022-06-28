//This class is the population of each settlementGroup

class Population {
  float mutationRate;           // Mutation rate
  ArrayList<Settlement> matingPool;    // ArrayList which we will use for our "mating pool"
  int generations;              // Number of generations
  boolean finished;             // Are we finished evolving?
  int perfectCounter;
  ArrayList<Settlement> settlements;
  float scope = 30;
  float rScope = 20;
  
  Population(float m, int num) {
    mutationRate = m;
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < num; j++) {
        DNA_S dna_S = new DNA_S();
        settlements.add(new Settlement(3, scope, rScope, dna_S));
      }
    }
    
    calcFitness();
    matingPool = new ArrayList<Settlement>();
    finished = false;
    generations = 0;
    
    perfectCounter = 0;
  }
  
  void calcFitness(){
    for (int i = 0; i < settlements.size(); i++) {
      settlements.get(i).fitness();
    }
  }
  
  void generateMatingPool(){
    matingPool.clear();
    float maxFitness = 0;
    for (int i = 0; i < settlements.size(); i++){
      if (settlements.get(i).fitness > maxFitness) {
        maxFitness = settlements.get(i).fitness;
      }
    }
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // a higher fitness = more entries to mating pool = more likely to be picked as a parent
    // a lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < settlements.size(); i++) {
      
      float fitness = map(settlements.get(i).fitness,0,maxFitness,0,1);
      int n = int(fitness * 100);  // Arbitrary multiplier, we can also use monte carlo method
      for (int j = 0; j < n; j++) {              // and pick two random numbers
        matingPool.add(settlements.get(i));
      }
    }
  }
  
  // Create a new generation
  void generate() {
    // Refill the population with children from the mating pool
    for (int i = 0; i < settlements.size(); i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));
      DNA_S partnerA = matingPool.get(a).dna_S;
      DNA_S partnerB = matingPool.get(b).dna_S;
      DNA_S child = partnerA.crossover(partnerB);
      child.mutate(mutationRate);
      settlements.get(i).dna_S = child;
    }
    generations++;
  }
  
  // Compute the current "most fit" member of the population
  Settlement getBest() {
    float worldrecord = 0.0;
    int index = 0;
    for (int i = 0; i < settlements.size(); i++) {
      if (settlements.get(i).fitness > worldrecord) {
        index = i;
        worldrecord = settlements.get(i).fitness;
      }
    }
    
    if (worldrecord == perfectCounter) finished = true;
    return settlements.get(index);
  }

  boolean finished() {
    return finished;
  }

  int getGenerations() {
    return generations;
  }
}
