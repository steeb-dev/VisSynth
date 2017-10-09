import controlP5.*;

class LFO
{      
  boolean isActive;
  Knob target;
  float depth = 1;
  float rate;
  float theta = 0;
  float offSet;
  
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
        float appliedOffset = range * offSet;
        float scaledValue = (normValue * range) + min + appliedOffset;
        if(scaledValue < min) scaledValue = min;
        if(scaledValue > max) scaledValue = max;       
        target.setValue(scaledValue);
      }
  }
}