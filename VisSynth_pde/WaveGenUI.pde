   
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
  Knob myKnobLFO1Rate;
  Knob myKnobLFO1Depth;
  Knob myKnobLFO1Target;
  Knob myKnobLFO2Rate;
  Knob myKnobLFO2Depth;
  Knob myKnobLFO2Target;
  
  
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
           .setPosition(width / 2 - 610, yPos + 2)
           .setSize(15,15);    

     myFlipHorizButton = cp5.addToggle("hflip" + wg.layerIndex)
           .setPosition(width / 2 - 580, yPos + 2)
            .setSize(15,15);    

     myFlipVertButton = cp5.addToggle("vflip" + wg.layerIndex)
           .setPosition(width / 2 - 580, yPos + 32)
            .setSize(15,15);    
                
     myKnobRate = cp5.addKnob("numWaves " + wg.layerIndex)                
                 .setRange(1,128)
                 .setValue(1)
                 .setPosition(width / 2 - 540, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
     myKnobTheta = cp5.addKnob("effector "  + wg.layerIndex)
                 .setRange(0.01,1)
                 .setValue(0.2)
                 .setPosition(width / 2 - 475, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
     myKnobOffset = cp5.addKnob("offset " +  wg.layerIndex)
                 .setRange(0, width/2)
                 .setValue(0)
                 .setPosition(width / 2 - 410, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
       
      myKnobScroll = cp5.addKnob("scroll " +  wg.layerIndex)
                 .setRange(-1, 1)
                 .setValue(0)
                 .setPosition(width / 2 - 345, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                  
      myKnobBend = cp5.addKnob("bend " +  wg.layerIndex)
                 .setRange(-1, 1)
                 .setValue(0)
                 .setNumberOfTickMarks(2)
                 .setPosition(width / 2 - 280, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
  
    myKnobMask = cp5.addKnob("mask " +  wg.layerIndex)
                 .setRange(-1.0, 1.0)
                 .setValue(0)
                 .setPosition(width / 2 - 215, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
    myKnobWaveForm = cp5.addKnob("waveForm " +  wg.layerIndex)
                 .setRange(1, 3)
                 .setValue(1)
                 .setNumberOfTickMarks(2)
                 .snapToTickMarks(true)
                 .setPosition(width / 2 - 150, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;


    myColorPicker = new HSBColourPickr(cp5, wg.layerIndex, width / 2 - 90, yPos, wg.currentColor);

    myKnobLFO1Rate = cp5.addKnob("lfo1Rate " +  wg.layerIndex)
                 .setRange(1, 1.3)
                 .setValue(1)
                 .setPosition(width / 2 + 100, yPos)
                 .setRadius(20)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;

    myKnobLFO1Depth  = cp5.addKnob("lfo1Depth " +  wg.layerIndex)
                 .setRange(0, 1)
                 .setValue(0)
                 .setPosition(width / 2 + 165, yPos)
                 .setRadius(20)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
      
    myKnobLFO1Target  = cp5.addKnob("lfo1Target " +  wg.layerIndex)
                 .setRange(0, 11)  
                 .setNumberOfTickMarks(11)
                 .snapToTickMarks(true)
                 .setValue(0)
                 .setPosition(width / 2 + 230, yPos)
                 .setRadius(20)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
      
      
    myKnobLFO2Rate = cp5.addKnob("lfo2Rate " +  wg.layerIndex)
                 .setRange(1, 1.3)
                 .setValue(1)
                 .setPosition(width / 2 + 295, yPos)
                 .setRadius(20)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;

    myKnobLFO2Depth  = cp5.addKnob("lfo2Depth " +  wg.layerIndex)
                 .setRange(0, 1)
                 .setValue(0)
                 .setPosition(width / 2 + 360, yPos)
                 .setRadius(20)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
      
    myKnobLFO2Target  = cp5.addKnob("lfo2Target " +  wg.layerIndex)
                 .setRange(0, 11)  
                 .setNumberOfTickMarks(11)
                 .snapToTickMarks(true)
                 .setValue(0)
                 .setPosition(width / 2 + 435, yPos)
                 .setRadius(20)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
      

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
    
    wg.lfo1.rate = myKnobLFO1Rate.getValue();
    wg.lfo1.depth = myKnobLFO1Depth.getValue();
    int target1 = (int)myKnobLFO1Target.getValue();   
    HandleLFOTarget(target1, wg.lfo1);
        
    wg.lfo2.rate = myKnobLFO2Rate.getValue();
    wg.lfo2.depth = myKnobLFO2Depth.getValue();
    int target2 = (int)myKnobLFO2Target.getValue();   
    HandleLFOTarget(target2, wg.lfo2);
    
    if(updateBuffer){  wg.prepWaveBuffer();}
  }
  
  void HandleLFOTarget(int target, LFO lfo)
  {
    if(target == 0)
    {
      lfo.isActive = false;     
    }
    else
    {
      lfo.isActive = true;
     
      switch(target)
      {  
        case 1:
          lfo.target = myKnobRate;  
        break;                            
        case 2:
          lfo.target = myKnobTheta;  
        break;                    
        case 3:
          lfo.target = myKnobOffset;  
        break;                    
        case 4:
          lfo.target = myKnobScroll;  
        break;                    
        case 5:
          lfo.target = myKnobMask;  
        break;        
        case 6:
          lfo.target = myKnobBend;  
        break;        
        case 7:
          lfo.target = myKnobWaveForm;  
        break; 
        case 8:
          lfo.target = myColorPicker.myHKnob;  
        break; 
        case 9:
          lfo.target = myColorPicker.mySKnob;  
        break; 
        case 10:
          lfo.target = myColorPicker.myBKnob;  
        break; 
        case 11:
          lfo.target = myColorPicker.myAKnob;  
        break; 
      }
    }
  }
}