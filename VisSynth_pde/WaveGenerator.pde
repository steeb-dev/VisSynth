import controlP5.*;

class WaveGenerator
{    
  //Properties  
  float buffWidth;
  float buffHeight;
  color[] waveValues;
  float theta = 0;
  float thetaRate = 0.2;
  float dx;
  int scrollOffset = 0;
  PShape shapeBuffer;
  int layerIndex; 
  WaveGenUI wgUI;

  //UI control props
  color currentColor;
  float offset;
  float numWaves = 5;
  int scrollRate = 0;
  boolean vertical = false; 
  int mirrorState = 0;
  int waveType;
  float bendAmount; 
  float mask;
  LFO lfo1;
  LFO lfo2;
  
    
  //Wave Type constants
  final static int SINE = 1;
  final static int PULSE = 2;
  final static int RAMPUP = 3;
  final static int NOISE = 4;
  
  
  //Mirror constants
  final static int DEFAULT = 0;
  final static int MIRRORHORIZ = 1;
  final static int MIRRORHORIZOVERLAP = 2;
  final static int FLIPHORIZ = 3;
  final static int MIRRORVERT = 4;
  final static int MIRRORVERTOVERLAP = 5;
  final static int FLIPVERT = 6;
  final static int MIRRORHV = 7;
  final static int MIRROROVERLAPHV = 8;
  
  //Constructor
  WaveGenerator(color c)
  {
    currentColor = c;
    lfo1 = new LFO();
    lfo2 = new LFO();
  }

  void setup(int index, ControlP5 cp5)
  {
    buffWidth = width;
    buffHeight = height * 0.60;

    layerIndex = index;
    
    wgUI = new WaveGenUI();
    wgUI.Setup(this, cp5);
    prepWaveBuffer();
  }
    
  void prepWaveBuffer()
  {
    if(!vertical)
    {
      dx = (TWO_PI / buffHeight) * numWaves;
      waveValues = new color[(int)(buffHeight/numWaves)];
    }
    else
    {    
      dx = (TWO_PI / buffWidth) * numWaves;
      waveValues = new color[(int)((float)buffWidth/numWaves)];
    }
  }
  
  void calcWave() 
  {
   // Increment theta (try different values for 'angular velocity' here
      theta += thetaRate;
  
    switch(waveType)
    {
      case PULSE:
        CalcPulseWave();      
      break;
      case SINE:
        CalcSineWave();
      break;
      case RAMPUP:
        CalcRampUpWave();
      break;
      case NOISE:
        CalcNoiseWave();
      break;
    }
  }

  void CalcPulseWave()
  {
    int coloredLines = (int)((float)waveValues.length * thetaRate);
    for (int i = 0; i < waveValues.length; i++) 
    {   
        if(i < coloredLines)
        {
          waveValues[i] = currentColor;
        }
        else
        {
            waveValues[i] = color(1,1,1,0);
        }
    }
  }
  
  
  void CalcSineWave()
  {   
    // For every x value, calculate a y value with sine function
    float x = theta;
    for (int i = 0; i < waveValues.length; i++) 
    {
        float alpha = sin(x); 
        waveValues[i] = color(red(currentColor), green(currentColor), blue(currentColor) , alpha(currentColor) * alpha);
        x+=dx;        
    }
  }
  
  void CalcRampUpWave()
  {   
    for (int i = 0; i < waveValues.length; i++) 
    {
        waveValues[i] = color(red(currentColor), green(currentColor), blue(currentColor) ,( alpha(currentColor) * ((float)i / (float)waveValues.length)) * thetaRate);
    }
  }


  void CalcNoiseWave()
  {   
    for (int i = 0; i < waveValues.length; i++) 
    {
        waveValues[i] = color(red(currentColor), green(currentColor), blue(currentColor) ,( alpha(currentColor) * random(0,1)));
    }
  }


  void drawWave()
  {    
    lfo1.update();    
    lfo2.update();

    wgUI.UpdateControls();
  
      shapeBuffer = createShape();
      shapeBuffer.beginShape();
      calcWave();
    
      if(!vertical)
      {
        drawHoriz();      
      }
      else
      {
        drawVert();
      }
      
      shapeBuffer.endShape(CLOSE);  
  }
  
  void drawHoriz()
  {    
    int midPoint = (int)buffHeight / 2;

    int sineOffset = 0; 
    int i = 0;
    for(int y = 0; y <= buffHeight; y++)
    {  
      boolean draw = checkMask(y, false); 
      int tempy = y + scrollOffset;
      if(tempy >= buffHeight) tempy = tempy - (int)buffHeight;
      else if(tempy <= 0) tempy = (int)buffHeight;
      if(offset>0)
      {
        if(sineOffset > buffWidth) sineOffset = sineOffset - (int)buffWidth;
        if(draw) drawOffsetVertices(false, midPoint, 0, tempy, sineOffset, tempy, sineOffset, tempy, (int)buffWidth, tempy, waveValues[i]);
        sineOffset += offset; 
      }
      else
      {
        if(draw) 
        {
           drawSingleVertices(false, midPoint, 0, tempy, (int)buffWidth, tempy, waveValues[i]);
        }
      }   
      i++;
      if(i >= waveValues.length)
      {
        i = 0;
      }
    } 
  }
    
  void drawVert()
  {    
    int midPoint = (int)buffWidth / 2;
    
    int sineOffset = 0; 
    int i = 0;
    for(int x = 0; x <= buffWidth; x++)
    {      
      boolean draw = checkMask(x, true);

      int tempx = x + scrollOffset;
      if(tempx >= buffWidth) tempx = tempx - (int)buffWidth;
      else if(tempx < 0) tempx = (int)buffWidth + tempx;
      
      if(offset>0)
      {
        if(sineOffset > buffHeight) sineOffset = sineOffset -  (int)buffHeight;
        if(draw) 
        {
          drawOffsetVertices(true, midPoint, tempx, 0, tempx, sineOffset, tempx, sineOffset, tempx, (int)buffHeight, waveValues[i]);    
        }
        sineOffset += offset; 
      }
      else
      {  
         if(draw)
         {
           drawSingleVertices(true, midPoint, tempx, 0, tempx, (int)buffHeight, waveValues[i]);
         }
      }   
      i++;
      if(i >= waveValues.length)
      {
        i = 0;
      }
    } 
  }
  
  boolean checkMask(int index, boolean vert)
  {
      boolean draw = false;
      if(mask > 0 || mask < 0)
      {
        int rowStart;
        int rowEnd;
        
        if(vert)
        {
          if(mask > 0)
          { //<>//
             rowEnd = (int)buffWidth;
             rowStart = (int)(mask * buffWidth);          
          }
          else
          {
             rowStart = 0;
             rowEnd = (int)((mask + 1) * buffWidth);
          }
        }
        else
        {
          if(mask > 0)
          {
             rowEnd = (int)buffHeight;
             rowStart = (int)(mask * buffHeight);          
          }
          else
          {
             rowStart = 0;
             rowEnd = (int)((mask + 1) * buffHeight);
          }        
        }
               
        if(index > rowStart && index < rowEnd)
        {
          draw = true;
        }
      }
      else
      {
        draw = true; 
      }
      
      return draw;
  }    
  
  void drawOffsetVertices(boolean vert, int midPoint, int line1StartX, int line1StartY, int line1EndX, int line1EndY, int line2StartX, int line2StartY, int line2EndX, int line2EndY, color stroke)
  {
    if(bendAmount != 0)
    {
      if(vert) 
      {
       if(bendAmount > 0)
        {
          line1EndX = (int)lerp((float)line1EndX, (float)midPoint, bendAmount);
          line2StartX = (int)lerp((float)line1EndX, (float)midPoint, bendAmount);
        }
        else
        {
          line1StartX = (int)lerp((float)midPoint, (float)line1StartX, bendAmount);
          line2EndX = (int)lerp((float)midPoint, (float)line2EndX,bendAmount);
        }
      }
      else
      {
       if(bendAmount > 0)
        {
          line1EndY = (int)lerp((float)line1EndY, (float)midPoint, bendAmount);
          line2StartY = (int)lerp((float)line1EndY, (float)midPoint, bendAmount);
        }
        else
        {
          line1StartY = (int)lerp((float)midPoint, (float)line1StartY, bendAmount);
          line2EndY = (int)lerp((float)midPoint, (float)line2EndY, bendAmount);
        }
      }
    }
    shapeBuffer.beginContour();
    shapeBuffer.vertex(line1StartX, line1StartY);
    shapeBuffer.vertex(line1EndX, line1EndY);
    shapeBuffer.endContour();
    
    shapeBuffer.stroke(stroke);
  
    shapeBuffer.beginContour();   
    shapeBuffer.vertex(line2StartX, line2StartY);
    shapeBuffer.vertex(line2EndX, line2EndY);    
    shapeBuffer.endContour();
  }

    
  void drawSingleVertices(boolean vert, int midPoint, int lineStartX, int lineStartY, int lineEndX, int lineEndY, color stroke)
  {
    if(bendAmount != 0)
    {
      if(vert) 
      {
       if(bendAmount > 0)
        {
          lineEndX = (int)lerp((float)lineEndX, (float)midPoint, bendAmount);
        }
        else
        {
          lineStartX = (int)lerp((float)midPoint, (float)lineStartX, bendAmount);
        }
      }
      else
      {
       if(bendAmount > 0)
        {
          lineEndY = (int)lerp((float)lineEndY, (float)midPoint, bendAmount);
        }
        else
        {
          lineStartY = (int)lerp((float)midPoint, (float)lineStartY, bendAmount);
        }
      }
    }

    
    shapeBuffer.stroke(stroke);
    
    shapeBuffer.beginContour();
    shapeBuffer.vertex(lineStartX, lineStartY);
    shapeBuffer.vertex(lineEndX, lineEndY);
    shapeBuffer.endContour();
  }
}