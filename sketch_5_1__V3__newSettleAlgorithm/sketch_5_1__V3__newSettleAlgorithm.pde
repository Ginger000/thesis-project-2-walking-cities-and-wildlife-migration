import java.util.*;
import controlP5.*;

ControlP5 cp5;
ControlP5 cp6;
float speedChange = 0;
float population_2 = 0.01;
FlowField flowfield;
List<NSettlement> NSettlements = new ArrayList<NSettlement>();
List<PVector> food = new ArrayList<PVector>();
List<Wildlife> wildlifes = new ArrayList<Wildlife>();

boolean debug;
boolean debug_flowField = true;
void setup() {
  size(1560, 960);
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this);
  cp5.addSlider("speedChange").setPosition(70,70).setRange(-5,5);
  //cp5.addSlider("population_2").setPosition(100,100).setRange(0,1);
  flowfield = new FlowField(20);
  for (int i = 0; i < 15; i++) {
    float x = random(width);
    float y = random(height);
    NSettlements.add(new NSettlement(x, y));
  }

  for (int i = 0; i < 40; i++) {
    float x = random(width);
    float y = random(height);
    food.add(new PVector(x, y));
  }

  for (int i = 0; i < 200; i++) {
    wildlifes.add(new Wildlife(new PVector(random(width), random(height)), random(5, 9), random(0.1, 0.5)));
  }
}



void draw() {
  background(51);
  ///*

  loadPixels();
  //float k;
  //color colorK = color(0, 204, 0);
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (NSettlement v : NSettlements) {
        float d = dist(x, y, v.position.x, v.position.y);
        sum += 10 * v.r / d;
        //k= map(v.health, 0, 1, 101,204);
        
        //int rd = color(255, 0, 0);
        //color col = lerpColor(rd, pixels[index], v.health);
      }
      pixels[index] = color(sum, 101, 101); // 204 = 101
    }
  }

  updatePixels();

  //*/
  if (debug_flowField) flowfield.display();
  // Tell all the NSettlements to follow the flow field
  for (Wildlife p : wildlifes) {
    p.follow(flowfield);
    p.run();
  }

  if (random(1) < 0.01) {
    float x = random(width);
    float y = random(height);
    food.add(new PVector(x, y));
  }

  //if (random(1) < 0.01) {
    //float x = random(width);
    //float y = random(height);
    //poisons.add(new PVector(x, y));
  //}


  for (int i = 0; i < food.size(); i++) {
    fill(0, 255, 0);
    noStroke();
    ellipse(food.get(i).x, food.get(i).y, 4, 4);
  }

  

  for (int i = NSettlements.size() - 1; i >= 0; i--) {
    NSettlement s = NSettlements.get(i);
    s.maxspeedNew = s.maxspeedBase + speedChange;
    s.boundaries();
    s.behaviors(food, wildlifes);
    s.update();
    s.display();

    NSettlement newNSettlement = s.clone();
    if (newNSettlement != null) {
      NSettlements.add(newNSettlement);
    }

    if (s.dead()) {
      food.add(s.position.copy());
      NSettlements.remove(i);
    }
  }
  
  
}

void invisibleField(){
  if (key == ' ') {
    debug_flowField = !debug_flowField;
  }
}

void showWeightAndPerception(){
  if (key == 's'|| key == 'S') {
    debug = true;
  }
  if (key == 'd'|| key == 'D') {
    debug = false;
  }
}
  
void newField(){
  if (key == 'n'|| key == 'N') {
  flowfield.init();
  }  
}

//void addNewSettlemetn(){
  //if (key == 'b'|| key == 'B') {
    //NSettlements.add(new NSettlement(mouseX, mouseY));
  //}
//}

void mouseClicked() {
  if (key == 'b'|| key == 'B') {
    NSettlements.add(new NSettlement(mouseX, mouseY));
  }
  //NSettlements.add(new NSettlement(mouseX, mouseY));
}

void keyPressed() {
  invisibleField();
  newField();
  showWeightAndPerception();
  //addNewSettlemetn();
}
