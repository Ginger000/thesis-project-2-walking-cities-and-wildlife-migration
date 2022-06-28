import java.util.ArrayList;

class World {
  
  float mutationRateA;
  float birthRateA;
  int initialSpeciesAsNum;
  int initialSpeciesBsNum;
  ArrayList<SpeciesA> speciesAs;
  
  SpeciesB speciesBs;
  
  DNA_A selfGene;
  DNA_A potentialPartnerGene;
  DNA_A childGene;
  PVector selfPosition;
  
  // Using this variable to decide whether to draw all the stuff
  boolean debug = true;

  // Flowfield object
  FlowField flowfield;
  
  
  World(int numA, int numB, float m, float b) {
    mutationRateA = m;
    birthRateA = b;
    initialSpeciesAsNum = numA;
    initialSpeciesBsNum = numB;
    speciesBs = new SpeciesB(numB);
    speciesAs = new ArrayList<SpeciesA>();
     
    for (int i = 0; i < numA; i++) {
      PVector l = new PVector(random(width),random(height));
      DNA_A dna_A = new DNA_A();
      speciesAs.add(new SpeciesA(l, dna_A));
    }
    
    flowfield = new FlowField(60);
    
  }
  
  // Make a new speciesA, probably by human intervention
  void born(float x, float y) {
    PVector l = new PVector(x, y);
    DNA_A dna_A = new DNA_A();
    speciesAs.add(new SpeciesA(l, dna_A));
  }
  
  /*
  //Try to use a concise way to write this loop
  SpeciesA reproduction(ArrayList<SpeciesA> speciesAs) {
    for (SpeciesA other : speciesAs) {
      
        float d = PVector.dist(speciesA.position, other.position);
        
        if (d < r && d != 0 && random(1) < birthRateA) {
          
          childGene.mutate(mutationRateA);
          
          if ((gender > 1 && other.gender <= 1) || (gender < 1 && other.gender >= 1)) {
            
            childGene = dna_A.crossover(other.dna_A);
            childGene.mutate(mutationRateA); 
            return new SpeciesA(selfPosition, childGene);
          } else {return null;}
        }
      }
          return null;
    }
  */

  SpeciesA reproduction() {
    for (int i = speciesAs.size() - 1; i >= 0; i--) {
      SpeciesA self = speciesAs.get(i);
      selfPosition = self.position;
      for (int j = speciesAs.size() - 1; j >= 0; j--) {
        SpeciesA potentialPartner = speciesAs.get(j);
        PVector potentialPartnerPosition = potentialPartner.position;
        float d = PVector.dist(selfPosition, potentialPartnerPosition);
        selfGene = self.dna_A;
        potentialPartnerGene = potentialPartner.dna_A;
        if (d < 2* self.r && d != 0 /*&& random(1) < birthRateA*/) {
          childGene = selfGene.crossover(potentialPartnerGene);
          childGene.mutate(mutationRateA);
          //(self.gender >= 0.5 && potentialPartner.gender < 0.5))
          //random(1) < birthRateA
          if ((self.gender > 1 && potentialPartner.gender <= 1) || (self.gender < 1 && potentialPartner.gender >= 1)) {
            
            childGene = selfGene.crossover(potentialPartnerGene);
            childGene.mutate(mutationRateA); 
            return new SpeciesA(selfPosition, childGene);
          } else {return null;}
        }
      }
    }
    return null;
  }
  
  void run() {
    //speciesBs.run();
    for (int i = speciesAs.size()-1; i >- 0; i--) {
      SpeciesA a = speciesAs.get(i);
      
      
      // Tell all the vehicles to follow the flow field
      a.follow(flowfield);
      a.run();

      //a.eat(speciesBs);
      if (a.isDead()) {
        speciesAs.remove(i);
        speciesBs.add(a.position);
      }
    }
  }
  
  void magFieldDisplay() {
    if (debug) flowfield.display();
  }
  void invisibleField(){
    if (key == ' ') {
    debug = !debug;
    }
  }
  
  void newField(){
    if (key == 'n') {
    flowfield.init();
    }  
  }

}
