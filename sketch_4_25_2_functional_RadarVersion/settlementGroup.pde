class SettlementGroup {
  PVector pos;
  PVector prev;
  float r;
  PVector vel;
  PVector acc;
  
  Population radar;
  int popmax = 6;
  float mutationRate = 0.01;
  
int radarNum = 4;
int[] radarCounter = new int[radarNum];

int lowestRadarScore;
int highestRadarScore;

PVector lowestScoreRadarPosition;
PVector highestScoreRadarPosition;
  

  

  SettlementGroup(float x, float y) {

    pos = new PVector(x, y);
    prev = new PVector(x, y);

    pos = new PVector(pos.x, pos.y);
    vel = new PVector(0,0);
    //vel.mult(random(2, 5));    
    acc = new PVector(0,0);
    r = random(600, 2000);
    
    //lowestRadarScoreIndex = 0;
    
  }

  void update() {
    //println(acc);
    if (acc != null) {
      vel.add(acc);
    } 
    if (acc == null){
      vel.add(PVector.random2D());
    }
    //vel.add(acc);
    println(pos.x);
    if(pos.x < width/3 && random(1) < 0.3) {
      vel.add(0.1,0);
    }
    if(pos.y < height/3) {
      vel.add(0, 1);
    }
    
    vel.limit(2);
    pos.add(vel); 
    buildRadar();

    

    if (pos.x > width || pos.x < 0) {
       vel.x *= -10;
      //vel.x = 0;
    }
    if (pos.y > height || pos.y < 0) {
      vel.y *= -10;
      //vel.y = 0;
    }
   
    if (acc != null) {
      acc.mult(0);
    } 
    //vel.mult(0);
    
    //acc.add(acceleration);
    
  }
  
  void applyForce(PVector force) {
    acc = force;
  }

  void buildRadar() {
    float xNew = 0;
    float yNew = 0;
    lowestRadarScore = attractors.size();
    highestRadarScore = 0;
    for (int i = 0; i < radarNum; i++) {
      radarCounter[i] = 0;
      pushMatrix();
      translate(pos.x, pos.y); 
      rotate(radians(90*i));
      fill(100, 50);
      //ellipse(0, r/20, r/10, r/10);
      //r/10*sin(60*i) + pos.x, r/10*cos(60*i)+pos.y
      //textSize(32);
      //text(radarCounter[i], pos.x +r/10*sin(60*i), pos.y + r/10*cos(60*i)); 
     // fill(0, 102, 153);
      
      if (i == 0) {xNew = pos.x; yNew = pos.y - r/20;}
      if (i == 1) {xNew = pos.x + r/20; yNew = pos.y;}
      if (i == 2) {xNew = pos.x; yNew = pos.y + r/20;}
      if (i == 3) {xNew = pos.x - r/20; yNew = pos.y;}
      for(int j = 0; j < attractors.size(); j++) {
        float dd = dist(attractors.get(j).position.x, attractors.get(j).position.y, xNew, yNew);
        if (dd < r/20) {
        radarCounter[i]++;
        }
      }
      if (radarCounter[i] < lowestRadarScore) {
        lowestRadarScore = radarCounter[i];
        lowestScoreRadarPosition = new PVector(xNew, yNew);
      }
      if (radarCounter[i] > highestRadarScore) {
        highestRadarScore = radarCounter[i];
        highestScoreRadarPosition = new PVector(xNew, yNew);
      }
      
      //println(lowestRadarScore);
      //println(lowestRadarScoreIndex);
      popMatrix();
      //println("radarCounter[0]",radarCounter[0], "  ", "radarCounter[1]",radarCounter[1], "  ", "radarCounter[2]",radarCounter[2], "  ", "radarCounter[3]",radarCounter[3], "  ", "radarCounter[4]",radarCounter[4], "  ", "radarCounter[5]",radarCounter[5]);
      //println(radarCounter[0], "  ", radarCounter[1], "  ", radarCounter[2], radarCounter[3], "  ",radarCounter[4], "  ",radarCounter[5]);
    }
    //return lowestRadarScore;
    //if (lowestScore < 
    
  }
  
  void show() {
    //noFill();
    fill(150);
    stroke(0);
    strokeWeight(4);
    ellipse(pos.x, pos.y, r*2, r*2);
    
    line(this.pos.x, this.pos.y, this.prev.x, this.prev.y);
    
    prev.x = pos.x;
    prev.y = pos.y;
  }
  
  void wrapper() {
    if (pos.x < 0)  {pos.x = width-r;}
    if (pos.y < 0)  pos.y = height - r;
    if (pos.x > width - r)  pos.x = r;
    if (pos.y > height - r) pos.y = r;
  }

}
