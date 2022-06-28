World world;
ArrayList<SpeciesA> attractors;

SettlementGroup[] settlementGroups = new SettlementGroup[6];

int skip;//smartGrid


//int lowestRadarScoreIndex;

//The force between the existing location of the settlement and the location of one lowestScoreRadar
PVector acceleration;


void setup() {
  size(1560, 960);
  world = new World(20, 20, 0.01, 0.3);
  attractors = world.speciesAs;
  smooth();
  for (int i = 0; i < settlementGroups.length; i++) {
    settlementGroups[i] = new SettlementGroup(random(width), random(height));
  }
  acceleration = new PVector(0,0);
}

void draw() {
  background(51);
  

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (SettlementGroup s : settlementGroups) {
        float d = dist(x, y, s.pos.x, s.pos.y);
        sum += 10 * s.r / d;
      }
      
      pixels[index] = color(sum, 204, 101);
    }
  }

  updatePixels();
  
 
  
  
  
  //calculateOverlap();
  //this is a array of the counter of passing animals for each settlement
  int[] counter = new int[settlementGroups.length];
  //for (SettlementGroup s : settlementGroups) {
    //s.update();
    //b.show();
    
  for (int i = 0; i < settlementGroups.length; i++) {
    
      
      //settlementGroups[i].applyForce(f);
    counter[i] = 0;
      //calculate the wildlife number passing through the settlement
    for (int j = 0; j < attractors.size(); j++) {
      
      float dd = dist(attractors.get(j).position.x, attractors.get(j).position.y, settlementGroups[i].pos.x, settlementGroups[i].pos.y);
      if (dd < settlementGroups[i].r/20) {
        counter[i]++;
      }
    }
    textSize(32);
    text(counter[i], settlementGroups[i].pos.x, settlementGroups[i].pos.y); 
    fill(0, 102, 153);


      int centerScore = counter[i];
      //println(lowestScore);
      //float xLowest = settlementGroups[i].pos.x;
      //float yLowest = settlementGroups[i].pos.y;
      //PVector lowestScorePosition = new PVector(xLowest, yLowest);
      //float xLowestRadar = 0;  //just for initialization // it's okay that it's just = 0
      //float yLowestRadar = 0;
      //PVector lowestScoreRadarPosition = new PVector(xLowestRadar, yLowestRadar);
      //lowestRadarScore = attractors.size();
      
      //calculate the wildlife number passing through the peripheral sensors
      

      for (int j = 0; j < settlementGroups[i].radarNum; j++) {
        float xNew = 0;
        float yNew = 0;
        PVector force0 = new PVector(0,0);
        PVector force1 = new PVector(0,0);
        PVector force2 = new PVector(0,0);
        PVector force3 = new PVector(0,0);
        if (j == 0) {
                      xNew = settlementGroups[i].pos.x; 
                      yNew = settlementGroups[i].pos.y - settlementGroups[i].r/20;
                      //force0 = new PVector(xNew - settlementGroups[i].pos.x, yNew - settlementGroups[i].pos.y);
                      force0 = new PVector(settlementGroups[i].pos.x - xNew, settlementGroups[i].pos.y - yNew);
                      force0.setMag(abs(counter[i] - settlementGroups[i].radarCounter[j]));
                      //println(force0);
                    }
        if (j == 1) {
                      xNew = settlementGroups[i].pos.x + settlementGroups[i].r/20; 
                      yNew = settlementGroups[i].pos.y;
                      //force1 = new PVector(xNew - settlementGroups[i].pos.x, yNew - settlementGroups[i].pos.y);
                      force1 = new PVector(settlementGroups[i].pos.x - xNew, settlementGroups[i].pos.y - yNew);
                      force1.setMag(abs(counter[i] - settlementGroups[i].radarCounter[j]));
                      println(force1);
                    }
        if (j == 2) {
                      xNew = settlementGroups[i].pos.x; 
                      yNew = settlementGroups[i].pos.y + settlementGroups[i].r/20;
                      //force2 = new PVector(xNew - settlementGroups[i].pos.x, yNew - settlementGroups[i].pos.y);
                      force2 = new PVector(settlementGroups[i].pos.x - xNew, settlementGroups[i].pos.y - yNew);
                      force2.setMag(abs(counter[i] - settlementGroups[i].radarCounter[j]));
                      //println(force2);
                    }
        if (j == 3) {
                      xNew = settlementGroups[i].pos.x - settlementGroups[i].r/20; 
                      yNew = settlementGroups[i].pos.y;
                      //force3 = new PVector(xNew - settlementGroups[i].pos.x, yNew - settlementGroups[i].pos.y);
                      force3 = new PVector(settlementGroups[i].pos.x - xNew, settlementGroups[i].pos.y - yNew);
                      force3.setMag(abs(counter[i] - settlementGroups[i].radarCounter[j]));
                      //println(force3);
                    }
                    
        textSize(32);
        text(settlementGroups[i].radarCounter[j], xNew, yNew); 
        fill(0, 102, 153);
        
        acceleration = force0.add(force2).add(force1).add(force3);
        settlementGroups[i].applyForce(acceleration);
        settlementGroups[i].update();
        //acceleration = force0.add(force1).add(force2).add(force3);
        //println(acceleration);
        
        /*
      
        if(settlementGroups[i].radarCounter[j] < lowestRadarScore) {
          lowestRadarScore = settlementGroups[i].radarCounter[j];
          lowestRadarScoreIndex = j;
          
          xLowestRadar = xNew;
          yLowestRadar = yNew;
          //if (j == 0) {xLowestRadar = settlementGroups[i].pos.x; yLowestRadar = settlementGroups[i].pos.y - settlementGroups[i].r/20;}
          //if (j == 1) {xLowestRadar = settlementGroups[i].pos.x + settlementGroups[i].r/20; yLowestRadar = settlementGroups[i].pos.y;}
          //if (j == 2) {xLowestRadar = settlementGroups[i].pos.x; yLowestRadar = settlementGroups[i].pos.y + settlementGroups[i].r/20;}
          //if (j == 3) {xLowestRadar = settlementGroups[i].pos.x - settlementGroups[i].r/20; yLowestRadar = settlementGroups[i].pos.y;}
           
          //println(lowestRadarScoreIndex);
        } 
        */
      }

      /*
      //calculate the acceleration by using the lowestRadarScore
      if(settlementGroups[i].lowestRadarScore < centerScore) {
        acceleration = settlementGroups[i].lowestScoreRadarPosition.sub(settlementGroups[i].pos);
        acceleration = acceleration.mult(20);
        //acceleration = settlementGroups[i].pos.sub(lowestScoreRadarPosition);
        //println(acceleration.x, "  ", acceleration.y);
      } 
      */

/*      
      else {
        acceleration = settlementGroups[i].pos.sub(settlementGroups[i].pos);
      }
*/      
      //calculate the acceleration between the settlement center and the sensors with lowest score.
      
      //println(acceleration.x, "  ", acceleration.y);
      //println(acceleration.y);
      
    //println(lowestRadarScore);
    }
    

  
  world.run();
  //world.reproduction();
  //repulsion();
  world.magFieldDisplay();  
}

void calculateOverlap() {
  int[] counter = new int[settlementGroups.length];
  for (int j = 0; j < settlementGroups.length; j++) {
    counter[j] = 0;
    
    for (int i = 0; i < attractors.size(); i++) {
      
      float dd = dist(attractors.get(i).position.x, attractors.get(i).position.y, settlementGroups[j].pos.x, settlementGroups[j].pos.y);
      if (dd < settlementGroups[j].r/20) {
        counter[j]++;
      }
    }
    textSize(32);
    text(counter[j], settlementGroups[j].pos.x, settlementGroups[j].pos.y); 
    fill(0, 102, 153);
    
    int lowestScore = counter[j];
    //println(lowestScore);
    float xLowest = settlementGroups[j].pos.x;
    float yLowest = settlementGroups[j].pos.y;
    PVector lowestScorePosition = new PVector(xLowest, yLowest);
    //println(lowestRadarScore);
    //println(settlementGroups[j].lowestRadarScore);
    /*
    if(lowestScore > settlementGroups[j].lowestRadarScore) {
      lowestScore = settlementGroups[j].lowestRadarScore;
      if (settlementGroups[j].lowestRadarScoreIndex == 0) {xLowest = settlementGroups[j].pos.x; yLowest = settlementGroups[j].pos.y - settlementGroups[j].r/20;}
      if (settlementGroups[j].lowestRadarScoreIndex == 1) {xLowest = settlementGroups[j].pos.x+settlementGroups[j].r/20; yLowest = settlementGroups[j].pos.y;}
      if (settlementGroups[j].lowestRadarScoreIndex == 2) {xLowest = settlementGroups[j].pos.x; yLowest = settlementGroups[j].pos.y + settlementGroups[j].r/20;}
      if (settlementGroups[j].lowestRadarScoreIndex == 3) {xLowest = settlementGroups[j].pos.x - settlementGroups[j].r/20; yLowest = settlementGroups[j].pos.y;}
    }
    PVector acceleration = settlementGroups[j].pos.sub(lowestScorePosition);
    */
  }
  //println("counter[0]",counter[0], "  ", "counter[1]",counter[1], "  ", "counter[2]",counter[2], "  ", "counter[3]",counter[3], "  ", "counter[4]",counter[4], "  ","counter[5]",counter[5]);
}

void keyPressed() {
  world.invisibleField();
  world.newField();
}

void mousePressed() {
  world.born(mouseX, mouseY);
}

void mouseDragged() {
  world.born(mouseX, mouseY);
}

void counterLabel(){
}

/*
void calculateSettlementPosition() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        sum += 10 * b.r / d;
      }
      pixels[index] = color(sum, 204, 101);
    }
  }

  updatePixels();
}



void repulsion() {
  for (int i = 0; i < attractors.size(); i++) {
    stroke(0, 255, 0);
    point(attractors.get(i).position.x, attractors.get(i).position.y);
  }
  for (int i = 0; i < blobs.length; i++) {
    Blob blob = blobs[i]; //if the population increase, the bolb(settlement)should be arraylist rather than array
    for (int j = 0; j < attractors.size(); j++) {
      blob.replusion(attractors.get(j).position);
    }
    blob.update();
    //blob.show();
  }
}

*/
