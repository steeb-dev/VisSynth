class HSBColourPickr
{
  int xPos;
  int yPos;
  
  Knob myHKnob;
  Knob mySKnob;
  Knob myBKnob;
  Knob myAKnob;
  
  float currentHVal;
  float currentSVal;
  float currentBVal;
  float currentAVal;
  
  color currentColor;
  
  HSBColourPickr(ControlP5 cp5, int index, int _xPos, int _yPos, color _color)
  {
    xPos = _xPos;
    yPos = _yPos +   10;
    currentColor = _color;
    
    myHKnob = cp5.addKnob("Hue" + index)
             .setRange(0, 252)
             .setValue(hue(currentColor))
             .setPosition(xPos + 10, yPos)
             .setRadius(19)
             .setDragDirection(Knob.HORIZONTAL)
             ;
                              
    mySKnob = cp5.addKnob("Sat" + index)
             .setRange(0, 247)
             .setValue(saturation(currentColor))
             .setPosition(xPos + 50, yPos)
             .setRadius(19)
             .setDragDirection(Knob.HORIZONTAL)
             ;
                
    myBKnob = cp5.addKnob("Bright" + index)
             .setRange(35, 247)
             .setValue(brightness(currentColor))
             .setPosition(xPos + 90, yPos)
             .setRadius(19)
             .setDragDirection(Knob.HORIZONTAL)
             ;
                                           
    myAKnob = cp5.addKnob("Alpha" + index)
             .setRange(0, 255)
             .setValue(alpha(currentColor))
             .setPosition(xPos + 130, yPos)
             .setRadius(19)
             .setDragDirection(Knob.HORIZONTAL)
             ;
             
             
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
      rect(xPos, yPos, 180, 40);
    }    
}