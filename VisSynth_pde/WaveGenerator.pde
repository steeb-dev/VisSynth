import controlP5.*;

class WaveGenerator
{  
  
  //Properties
  color currentColor;
  color[] waveValues;
  float theta = 0;
  float thetaRate = 0.2;
  float dx;
  float offset;
  float numWaves = 5;
  int scrollOffset = 0;
  int scrollRate = 0;
  boolean vertical = false; 
  PGraphics buffer;
  int layerIndex; 
  float mask;
  int waveType;
  
  float buffWidth;
  float buffHeight;
  WaveGenUI wgUI;
  float bendAmount; 
   
  //Wave Type constants
  final static int SINE = 1;
  final static int PULSE = 2;
  final static int RAMPUP = 3;
  final static int RAMPDOWN = 4;
  final static int TRI = 5;  
  
  //Constructor
  WaveGenerator(color c)
  {
    currentColor = c;
  }

  void setup(int index, ControlP5 cp5)
  {
    buffWidth = 640;
    buffHeight = 480;
    buffer = createGraphics((int)buffWidth, (int)buffHeight);

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
      case RAMPDOWN:
        CalcRampDownWave();
      break;
      case TRI:
        CalcTriWave();
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
  
  void CalcRampDownWave()
  {   
    for (int i = 0; i < waveValues.length; i++) 
    {
        waveValues[i] = color(red(currentColor), green(currentColor), blue(currentColor) ,( alpha(currentColor) * ((float)(waveValues.length - i) / (float)waveValues.length) ) * thetaRate);
    }
  }
  
  void CalcTriWave()
  {   
    for (int i = 0; i < waveValues.length; i++) 
    {
      if(i < (waveValues.length /2))
      {
        waveValues[i] = color(red(currentColor), green(currentColor), blue(currentColor) , alpha(currentColor) * ((float)i / ((float)(waveValues.length)/2)) * thetaRate);
      }
      else 
      {    
        waveValues[i] = color(red(currentColor), green(currentColor), blue(currentColor) , alpha(currentColor) * ((((float)waveValues.length - (float)i) / (((float)waveValues.length)/2.0))) * thetaRate);   
      }
    }
  }


  void drawWave()
  {    

    wgUI.UpdateControls();
    calcWave();
    buffer.beginDraw();
    buffer.clear();
    if(!vertical)
    {
      drawHoriz();      
    }
    else
    {
      drawVert();
    }
    buffer.endDraw();
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
        if(draw) drawOffsetLines(false, midPoint, 0, tempy, sineOffset, tempy, sineOffset, tempy, (int)buffWidth, tempy, waveValues[i]);
        sineOffset += offset; 
      }
      else
      {
        if(draw) drawSingleLine(false, midPoint, 0, tempy, (int)buffWidth, tempy, waveValues[i]);
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
        if(draw) drawOffsetLines(true, midPoint, tempx, 0, tempx, sineOffset, tempx, sineOffset, tempx, (int)buffHeight, waveValues[i]);    
        sineOffset += offset; 
      }
      else
      {
        if(draw) drawSingleLine(true, midPoint, tempx, 0, tempx, (int)buffHeight, waveValues[i]);
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
          {
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
    
  void drawOffsetLines(boolean vert, int midPoint, int line1StartX, int line1StartY, int line1EndX, int line1EndY, int line2StartX, int line2StartY, int line2EndX, int line2EndY, color stroke)
  {
    if(bendAmount != 0)
    {
      if(vert) 
      {
        if(bendAmount > 0)
        {
            buffer.line(line1StartX, line1StartY, midPoint, line1EndY);            
            buffer.stroke(stroke);
            buffer.line(midPoint, line2StartY, line2EndX, line2EndY);             
        }      
        else
        {          
            buffer.line(midPoint, line1StartY, line1EndX, line1EndY);           
            buffer.stroke(stroke);
            buffer.line(line2StartX, line2StartY,  midPoint, line2EndY);                
        }
      }
      else
      {
        if(bendAmount > 0)
        {
          buffer.line(line1StartX, line1StartY, line1EndX, midPoint);
          buffer.stroke(stroke);
          buffer.line(line2StartX, midPoint, line2EndX, line2EndY);      
        }   
        else
        {
          buffer.line(line1StartX, midPoint, line1EndX, line2EndY);
          buffer.stroke(stroke);
          buffer.line(line2StartX, line1StartY, line2EndX, midPoint);                
      }
      }     
    }
    else
    {
      buffer.line(line1StartX, line1StartY, line1EndX, line1EndY);
      buffer.stroke(stroke);
      buffer.line(line2StartX, line2StartY, line2EndX, line2EndY);    
    }
  }
    
  void drawSingleLine(boolean vert, int midPoint, int line1StartX, int line1StartY, int line1EndX, int line1EndY, color stroke)
  {
    buffer.stroke(stroke);
    if(bendAmount != 0)
    {
      if(vert) 
      {
       if(bendAmount > 0)
        {
          buffer.line(line1StartX, line1StartY, midPoint, line1EndY);           
        }
        else
        {
          buffer.line(midPoint, line1StartY, line1EndX, line1EndY); 
        }
      }
      else
      {
       if(bendAmount > 0)
        {
          buffer.line(line1StartX, line1StartY, line1EndX, midPoint);
        }
        else
        {
          buffer.line(line1StartX, midPoint, line1EndX, line1EndY);
        }
      }
    }
    else
    {
      buffer.line(line1StartX, line1StartY, line1EndX, line1EndY);
    }
  }
}