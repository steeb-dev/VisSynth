   
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
  
  HSBColourPickr myColorPicker;
  Toggle myVertButton;
  
  void Setup(WaveGenerator _wg, ControlP5 cp5)
  {
     wg = _wg;
    int yPos = (int)_wg.buffHeight + 80;
    if(wg.layerIndex > 0) { yPos += 80 * wg.layerIndex; }
  
     myVertButton = cp5.addToggle("vert" + wg.layerIndex)
           .setPosition(20, yPos)
            .setSize(15,15);            
                
     myKnobRate = cp5.addKnob("numWaves " + wg.layerIndex)                
                 .setRange(1,128.0)
                 .setValue(40)
                 .setPosition(70, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
     myKnobTheta = cp5.addKnob("effector "  + wg.layerIndex)
                 .setRange(0.01,1)
                 .setValue(0.2)
                 .setPosition(135, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
     myKnobOffset = cp5.addKnob("offset " +  wg.layerIndex)
                 .setRange(0, width/2)
                 .setValue(0)
                 .setPosition(200, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
       
      myKnobScroll = cp5.addKnob("scroll " +  wg.layerIndex)
                 .setRange(-1, 1)
                 .setValue(0)
                 .setPosition(265, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                  
      myKnobBend = cp5.addKnob("bend " +  wg.layerIndex)
                 .setRange(-1, 1)
                 .setValue(0)
                 .setNumberOfTickMarks(2)
                 .snapToTickMarks(true)
                 .setPosition(330, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
  
    myKnobMask = cp5.addKnob("mask " +  wg.layerIndex)
                 .setRange(-1.0, 1.0)
                 .setValue(0)
                 .setPosition(395, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
                 
    myKnobWaveForm = cp5.addKnob("waveForm " +  wg.layerIndex)
                 .setRange(1, 5)
                 .setValue(1)
                 .setNumberOfTickMarks(4)
                 .snapToTickMarks(true)
                 .setPosition(460, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
  

     myColorPicker = new HSBColourPickr(cp5, wg.layerIndex, 710, yPos, wg.currentColor);
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
    
    int newWaves  = (int)myKnobRate.getValue();
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
    if(updateBuffer){  wg.prepWaveBuffer();}
  }
}