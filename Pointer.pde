class Pointer{
  public PVector pos;
  public float speed;
  public float time;
  public float angle;
  public float ellapseTime;
  public float acceleration;
  public ArrayList errorEstimation; //<>//
  public PVector projection;
    
  Pointer (PVector pos, float time){
    this.pos = pos;
    this.speed = 0;
    this.time = time;
    this.angle = 0;
    this.acceleration = 0;
    
    this.errorEstimation = new ArrayList();
    this.projection = null;
  }
  
  public float calcSpeed(PVector pos1, PVector pos2, float frameRate){
    float distance = dist(pos1.x,pos1.y,pos2.x,pos2.y);
    float speed = distance/frameRate;
    return speed;
  }
  public void update(PVector pos, float angle){  
    float speed = calcSpeed(this.pos, pos, frameRate);
    this.ellapseTime = (millis() - this.time)/1000;
    this.acceleration = (this.speed-speed)/this.ellapseTime;
    this.speed =speed;
    this.pos = pos;
    this.angle = angle;
  }
  
  public void show(){
    ellipse(this.pos.x,this.pos.y,10,10);
  }
  
  public void showLegend(){
    String text = "pos: " + this.pos.x + ", " + this.pos.y + ", " + this.angle; 
    text(text,10,10);
    text("time: "+this.ellapseTime,10,30);
    text("speed: "+this.speed,10,50);
    text("accele: "+this.acceleration,10,70);
    if(this.errorEstimation.size() > 0){
      int tam = this.errorEstimation.size();
      text("errorEsti: "+this.errorEstimation.get(tam-1),10,90);
    }
    
  }
  
  public float getAngle(PVector target) {
    float angle = (float) Math.toDegrees(Math.atan2(this.pos.y-target.y,this.pos.x- target.x ));
    angle = angle -180;
    angle = abs(angle);
    return angle;
  }
  
  //estimate de new x,y based on his angle,speed,acceleration
  public void projectPoint(Pointer pointer){
    //println(rate.get(0), rate.get(1));
    float x = pointer.pos.x + cos(pointer.angle*PI/180)*(this.speed+this.acceleration*0.3*frameRate) ;
    float y = pointer.pos.y -sin(pointer.angle*PI/180)*(this.speed+this.acceleration*0.3*frameRate);
    PVector projectedPoint = new PVector(x,y);
    this.projection = projectedPoint;
    fill(255,0,255);
    ellipse(this.projection.x,this.projection.y,4,4);
   }
  
  
  public void getError(){
    if(this.projection != null){
      float error = dist(this.projection.x,this.projection.y,this.pos.x,this.pos.y);
      this.errorEstimation.add(error);    
    }
  }
  
  
  
  public float calcRate(){
    double diffx = 0;
    double diffy = 0;
    double std = 0;
    if (this.errorEstimation.size()>0){
      float average = 0;
      float maxNum = 0;
      float num = 0;
      for(int  i = 0; i < this.errorEstimation.size();i++){
        num = (float) this.errorEstimation.get(i);
        average += num;
        if (num > maxNum){
          maxNum = num;
        }
      }
      average = average/this.errorEstimation.size();
      for (int i = 0; i < this.errorEstimation.size();i++){
        num = (float) this.errorEstimation.get(i);
        std = std + (Math.pow(average+num,2))/this.errorEstimation.size();
      }
      std = Math.pow(std,0.5);
      std = map((float)std,0,maxNum,0,1)*0.7;
      //diffx = (this.pos.x-this.projection.x)*std*0.7;
      //diffy = (this.pos.y-this.projection.y)*std*0.7;
      //println(std,diffx,diffy);
    }
    return (float)std;
    }
}