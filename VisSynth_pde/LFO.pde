import controlP5.*;

class LFO
{      
  boolean isActive;
  Knob target;
  float depth = 1;
  float rate;
  float theta = 0;
  
  void update()
  {      
      if(isActive && depth > 0)
      {        
        theta += TWO_PI * rate;
        float normValue = sin(theta) * depth; 
        normValue = (normValue + 1)/2;
        float min = target.getMin();
        float max = target.getMax();
        float range = max - min;
        float scaledValue = (normValue * range) + min;      
        target.setValue(scaledValue);
      }
  }
}