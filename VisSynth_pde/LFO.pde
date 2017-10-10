import controlP5.*;

class LFO
{      
  float depth = 1;
  float rate;
  float theta = 0;
  float sinValue;
  
  void update()
  {      
     theta += TWO_PI * rate;
     sinValue = sin(theta); 
  }
}