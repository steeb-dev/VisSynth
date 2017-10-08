import controlP5.*;

class LFO
{      
  boolean isActive;
  Knob target;
  float depth = 0.25;
  float rate;
  float theta = 0;
  
  void update()
  {      
      if(isActive)
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