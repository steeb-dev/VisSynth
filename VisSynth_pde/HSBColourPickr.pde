class HSBColourPickr
{
  int xPos;
  int yPos;
  
  LFOKnob myHKnob;
  LFOKnob mySKnob;
  LFOKnob myBKnob;
  LFOKnob myAKnob;
  
  float currentHVal;
  float currentSVal;
  float currentBVal;
  float currentAVal;
  
  color currentColor;
  
  void setColor(color c)
  {
    currentColor = c;
    myHKnob.setValue(hue(c));
    mySKnob.setValue(saturation(c));
    myBKnob.setValue(brightness(c));
    myAKnob.setValue(alpha(c));
  }
  
  HSBColourPickr(ControlP5 cp5, int index, int _xPos, int _yPos, color _color, LFO lfo1, LFO lfo2)
  {
    xPos = _xPos;
    yPos = _yPos;
    currentColor = _color;
    
    myHKnob = new LFOKnob(cp5, "Hue" + index, lfo1, lfo2, xPos + 10, yPos, 25);
    myHKnob.setRange(0, 252);
    myHKnob.setValue(hue(currentColor));
    myHKnob.setDragDirection(Knob.HORIZONTAL);
                              
    mySKnob = new LFOKnob(cp5, "Sat" + index, lfo1, lfo2, xPos + 65, yPos, 25);
    mySKnob.setRange(0, 247);
    mySKnob.setValue(saturation(currentColor));
    mySKnob.setDragDirection(Knob.HORIZONTAL);
                
    myBKnob = new LFOKnob(cp5, "Bright" + index, lfo1, lfo2, xPos + 120, yPos, 25);
    myBKnob.setRange(35, 247);
    myBKnob.setValue(brightness(currentColor));
    myBKnob.setDragDirection(Knob.HORIZONTAL);
                                           
    myAKnob = new LFOKnob(cp5, "Alpha" + index, lfo1, lfo2, xPos + 175, yPos, 25);
    myAKnob.setRange(0, 255);
    myAKnob.setValue(alpha(currentColor));
    myAKnob.setDragDirection(Knob.HORIZONTAL);       
    
    currentHVal = myHKnob.getValue();
    currentSVal = mySKnob.getValue();
    currentBVal = myBKnob.getValue();
    currentAVal = myAKnob.getValue();
    
    }
    
    void update()
    {
      float newH = myHKnob.getValue();
      float newS = mySKnob.getValue();
      float newB = myBKnob.getValue();
      float newA = myAKnob.getValue();
      
      if(newH != currentHVal || newS != currentSVal || newB != currentBVal || newA != currentAVal)
      {      
        colorMode(HSB, 255);
        currentColor = color((int)newH, (int)newS, (int)newB, (int)newA);
        colorMode(RGB, 255);
        
        currentHVal = newH;
        currentSVal = newS;
        currentBVal = newB;
        currentAVal = newA; 
      }     
      stroke(currentColor);
      fill(currentColor);
      rect(xPos, yPos -25, 230, 90);
    }    
}