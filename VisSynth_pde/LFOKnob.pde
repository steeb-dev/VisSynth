class LFOKnob extends Knob
{
  LFO lfo1;
  LFO lfo2;
    
  Toggle lfo1Button;
  Toggle lfo2Button;
  
  LFOKnob(ControlP5 theControlP5 , String theName, LFO lf1, LFO lf2, int x, int y, int radius)
  {
    super(theControlP5 , theName); 
    lfo1 = lf1;
    lfo2 = lf2;    
    super.setPosition(x, y);
    super.setRadius(radius);

    lfo1Button = theControlP5.addToggle(theName + "lfo1")
           .setPosition(x + 10, y - 20)
           .setSize(15,15)
           .setLabel("")
           .setValue(0);    
            
    lfo2Button = theControlP5.addToggle(theName + "lfo2")
           .setPosition(x + 30, y - 20)
           .setSize(15,15)
           .setLabel("")
           .setValue(0); 
  }
  
  float getValue()
  {
    if(lfo1Button != null && lfo2Button != null)
    {
      boolean lfo1Active = lfo1Button.getBooleanValue();
      boolean lfo2Active = lfo2Button.getBooleanValue();
      if(lfo1Active || lfo2Active)
      {
        float range = super.getMax() - super.getMin();
        float lfodValue = 0;
        if(lfo1Active)
        {
          lfodValue += range * lfo1.sinValue * lfo1.depth;
        }
        if(lfo2Active)
        {
          lfodValue += range * lfo2.sinValue * lfo2.depth;
        }
        float newValue = super.getValue() + lfodValue;
        if(newValue > super.getMax()) newValue = super.getMax();
        if(newValue < super.getMin()) newValue = super.getMin();
        return newValue;
      }
    }
    return super.getValue();
  }
  
    class LFOKnobView implements ControllerView< LFOKnob > {

    public void display( PGraphics theGraphics , LFOKnob theController ) {
      theGraphics.translate( ( int ) getRadius( ) , ( int ) getRadius( ) );

      theGraphics.pushMatrix( );
      theGraphics.ellipseMode( PApplet.CENTER );
      theGraphics.noStroke( );
      theGraphics.fill( getColor( ).getBackground( ) );
      theGraphics.ellipse( 0 , 0 , getRadius( ) * 2 , getRadius( ) * 2 );
      theGraphics.popMatrix( );
      int c = isActive( ) ? getColor( ).getActive( ) : getColor( ).getForeground( );
      theGraphics.pushMatrix( );
      if ( getViewStyle( ) == Controller.LINE ) {
        theGraphics.rotate( getAngle( ) );
        theGraphics.stroke( c );
        theGraphics.strokeWeight( getTickMarkWeight( ) );
        theGraphics.line( 0 , 0 , getRadius( ) , 0 );
      } else if ( getViewStyle( ) == Controller.ELLIPSE ) {
        theGraphics.rotate( getAngle( ) );
        theGraphics.fill( c );
        theGraphics.ellipse( getRadius( ) * 0.75f , 0 , getRadius( ) * 0.2f , getRadius( ) * 0.2f );
      } else if ( getViewStyle( ) == Controller.ARC ) {
        theGraphics.fill( c );
        theGraphics.arc( 0 , 0 , getRadius( ) * 1.8f , getRadius( ) * 1.8f , getStartAngle( ) , getAngle( ) + ( ( getStartAngle( ) == getAngle( ) ) ? 0.06f : 0f ) );
        theGraphics.fill( theGraphics.red( getColor( ).getBackground( ) ) , theGraphics.green( getColor( ).getBackground( ) ) , theGraphics.blue( getColor( ).getBackground( ) ) , 255 );
        theGraphics.ellipse( 0 , 0 , getRadius( ) * 1.2f , getRadius( ) * 1.2f );
      }
      theGraphics.popMatrix( );

      theGraphics.pushMatrix( );
      theGraphics.rotate( getStartAngle( ) );

      if ( isShowTickMarks( ) ) {
        float step = getAngleRange( ) / getNumberOfTickMarks( );
        theGraphics.stroke( getColor( ).getForeground( ) );
        theGraphics.strokeWeight( getTickMarkWeight( ) );
        for ( int i = 0 ; i <= getNumberOfTickMarks( ) ; i++ ) {
          theGraphics.line( getRadius( ) + 2 , 0 , getRadius( ) + getTickMarkLength( ) + 2 , 0 );
          theGraphics.rotate( step );
        }
      } else {
        if ( isShowAngleRange( ) ) {
          theGraphics.stroke( getColor( ).getForeground( ) );
          theGraphics.strokeWeight( getTickMarkWeight( ) );
          theGraphics.line( getRadius( ) + 2 , 0 , getRadius( ) + getTickMarkLength( ) + 2 , 0 );
          theGraphics.rotate( getAngleRange( ) );
          theGraphics.line( getRadius( ) + 2 , 0 , getRadius( ) + getTickMarkLength( ) + 2 , 0 );
        }
      }
      theGraphics.noStroke( );
      theGraphics.popMatrix( );

      theGraphics.pushMatrix( );
      theGraphics.translate( -getWidth( ) / 2 , -getHeight( ) / 2 );
      if ( isLabelVisible ) {
        _myCaptionLabel.draw( theGraphics , 0 , 0 , theController );
        _myValueLabel.align( ControlP5.CENTER , ControlP5.CENTER );
        _myValueLabel.draw( theGraphics , 0 , 0 , theController );
      }
      theGraphics.popMatrix( );

    }
  }

}