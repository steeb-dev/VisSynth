   
class WaveGenUI
{      
  WaveGenerator wg;
  LFOKnob myKnobMirrorState;
  LFOKnob myKnobRate;
  LFOKnob myKnobTheta;  
  LFOKnob myKnobOffset;
  LFOKnob myKnobScroll;
  LFOKnob myKnobMask;
  LFOKnob myKnobBend;
  LFOKnob myKnobWaveForm;
  
  Knob myKnobLFO1Rate;
  Knob myKnobLFO1Depth;
  Knob myKnobLFO2Rate;
  Knob myKnobLFO2Depth;
    
  HSBColourPickr myColorPicker;
  Toggle myVertButton;
    
  void Setup(WaveGenerator _wg, ControlP5 cp5)
  {
     wg = _wg;
    int yPos = (int)_wg.buffHeight + 30;
    if(wg.layerIndex > 0) { yPos += 100 * wg.layerIndex; }
  
     myVertButton = cp5.addToggle("vert" + wg.layerIndex)
           .setPosition(width / 2 - 670, yPos + 2)
           .setSize(15,15);    

     myKnobMirrorState = new LFOKnob(cp5, "mirror" + wg.layerIndex, wg.lfo1, wg.lfo2, width / 2 - 630, yPos, 25);
     myKnobMirrorState.setRange(0,8);
     myKnobMirrorState.setValue(0);
     myKnobMirrorState.setNumberOfTickMarks(8);     
     myKnobMirrorState.snapToTickMarks(true);
     myKnobMirrorState.setDragDirection(Knob.HORIZONTAL);

                
     myKnobRate = new LFOKnob(cp5, "numWaves " + wg.layerIndex, wg.lfo1, wg.lfo2,width / 2 - 560, yPos, 25);                
     myKnobRate.setRange(1,128);
     myKnobRate.setValue(1);
     myKnobRate.setDragDirection(Knob.HORIZONTAL);
     
     myKnobTheta = new LFOKnob(cp5, "effector "  + wg.layerIndex, wg.lfo1, wg.lfo2, width / 2 - 490, yPos, 25);
     myKnobTheta.setRange(0.01,1);
     myKnobTheta.setValue(0.2);
     myKnobTheta.setRadius(25);
     myKnobTheta.setDragDirection(Knob.HORIZONTAL);
                 
     myKnobOffset = new LFOKnob(cp5, "offset " +  wg.layerIndex, wg.lfo1, wg.lfo2,width / 2 - 420, yPos, 25);
     myKnobOffset.setRange(0, 1);
     myKnobOffset.setValue(0);
     myKnobOffset.setDragDirection(Knob.HORIZONTAL);
       
    myKnobScroll = new LFOKnob(cp5, "scroll " +  wg.layerIndex, wg.lfo1, wg.lfo2, width / 2 - 350, yPos, 25);
    myKnobScroll.setRange(-1, 1);
    myKnobScroll.setValue(0);
    myKnobScroll.setDragDirection(Knob.HORIZONTAL);
                  
    myKnobBend = new LFOKnob(cp5, "bend " +  wg.layerIndex, wg.lfo1, wg.lfo2,width / 2 - 280, yPos, 25);
    myKnobBend.setRange(-1, 1);
    myKnobBend.setValue(0);
    myKnobBend.setNumberOfTickMarks(2);
    myKnobBend.setDragDirection(Knob.HORIZONTAL);
  
    myKnobMask = new LFOKnob(cp5, "mask " +  wg.layerIndex, wg.lfo1, wg.lfo2, width / 2 - 210, yPos, 25);
    myKnobMask.setRange(-1.0, 1.0);
    myKnobMask.setValue(0);
    myKnobMask.setDragDirection(Knob.HORIZONTAL);
                 
    myKnobWaveForm = new LFOKnob(cp5, "waveForm " +  wg.layerIndex, wg.lfo1, wg.lfo2, width / 2 - 140, yPos, 25);
    myKnobWaveForm.setRange(1, 4);
    myKnobWaveForm.setValue(1);
    myKnobWaveForm.setNumberOfTickMarks(3);
    myKnobWaveForm.snapToTickMarks(true);
    myKnobWaveForm.setDragDirection(Knob.HORIZONTAL);

    myColorPicker = new HSBColourPickr(cp5, wg.layerIndex, width / 2 - 70, yPos, wg.currentColor, wg.lfo1, wg.lfo2);

    myKnobLFO1Rate = cp5.addKnob("lfo1Rate " +  wg.layerIndex)
                 .setRange(0.00, 0.3)
                 .setValue(0.01)
                 .setPosition(width / 2 + 190, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;

    myKnobLFO1Depth  = cp5.addKnob("lfo1Depth " +  wg.layerIndex)
                 .setRange(0, 1)
                 .setValue(0)
                 .setPosition(width / 2 + 250, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;
    
    myKnobLFO2Rate = cp5.addKnob("lfo2Rate " +  wg.layerIndex)
                 .setRange(0.00, 0.20)
                 .setValue(0.01)
                 .setPosition(width / 2 + 320, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL)
                 ;

    myKnobLFO2Depth  = cp5.addKnob("lfo2Depth " +  wg.layerIndex)
                 .setRange(0, 1)
                 .setValue(0)
                 .setPosition(width / 2 + 380, yPos)
                 .setRadius(25)
                 .setDragDirection(Knob.HORIZONTAL);

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
      
      float normOffset  = myKnobOffset.getValue();
      wg.offset =  normOffset * wg.buffHeight/2;
    }
    else
    {      
      wg.scrollRate = (int)(wg.buffHeight/2 * myKnobScroll.getValue());
      wg.scrollOffset += wg.scrollRate;
      if(wg.scrollOffset >= wg.buffHeight)
      {wg.scrollOffset = wg.scrollOffset - (int)wg.buffHeight;}
      if(wg.scrollOffset < 0)
      {wg.scrollOffset = (int)wg.buffHeight + wg.scrollOffset;}
      
      float normOffset  = myKnobOffset.getValue();
      wg.offset =  normOffset * wg.buffWidth/2;

  }
    
    wg.bendAmount = myKnobBend.getValue();
    wg.mask = myKnobMask.getValue();
    wg.mirrorState = (int)myKnobMirrorState.getValue();

    
    wg.lfo1.rate = myKnobLFO1Rate.getValue();
    wg.lfo1.depth = myKnobLFO1Depth.getValue();
        
    wg.lfo2.rate = myKnobLFO2Rate.getValue();
    wg.lfo2.depth = myKnobLFO2Depth.getValue();
    
    if(updateBuffer){  wg.prepWaveBuffer();}
  }
  
 String serialise()
 {
   String payload = "";
   payload += str(myKnobOffset.getValue()) + "|";
   payload += str(myKnobTheta.getValue()) + "|";
   payload += str(myKnobRate.getValue()) + "|";
   payload += str(myKnobMask.getValue()) + "|";
   payload += str(myKnobMirrorState.getValue()) + "|";
   payload += str(myKnobScroll.getValue()) + "|";
   payload += str(myKnobBend.getValue()) + "|";
   payload += str(myKnobWaveForm.getValue()) + "|";
   payload += hex(myColorPicker.currentColor) + "|";
   payload += str(myKnobLFO1Rate.getValue()) + "|";
   payload += str(myKnobLFO1Depth.getValue()) + "|";
   payload += str(myKnobLFO2Rate.getValue()) + "|";
   payload += str(myKnobLFO2Depth.getValue()) + "|";
   payload += serialiseBools();
   
   return payload;
 }
 
 String serialiseBools()
 {
   String payload = "";
   payload += str(myKnobOffset.lfo1Button.getValue()) + "|";
   payload += str(myKnobOffset.lfo2Button.getValue()) + "|";     
   payload += str(myKnobTheta.lfo1Button.getValue()) + "|";
   payload += str(myKnobTheta.lfo2Button.getValue()) + "|";
      
   payload += str(myKnobRate.lfo1Button.getValue()) + "|";
   payload += str(myKnobRate.lfo2Button.getValue()) + "|";
   
   payload += str(myKnobMask.lfo1Button.getValue()) + "|";
   payload += str(myKnobMask.lfo2Button.getValue()) + "|";   
   
   payload += str(myKnobMirrorState.lfo1Button.getValue()) + "|";
   payload += str(myKnobMirrorState.lfo2Button.getValue()) + "|";
      
   payload += str(myKnobScroll.lfo1Button.getValue()) + "|";
   payload += str(myKnobScroll.lfo2Button.getValue()) + "|";
      
   payload += str(myKnobBend.lfo1Button.getValue()) + "|";
   payload += str(myKnobBend.lfo2Button.getValue()) + "|";
         
   payload += str(myKnobWaveForm.lfo1Button.getValue()) + "|";
   payload += str(myKnobWaveForm.lfo2Button.getValue()) + "|";


   payload += str(myColorPicker.myHKnob.lfo1Button.getValue()) + "|";
   payload += str(myColorPicker.myHKnob.lfo2Button.getValue()) + "|";
   
   payload += str(myColorPicker.mySKnob.lfo1Button.getValue()) + "|";
   payload += str(myColorPicker.mySKnob.lfo2Button.getValue()) + "|";
      
   payload += str(myColorPicker.myBKnob.lfo1Button.getValue()) + "|";
   payload += str(myColorPicker.myBKnob.lfo2Button.getValue()) + "|";
   
   payload += str(myColorPicker.myAKnob.lfo1Button.getValue()) + "|";
   payload += str(myColorPicker.myAKnob.lfo2Button.getValue()) + "|";
     
   payload += str(myVertButton.getValue());
     
   return payload;
 }
 
 void deSerialise(String payload)
 {
   String[] payloadVals = split(payload, "|");
   myKnobOffset.setValue(float(payloadVals[0]));
   myKnobTheta.setValue(float(payloadVals[1]));
   myKnobRate.setValue(int(payloadVals[2]));
   myKnobMask.setValue(float(payloadVals[3]));
   myKnobMirrorState.setValue(float(payloadVals[4]));   
   myKnobScroll.setValue(float(payloadVals[5])); 
   myKnobBend.setValue(float(payloadVals[6]));
   myKnobWaveForm.setValue(float(payloadVals[7]));
   color c = unhex(payloadVals[8]);
   myColorPicker.setColor(c);   
   myKnobLFO1Rate.setValue(float(payloadVals[9]));
   myKnobLFO1Depth.setValue(float(payloadVals[10]));
   myKnobLFO2Rate.setValue(float(payloadVals[11]));
   myKnobLFO2Depth.setValue(float(payloadVals[12]));
   
   deserialiseBools(payloadVals);
 }
 
 void deserialiseBools(String[] payloadVals)
 {
   myKnobOffset.lfo1Button.setValue(int(payloadVals[13]));
   myKnobOffset.lfo2Button.setValue(int(payloadVals[14]));
  
   myKnobTheta.lfo1Button.setValue(int(payloadVals[15]));
   myKnobTheta.lfo2Button.setValue(int(payloadVals[16]));
      
   myKnobRate.lfo1Button.setValue(int(payloadVals[17]));
   myKnobRate.lfo2Button.setValue(int(payloadVals[18]));
          
   myKnobMask.lfo1Button.setValue(int(payloadVals[19]));
   myKnobMask.lfo2Button.setValue(int(payloadVals[20]));
   
   myKnobMirrorState.lfo1Button.setValue(int(payloadVals[21]));
   myKnobMirrorState.lfo2Button.setValue(int(payloadVals[22]));
   
   myKnobScroll.lfo1Button.setValue(int(payloadVals[23]));
   myKnobScroll.lfo2Button.setValue(int(payloadVals[24]));
      
   myKnobBend.lfo1Button.setValue(int(payloadVals[25]));
   myKnobBend.lfo2Button.setValue(int(payloadVals[26]));
         
   myKnobWaveForm.lfo1Button.setValue(int(payloadVals[27]));
   myKnobWaveForm.lfo2Button.setValue(int(payloadVals[28]));

   myColorPicker.myHKnob.lfo1Button.setValue(int(payloadVals[29]));
   myColorPicker.myHKnob.lfo2Button.setValue(int(payloadVals[30]));

   myColorPicker.mySKnob.lfo1Button.setValue(int(payloadVals[31]));
   myColorPicker.mySKnob.lfo2Button.setValue(int(payloadVals[32]));

   myColorPicker.myBKnob.lfo1Button.setValue(int(payloadVals[33]));
   myColorPicker.myBKnob.lfo2Button.setValue(int(payloadVals[34]));

   myColorPicker.myAKnob.lfo1Button.setValue(int(payloadVals[35]));
   myColorPicker.myAKnob.lfo2Button.setValue(int(payloadVals[36]));

   myVertButton.setValue(int(payloadVals[37]));
 }
}