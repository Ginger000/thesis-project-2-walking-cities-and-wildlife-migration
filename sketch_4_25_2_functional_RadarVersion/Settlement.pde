class Settlement{
  PVector pos;
  PVector prev;
  float r;
  PVector vel;
  PVector acc;
  
  float xCore;
  float yCore;
  float rCore;
  float scope;
  float rScope;
  
  int counter;
  float fitness;
  
  DNA_S dna_S;

  Settlement(int i, float scope, float rScope, DNA_S dna_s) {
    xCore = settlementGroups[i].pos.x;
    yCore = settlementGroups[i].pos.y;
    rCore = settlementGroups[i].r;
    
    dna_S = dna_s;
    pos.x = map(dna_S.genes[0], 0, 1, xCore-scope, xCore+scope);
    pos.y = map(dna_S.genes[1], 0, 1, yCore-scope, yCore-scope);
    r = map(dna_S.genes[2], 0, 1, rCore-rScope, rCore+rScope);
    pos = new PVector(pos.x, pos.y);
    //prev = new PVector(x, y);
    vel = settlementGroups[i].vel;
    //vel.mult(random(2, 5));   
    //acc = new PVector();  
    fitness = fitness();
  }

   float fitness(){

      counter = 0;
    
      for (int i = 0; i < attractors.size(); i++) {
      
        float dd = dist(attractors.get(i).position.x, attractors.get(i).position.y, pos.x, pos.y);
        if (dd < r/10) {
          counter++;
        }
      }
      fitness = 1 - (float)counter / (float)attractors.size();
      //textSize(32);
      //text(counter, pos.x, pos.y); 
      //fill(0, 102, 153);
      return fitness;
   }
}
