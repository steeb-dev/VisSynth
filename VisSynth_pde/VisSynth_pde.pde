import controlP5.*;
import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus
int currentMidiIndex;
boolean doFeedBack = false;
Toggle myClearBufferButton;

ControlP5 cp5;
WaveGenerator[] waves;
CallbackListener cb;
int frameCounter;
boolean saveMode = false;
boolean newPatch = false;
void setup()
{  
  frameRate(60);
  currentMidiIndex = 0;
  myBus = new MidiBus(this, "Akai MPD32",-1); 
  cp5 = new ControlP5(this);
    
  fullScreen(P3D); 
  waves = new WaveGenerator[4];
  waves[0] = new WaveGenerator(color(255,0,0,255));
  waves[0].setup(0, cp5);
   

  waves[1] = new WaveGenerator(color(0,255,0));
  waves[1].setup(1, cp5);

  waves[2] = new WaveGenerator(color(1,1,255));
  waves[2].setup(2, cp5);
  
  waves[3] = new WaveGenerator(color(1,1,255));
  waves[3].setup(3, cp5);
  
  
   myClearBufferButton = cp5.addToggle("feedback")
         .setPosition(80, (int)waves[0].buffHeight + 10)
          .setSize(40,40)
          .setValue(0); 
          
    background(0);   
}

void keyPressed() 
{
   if (key >= '0' && key <= '9') 
   {
      int keyIndex = key;
      if(!saveMode)
      {          
        load("preset" + str(keyIndex) + ".txt");
      }
      else
      {
        save("preset" + str(keyIndex) + ".txt");
        saveMode = false;
      }
  }
  
  if (key == 's') 
  {
    saveMode = true;    
  }
}

void save(String fileName)
{
      String payload1 = waves[0].wgUI.serialise();
      String payload2 = waves[1].wgUI.serialise();   
      String payload3 = waves[2].wgUI.serialise();    
      String payload4 = waves[3].wgUI.serialise();
      
      String[] list = {payload1, payload2, payload3, payload4};
    
      // Writes the strings to a file, each on a separate line
      saveStrings(fileName, list);
}

void load(String fileName)
{
  
      try
      {
        String[] loadList = loadStrings(fileName);  
        waves[0].wgUI.deSerialise(loadList[0]);
        waves[1].wgUI.deSerialise(loadList[1]);   
        waves[2].wgUI.deSerialise(loadList[2]);    
        waves[3].wgUI.deSerialise(loadList[3]);
        newPatch = true;
      }
      catch(Exception e)
      {}
}

void draw()
{
  if(!myClearBufferButton.getBooleanValue() || newPatch)
  {
    background(0); 
    newPatch = false;
  }
  else
  {
    stroke(0, 0, 0, 0);
    fill(0);
    rect(0, waves[0].buffHeight, width, height - waves[0].buffHeight);
  }

    
  for(int i = 0; i < waves.length; i++)
  {  
    waves[i].drawWave();
    drawShape(waves[i].shapeBuffer, waves[i].mirrorState);
  }
  

  surface.setTitle(frameRate + " fps");
  
  drawSelectedMidi();
}

void drawShape(PShape vector, int mirrorState) {

  switch(mirrorState)
  {
    case WaveGenerator.DEFAULT:
         shape(vector, 0, 0);
    break;
    case WaveGenerator.MIRRORHORIZ:
      vector.scale(0.5,1);     
      shape(vector, 0, 0);
      vector.scale(-1,1);
      shape(vector, waves[0].buffWidth, 0);    
    break;
    case WaveGenerator.MIRRORHORIZOVERLAP:
      shape(vector, 0, 0);
      vector.scale(-1,1);
      shape(vector, waves[0].buffWidth, 0);    
    break;
    case WaveGenerator.FLIPHORIZ:
      vector.scale(-1,1);
      shape(vector, waves[0].buffWidth, 0);    
    break;
    case WaveGenerator.MIRRORVERT:
      vector.scale(1,0.5);     
      shape(vector, 0, 0);
      vector.scale(1,-1);
      shape(vector, 0, waves[0].buffHeight);    
    break;
    case WaveGenerator.MIRRORVERTOVERLAP:
      shape(vector, 0, 0);
      vector.scale(1,-1);
      shape(vector, 0, waves[0].buffHeight);    
    break;
    case WaveGenerator.FLIPVERT:
      vector.scale(1,-1);
      shape(vector, 0,  waves[0].buffHeight);    
    break;
    case WaveGenerator.MIRRORHV:
      vector.scale(0.5,0.5);     
      shape(vector, 0, 0);
      vector.scale(-1,1);
      shape(vector, waves[0].buffWidth, 0);      
      vector.scale(1,-1);
      shape(vector,  waves[0].buffWidth, waves[0].buffHeight);   
      vector.scale(-1,1);
      shape(vector, 0, waves[0].buffHeight);   
    break;
    case WaveGenerator.MIRROROVERLAPHV:   
      shape(vector, 0, 0);
      vector.scale(-1,1);
      shape(vector, waves[0].buffWidth, 0);      
      vector.scale(1,-1);
      shape(vector,  waves[0].buffWidth, waves[0].buffHeight);   
      vector.scale(-1,1);
      shape(vector, 0, waves[0].buffHeight);   
    break;
  }
}

void drawSelectedMidi()
{
  stroke(255);
  fill(0, 0, 0, 0);
  rect(width / 2 - 700 , (int)waves[0].buffHeight + (currentMidiIndex * 102), 1150, 105);
}

//MIDI Handling
void noteOn(int channel, int pitch, int velocity)
{
  if(pitch >0 && pitch < 5)
  {
    currentMidiIndex = pitch -1;
  }
  else if(pitch == 13)
  {
    myClearBufferButton.setValue(!myClearBufferButton.getBooleanValue());
  }
  else if(pitch > 16 && pitch <= 32)
  {
    //Save
    save("presetm" + str(pitch - 16) + ".txt");
 
  }
  else if(pitch > 32 && pitch <= 48)
  {
    //Load    
      load("presetm" + str(pitch - 32) + ".txt");
   }
}


void controllerChange(int channel, int number, int value) {
  if(number > 12 && number <= 16)
  {
    HSBColourPickr cpicker = waves[currentMidiIndex].wgUI.myColorPicker;
    HandleColourChange(number, value, cpicker);
  } 
  else  
  {
    Knob knob;
    LFOKnob lfoKnob;
    switch(number)
    {   
      //1-8 - continous knobs 
      case 1:
        knob = waves[currentMidiIndex].wgUI.myKnobMirrorState;
        HandleKnobChange(knob, value);    
      break;
      case 2:      
        knob = waves[currentMidiIndex].wgUI.myKnobRate;
        HandleKnobChange(knob, value); 
      break;
      case 3:      
        knob = waves[currentMidiIndex].wgUI.myKnobTheta;
        HandleKnobChange(knob, value); 
      break;
      case 4:
        knob = waves[currentMidiIndex].wgUI.myKnobOffset;
        HandleKnobChange(knob, value);       
      break;
      case 5:
        knob = waves[currentMidiIndex].wgUI.myKnobScroll;
        HandleKnobChange(knob, value);       
      break;
      case 6:
        knob = waves[currentMidiIndex].wgUI.myKnobBend;
        HandleKnobChange(knob, value);       
      break;
      case 7:
        knob = waves[currentMidiIndex].wgUI.myKnobMask;
        HandleKnobChange(knob, value);       
      break;
      case 8:   
        knob = waves[currentMidiIndex].wgUI.myKnobWaveForm;
        HandleKnobChange(knob, value);      
      break;
     case 9:
        knob = waves[currentMidiIndex].wgUI.myKnobLFO1Rate;
        HandleKnobChange(knob, value);       
      break;
     case 10:
        knob = waves[currentMidiIndex].wgUI.myKnobLFO1Depth;
        HandleKnobChange(knob, value);       
      break;
     case 11:
        knob = waves[currentMidiIndex].wgUI.myKnobLFO2Rate;
        HandleKnobChange(knob, value);       
      break;
     case 12:
        knob = waves[currentMidiIndex].wgUI.myKnobLFO2Depth;
        HandleKnobChange(knob, value);       
      break;

      //17-24 buttons
      case 17:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobMirrorState;
        HandleLFOChange(lfoKnob);     
        break;
      case 18:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobRate;
        HandleLFOChange(lfoKnob);    
        break;
      case 19:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobTheta;
        HandleLFOChange(lfoKnob);    
        break;
      case 20:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobOffset;
        HandleLFOChange(lfoKnob);    
        break;
      case 21:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobScroll;
        HandleLFOChange(lfoKnob);    
        break;        
      case 22:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobBend;
        HandleLFOChange(lfoKnob);    
        break;        
      case 23:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobMask;
        HandleLFOChange(lfoKnob);    
        break;        
      case 24:
        lfoKnob = waves[currentMidiIndex].wgUI.myKnobWaveForm;
        HandleLFOChange(lfoKnob);    
        break;
        
      case 115:
        lfoKnob =  waves[currentMidiIndex].wgUI.myColorPicker.myHKnob;
        HandleLFOChange(lfoKnob);       
        break;
     case 116:
      lfoKnob =  waves[currentMidiIndex].wgUI.myColorPicker.mySKnob;
      HandleLFOChange(lfoKnob);                 
      break;
     case 117:
      lfoKnob =  waves[currentMidiIndex].wgUI.myColorPicker.myBKnob;
      HandleLFOChange(lfoKnob);                 
      break;
     case 118:
      lfoKnob =  waves[currentMidiIndex].wgUI.myColorPicker.myAKnob;
      HandleLFOChange(lfoKnob);                 
      break;
    }
  }
}

void HandleKnobChange(Knob knob, int value)
{
      float normValue = (float)value / 127.0;
      float min = knob.getMin();
      float max = knob.getMax();
      float range = max - min;
      float scaledValue = (normValue * range) + min;      
      knob.setValue(scaledValue);
}

void HandleLFOChange(LFOKnob knob)
{  
   boolean lfo1Active = knob.lfo1Button.getBooleanValue();
   boolean lfo2Active = knob.lfo2Button.getBooleanValue();
   if(lfo1Active && lfo2Active)
   {
     knob.lfo1Button.setValue(0);
   }
   else if(lfo1Active && !lfo2Active)
   {
     knob.lfo2Button.setValue(1);     
   }
   else if(!lfo1Active && lfo2Active)
   {
     knob.lfo2Button.setValue(0);          
   }
   else if(!lfo1Active && !lfo2Active)
   {
     knob.lfo1Button.setValue(1);          
   }
}

void HandleColourChange(int number, int value, HSBColourPickr cpicker)
{
    number = number -12;
    switch(number) 
    {    
    case 1: 
      float newHVal = ((float)value/127.0) * 255.0;
      cpicker.myHKnob.setValue(newHVal);
      break;
    case 2: 
      float newSVal = ((float)value/127.0) * 255.0;
      cpicker.mySKnob.setValue(newSVal);
      break;
     case 3: 
      float newBVal = ((float)value/127.0) * 255.0;
      cpicker.myBKnob.setValue(newBVal);
      break;
     case 4: 
      float newAVal = ((float)value/127.0) * 255.0;
      cpicker.myAKnob.setValue(newAVal);
      break;
    }
}