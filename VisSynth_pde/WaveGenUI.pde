   
class WaveGenUI
{      
  WaveGenerator wg;
  Knob myKnobRate;
  Knob myKnobTheta;  
  Knob myKnobOffset;
  Knob myKnobScroll;
  Knob myKnobMask;
  Knob myKnobBend;
  Knob myKnobWaveForm;
  Knob myKnobLFORate;
  Knob myKnobLFODepth;
  Knob myKnobLFOTarget;
  
  HSBColourPickr myColorPicker;
  Toggle myVertButton;
  
  Toggle myFlipHorizButton;
  Toggle myFlipVertButton;
  
  void Setup(WaveGenerator _wg, ControlP5 cp5)
  {
     wg = _wg;
    int yPos = (int)_wg.buffHeight + 80;
    if(wg.layerIndex > 0) { yPos += 80 * wg.layerIndex; }
  
     myVertButton = cp5.addToggle("vert" + wg.layerIndex)
           .setPosition(20, yPos)
            .setSize(15,15);    

     myFlipHorizButton = cp5.addToggle("hflip" + wg.layerIndex)
           .setPosition(45, yPos)
            .setSize(15,15);    

     myFlipVertButton = cp5.addToggle("vflip" + wg.layerIndex)
           .setPosition(45, yPos + 30)
            .setSize(15,15);    
                
     myKnobRate = cp5.addKnob("numWaves " + wg.layerIndex)                
                 .setRange(1,128)
                 .setValue(1)
                 .setPosition(80, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
     myKnobTheta = cp5.addKnob("effector "  + wg.layerIndex)
                 .setRange(0.01,1)
                 .setValue(0.2)
                 .setPosition(145, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
     myKnobOffset = cp5.addKnob("offset " +  wg.layerIndex)
                 .setRange(0, width/2)
                 .setValue(0)
                 .setPosition(210, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
       
      myKnobScroll = cp5.addKnob("scroll " +  wg.layerIndex)
                 .setRange(-1, 1)
                 .setValue(0)
                 .setPosition(275, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                  
      myKnobBend = cp5.addKnob("bend " +  wg.layerIndex)
                 .setRange(-1, 1)
                 .setValue(0)
                 .setNumberOfTickMarks(2)
                 .setPosition(340, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
  
    myKnobMask = cp5.addKnob("mask " +  wg.layerIndex)
                 .setRange(-1.0, 1.0)
                 .setValue(0)
                 .setPosition(405, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
    myKnobWaveForm = cp5.addKnob("waveForm " +  wg.layerIndex)
                 .setRange(1, 3)
                 .setValue(1)
                 .setNumberOfTickMarks(2)
                 .snapToTickMarks(true)
                 .setPosition(470, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;

    myKnobLFORate = cp5.addKnob("lfoRate " +  wg.layerIndex)
                 .setRange(1, 1.3)
                 .setValue(1)
                 .setPosition(535, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;

    myKnobLFODepth  = cp5.addKnob("lfoDepth " +  wg.layerIndex)
                 .setRange(0, 1)
                 .setValue(0)
                 .setPosition(600, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
      
    myKnobLFOTarget  = cp5.addKnob("lfoTarget " +  wg.layerIndex)
                 .setRange(0, 11)  
                 .setNumberOfTickMarks(11)
                 .snapToTickMarks(true)
                 .setValue(0)
                 .setPosition(665, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
      

     myColorPicker = new HSBColourPickr(cp5, wg.layerIndex, 720, yPos, wg.currentColor);
  }
  
  void UpdateControls()
  {
    boolean updateBuffer = false;
    boolean toggleVal = myVertButton.getBooleanValue();
    wg.waveType = (int)myKnobWaveForm.getValue();
    
    if(toggleVal != wg.vertical)
    {
      wg.vertical = toggleVal;
      updateBuffer = true;
    }  
    
    float newWaves  = myKnobRate.getValue();
    if(newWaves != wg.numWaves)
    {
      wg.numWaves = newWaves;
      updateBuffer = true;
    }
    
    wg.thetaRate = myKnobTheta.getValue();
    myColorPicker.update();
    wg.currentColor = myColorPicker.currentColor;
    
    if(wg.vertical)
    {
      wg.scrollRate = (int)(wg.buffWidth/2 * myKnobScroll.getValue());
      wg.scrollOffset += wg.scrollRate;   
      if(wg.scrollOffset >= wg.buffWidth)
      {wg.scrollOffset = wg.scrollOffset - (int)wg.buffWidth;}
      if(wg.scrollOffset < 0)
      {wg.scrollOffset = (int)wg.buffWidth + wg.scrollOffset;}
    }
    else
    {      
      wg.scrollRate = (int)(wg.buffHeight/2 * myKnobScroll.getValue());
      wg.scrollOffset += wg.scrollRate;
      if(wg.scrollOffset >= wg.buffHeight)
      {wg.scrollOffset = wg.scrollOffset - (int)wg.buffHeight;}
      if(wg.scrollOffset < 0)
      {wg.scrollOffset = (int)wg.buffHeight + wg.scrollOffset;}

  }
    
    wg.offset = myKnobOffset.getValue();
    wg.bendAmount = myKnobBend.getValue();
    wg.mask = myKnobMask.getValue();
    wg.flipHoriz = myFlipHorizButton.getBooleanValue();
    wg.flipVert = myFlipVertButton.getBooleanValue();
    
    wg.lfo1.rate = myKnobLFORate.getValue();
    wg.lfo1.depth = myKnobLFODepth.getValue();
    
    HandleLFOTarget();
    
    if(updateBuffer){  wg.prepWaveBuffer();}
  }
  
  void HandleLFOTarget()
  {
    int target = (int)myKnobLFOTarget.getValue();
    if(target == 0)
    {
      wg.lfo1.isActive = false;     
    }
    else
    {
      wg.lfo1.isActive = true;
     
      switch(target)
      {  
        case 1:
          wg.lfo1.target = myKnobRate;  
        break;                            
        case 2:
          wg.lfo1.target = myKnobTheta;  
        break;                    
        case 3:
          wg.lfo1.target = myKnobOffset;  
        break;                    
        case 4:
          wg.lfo1.target = myKnobScroll;  
        break;                    
        case 5:
          wg.lfo1.target = myKnobMask;  
        break;        
        case 6:
          wg.lfo1.target = myKnobBend;  
        break;        
        case 7:
          wg.lfo1.target = myKnobWaveForm;  
        break; 
        case 8:
          wg.lfo1.target = myColorPicker.myHKnob;  
        break; 
        case 9:
          wg.lfo1.target = myColorPicker.mySKnob;  
        break; 
        case 10:
          wg.lfo1.target = myColorPicker.myBKnob;  
        break; 
        case 11:
          wg.lfo1.target = myColorPicker.myAKnob;  
        break; 
      }
    }
  }
}