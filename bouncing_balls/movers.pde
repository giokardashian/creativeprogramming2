class Mover { 
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  int lastNotePlayed=999;
  int state=0;
  int ch;    //MIDI channel
  float marker;
  
  Mover(float m, float x, float y) {
    mass = m;
    
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    acceleration = new PVector (0,0);
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display(int n) {
    stroke(0);
    strokeWeight(2);
    fill(50*n, 33, 255);
    ellipse(location.x, location.y, mass*16, mass*16);
  }
  
  void checkEdges(int channel) {
    ch = channel;
    if (location.x > width-(mass*16)/2){
      location.x = width-(mass*16)/2;
      velocity.x *= -1;
    } else if (location.x < 0+(mass*16)/2) {
      location.x = 0+(mass*16)/2;
      velocity.x *= -1;
    }
    
    if (location.y >= height - (mass*16)/2 - keyboardLayer) {
      velocity.y *= -1;
      location.y = height - (mass*16)/2 - keyboardLayer;
      // notes
      for(int i = 0; i <5; i++){
        if (location.x>= i*width/5 && location.x < (i+1) * width/5){
          fill(33,30,55);
          rect(i*width/5, height-keyboardLayer, width/5, keyboardLayer);
          myBus.sendNoteOn(ch, MIDInotes[i], 101);
          delay(0);
          marker = millis();
          ch = i;
          lastNotePlayed = MIDInotes [i];
        }
      }
    }
    
    else{
      if(millis() - marker>=25)
      myBus.sendNoteOff(ch, lastNotePlayed, 101);
    }
  }
  
}