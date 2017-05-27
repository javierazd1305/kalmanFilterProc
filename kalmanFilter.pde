Pointer point;
void setup(){
  size(500,500);
  //background(0);
  //frameRate(4);
};

void draw(){ 
}

public void mousePressed(){
  background(0);
  PVector pos =new PVector(mouseX,mouseY);
  point = new Pointer(pos,millis());
}

void mouseDragged(){
  background(0);
  //update
  PVector pos = new PVector(mouseX,mouseY);
  fill(255);
  noStroke();
  point.show();
  float angle = point.getAngle(pos);
  point.update(pos,angle);
  //get the error
  point.getError();
  fill(255,0,0);
  if (point.projection != null){
    ellipse(point.projection.x,point.projection.y,4,4);
  }
  point.projectPoint(point);
  point.showLegend();
}