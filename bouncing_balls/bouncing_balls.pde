import themidibus.*;

Mover[] movers = new Mover[4+1];
MidiBus myBus;
int keyboardLayer = 10;
int dir = 1;
int[] MIDInotes={60-12*2,62-12,64,67+12,69+12*1};
float zoom = 1.0;
int look = 0;
int lookVerso = 1;

void setup() {
 // size(int(383*zoom), int(200*zoom));
  size(800,400);
  MidiBus.list();
  myBus = new MidiBus(this,0,1);
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(1, 4), random(width), 0);
  }
  for(int i2 = 0; i2 < 5; i2++){
    for(int i = 0; i < MIDInotes.length; i++){
      myBus.sendNoteOff(i2, MIDInotes[i], 101);
    }
  }
}

void draw() {
  background(look,188,179);
  if(look<0)
    lookVerso = 1;
  if(look>255)
    lookVerso = -1;
  look = look+1*lookVerso;
  noFill();
  strokeWeight(2);
  for(int i = 0; i <= 5; i++){
    rect(i*width/5, height-keyboardLayer, width/5, keyboardLayer);
  }
  
  for (int i = 0; i < movers.length; i++) {
    PVector wind = new PVector(0.01*dir, 0);
    PVector gravity = new PVector(0, 0.1*movers[i].mass);
    
    float c = 0.05;
    PVector friction = movers[i].velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(c);
    
    movers[i].applyForce(friction);
    movers[i].applyForce(wind);
    movers[i].applyForce(gravity);
    
    movers[i].update();
    movers[i].display(i);
    movers[i].checkEdges(i);
  }
}

void keyPressed(){
  if(keyCode==ENTER){
    //followinf MIDI panic!
    for(int i2 = 0; i2 < 5; i2++){
      for(int i = 0; i < MIDInotes.length; i++){
        myBus.sendNoteOff(i2, MIDInotes[i], 101);
      }
    }
    for (int i = 0; i < movers.length; i++) {
      movers[i] = new Mover (random(1, 4), random(width), 0);
    }
  }
}