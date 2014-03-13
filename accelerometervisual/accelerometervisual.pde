/******************************************************************************************************************************************************************************************
                                                                                LOG - DAYS WORKING
******************************************************************************************************************************************************************************************/
//  16-6-2013    -    Some basic Accelerometer testing was finished with Arduino platform before this date, along with Processing serial interface + basic UI 
//  17-6-2013    -    Collected libraries & Learned them - Started Integrating UI Objects
//  18-6-2013    -    Developing/Integrating UI Objects
//  19-6-2013    -    Some more improvement
//  20-6-2013    -    Appended more Visualization
//  25-6-2013    -    Adjustments in Visualization


/******************************************************************************************************************************************************************************************
                                                                             ATTRIBUTIONS & LICENSE
******************************************************************************************************************************************************************************************/

/*
  All Code written here were modularily reused from ControlP5 - enabling reusability with Processing.
  Code written is not for Commercial Purpose
  CC-BY-SA
*/
/*****************************************************************************************************************************************************************************************/

import processing.serial.*    ;                                             // Serial port Library
import controlP5.*            ;                                             // Control P5 GUI Library
import processing.opengl.*    ;

Serial arduinoport      ;                                               // Object of Serial Class
ControlP5 cp5           ;                                               // Object of ControlP5 Class

PFont font              ;
PImage BGImage          ;
Range PitchRange        ;
Range RollRange         ;
Range FallRange         ;
Chart PitchBarChart     ;
Chart PitchLineChart    ;
Chart PitchPieChart     ;
Chart PitchAreaChart    ;
Chart RollBarChart      ;
Chart RollLineChart     ;
Chart RollPieChart      ;
Chart RollAreaChart     ;
Chart FallBarChart      ;
Chart FallLineChart     ;
Chart FallPieChart      ;
Chart FallAreaChart     ;

int rxbyte = 0          ;                                                // Serial protocol Data package configuration
int linefeed = 10       ;
char rxdelim = '#'      ;
String rxstring = null  ;


int lv = 0 , avg = 100          ;
int ChartPoints  = 1000         ;
float ChartLPP = 0.0 ;
float ChartLRP = 0.0 ;
float ChartLFP = 0.0 ;

boolean AutoCalibFlag = false   ;
boolean ManuCalibFlag = false   ;
boolean pF = false , rF = false , fF = false  ;
boolean BarCF = false , LineCF = false , PieCF = false , AreaCF = false ;

float acc[] = {0.0,0.0,0.0}                   ;
float p = 0.0 , r = 0.0 , f = 0.0             ;
float pitch = 0.0 , roll = 0.0 , fall = 0.0   ;
float minIp = 0.0 , maxIp = 0.0               ;
float minIr = 0.0 , maxIr = 0.0               ;
float minIf = 0.0 , maxIf = 0.0               ;
float minOp = 0.0 , maxOp = 0.0               ;
float minOr = 0.0 , maxOr = 0.0               ;
float minOf = 0.0 , maxOf = 0.0               ;

int bgcolour = 0 ;

int win_w = 1920 ; //1200 ;      // for explicit testing
int win_h = 1080 ; //600 ;


void setup ()
{
  win_w = displayWidth  ; //1920   ;
  win_h = displayHeight ; //1080   ;
  
  size(int( win_w = win_w - 10 ), int( win_h =  win_h - 55 ), P3D);
  frame.setResizable(true);
  smooth();
  noStroke();
  specular(204, 102, 0);
  
  gui();
  
  println(Serial.list()) ;                                              // Get the available serial ports
  arduinoport = new Serial(this, Serial.list()[0], 57600, 'N', 8, 1.0) ; // Parent is the instant of this program
                                                                        // Serial port name will be returned by list --> scanned ports with index 0
                                                                        // No parity
                                                                        // 8 bits
                                                                        // 1 stop bit
  
  
  AutoCalibFlag = false ;
  pF = false ;
  rF = false ;
  fF = false ;
  BarCF = false  ;
  LineCF = false ;
  PieCF = false  ;
  AreaCF = false ;
  ChartPoints = 10;  
  
  arduinoport.bufferUntil(linefeed);
  
}

void draw ()
{  
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
    
  background( bgcolour )                             ;
  if (BarCF == true ){PitchBarChart.getColor().setBackground(color(255-bgcolour, 100))  ;  
                       RollBarChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                       FallBarChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                     }
  if (LineCF == true ){PitchLineChart.getColor().setBackground(color(255-bgcolour, 100)) ;  
                       RollLineChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                       FallLineChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                     }                     
  if (PieCF == true ){PitchPieChart.getColor().setBackground(color(255-bgcolour, 100))  ;  
                       RollPieChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                       FallPieChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                     }                     
  if (AreaCF == true ){PitchAreaChart.getColor().setBackground(color(255-bgcolour, 100)) ;  
                       RollAreaChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                       FallAreaChart.getColor().setBackground(color(255-bgcolour, 100))  ;
                     }                     
  translate(int(win_w/2) , int(win_h/2) , 0)         ;
    
  strokeWeight(3)                                    ;
  strokeJoin(ROUND)                                  ;
  stroke(204,102,0)                                  ;
  
  if ( pF == true )
  { 
    rotateX(pitch)                        ;  // PITCH Sense == Rotation along XY Plane keeping horizontal axis of rotation constant
    if (BarCF  == true){cp5.getController("PitchBNumBox").setValue(pitch); 
                        PitchBarChart.push("PitchBC", pitch);    }
    if (LineCF == true){                        
                          cp5.getController("PitchLNumBox").setValue(pitch);  
                          PitchLineChart.addData("PitchLC", pitch); 
                          if(PitchLineChart.getDataSet("PitchLC").size()>ChartPoints) 
                            {PitchLineChart.removeData("PitchLC",0);}
                        }
    if (PieCF  == true){cp5.getController("PitchPNumBox").setValue(pitch);}
    if (AreaCF == true){cp5.getController("PitchANumBox").setValue(pitch);}
  }
  if ( rF == true )
  {
    rotateY(roll)                                    ;  // ROLL  Sense == Rotation along XY Plane keeping vertical   axis of rotation constant
    if (BarCF  == true){cp5.getController("RollBNumBox").setValue(roll);
                        RollBarChart.push("RollBC", roll);    }
    if (LineCF == true){
                          cp5.getController("RollLNumBox").setValue(roll);
                          RollLineChart.addData("RollLC", roll);  
                          if(RollLineChart.getDataSet("RollLC").size()>ChartPoints) 
                            {RollLineChart.removeData("RollLC",0);}
                       }
    if (PieCF  == true){cp5.getController("RollPNumBox").setValue(roll);}
    if (AreaCF == true){cp5.getController("RollANumBox").setValue(roll);}        
  }
  if ( fF == true )
  {
    rotateZ(fall)                                    ;  // FALL  Sense == No Rotation only Fall  -- acceleration due to gravity perpendicular to XY Plane
    if (BarCF  == true){cp5.getController("FallBNumBox").setValue(fall);
                        FallBarChart.push("FallBC", fall);    }
    if (LineCF == true){
                          cp5.getController("FallLNumBox").setValue(fall);
                          FallLineChart.addData("FallLC", fall);  
                          if(FallLineChart.getDataSet("FallLC").size()>ChartPoints) 
                          {FallLineChart.removeData("FallLC",0);}
                       }
    if (PieCF  == true){cp5.getController("FallPNumBox").setValue(fall);}
    if (AreaCF == true){cp5.getController("FallANumBox").setValue(fall);}    
  }
  fill(100,150,0)                                    ;
  box( 150, 200, 2 )                                 ;  
  
  popMatrix();
  hint(DISABLE_DEPTH_TEST);  
}

/******************************************************************************************************************************************************************************************
                                                                            EVENTS & Service Procedures
******************************************************************************************************************************************************************************************/

public void serialEvent(Serial arduinoport)
{
  minOp = minOr = minOf = -1.0 ;          //  Output Minimum Range
  maxOp = maxOr = maxOf =  1.0 ;          //  Output Maximum Range
  
  rxstring = arduinoport.readStringUntil(linefeed) ;  // Read until LF
  
  if ( rxstring != null )
  {
    rxstring = trim ( rxstring ) ;                    // Remove empty spaces
    acc = float ( split ( rxstring, rxdelim ) ) ;     // Split based on delimeter & Acquire
    
    if ( AutoCalibFlag == false )                         // Data mapping after Calibration
    {
        pitch =  map(acc[0], minIp , maxIp, minOp, maxOp) ; pitch = (-1) * pitch ;  // Pitch plane is provided as reverse in Sensor
         roll =  map(acc[1], minIr , maxIr, minOr, maxOr) ;
         fall =  map(acc[2], minIf , maxIf, minOf, maxOf) ;
    }
    
    if ( AutoCalibFlag == true )                          // Calibration -- Simple Averaging for Minimum of Input Range
    {
      p = p + acc[0] ; 
      r = r + acc[1] ; 
      f = f + acc[2] ;
      
      lv++ ;
      
      cp5.getController("AutoCalibSlide").setValue(lv);  // Show the progress
      
      if ( lv == avg )
      {
        minIp = p/avg ; 
        maxIp = 480 ;
        minIr = r/avg ; 
        maxIr = 480 ;
        minIf = f/avg ; 
        maxIf = 480 ;       
        
          PitchRange.setRangeValues(minIp,maxIp);
                    
          RollRange.setRangeValues(minIr,maxIr);                   
                    
          FallRange.setRangeValues(minIf,maxIf);
                    
          
          lv = 0 ;                                    // Reset the parameters to facilitate user recalibration if needed
          p  = 0 ;
          r  = 0 ;
          f  = 0 ;
          AutoCalibFlag = false ;
      }
    }     
  }   
}

void controlEvent(ControlEvent theControlEvent)                           // GUI Controller Object Events
{
  int eid = 0 ;
  
  if(theControlEvent.isFrom("PitchRange")) 
  {
    minIp = theControlEvent.getController().getArrayValue(0);    // minimum of Pitch Range
    maxIp = theControlEvent.getController().getArrayValue(1);    // maximum of Pitch Range
  }
  if(theControlEvent.isFrom("RollRange"))
  {
    minIr = theControlEvent.getController().getArrayValue(0);    // minimum of Roll Range
    maxIr = theControlEvent.getController().getArrayValue(1);    // maximum of Roll Range
  }
  if(theControlEvent.isFrom("FallRange"))
  {
    minIf = theControlEvent.getController().getArrayValue(0);    // minimum of Fall Range
    maxIf = theControlEvent.getController().getArrayValue(1);    // maximum of Fall Range
  }

  if(theControlEvent.isTab())
  {
    eid = theControlEvent.getTab().getId() ;    // Get Tab id for Tab events
    
    switch(eid)
    {
      case 6:                  
          
               BarCF = true ; LineCF = false ; PieCF = false ; AreaCF = false ;
               PitchBarChart.setPosition(win_w-300,win_h-650).setSize(50, 550).setView(Chart.BAR).moveTo("Bar Chart").setData("PitchBC", new float[1]).setRange(-2, 2);
                RollBarChart.setPosition(win_w-200,win_h-650).setSize(50, 550).setView(Chart.BAR).moveTo("Bar Chart").setData("RollBC",  new float[1]).setRange(-2, 2);
                FallBarChart.setPosition(win_w-100,win_h-650).setSize(50, 550).setView(Chart.BAR).moveTo("Bar Chart").setData("FallBC",  new float[1]).setRange(-2, 2);
               
      break ;            
      
      case 7:
               BarCF = false ; LineCF = true ; PieCF = false ; AreaCF = false ;
               PitchLineChart.setPosition(win_w-500,win_h-625).setSize(400, 150).setView(Chart.LINE).moveTo("Line Chart").setData("PitchLC", new float[1]).setRange(-2, 2);
                RollLineChart.setPosition(win_w-500,win_h-425).setSize(400, 150).setView(Chart.LINE).moveTo("Line Chart").setData("RollLC",  new float[1]).setRange(-2, 2);
                FallLineChart.setPosition(win_w-500,win_h-225).setSize(400, 150).setView(Chart.LINE).moveTo("Line Chart").setData("FallLC",  new float[1]).setRange(-2, 2);
                                               
      break ;
      
      case 8:
               BarCF = false ; LineCF = false ; PieCF = true ; AreaCF = false ;
               PitchPieChart.setPosition(win_w-500,win_h-625).setSize(400, 150).setView(Chart.PIE).moveTo("Pie Chart").setData("PitchRC", new float[1]).setRange(-2,2);
                RollPieChart.setView(Chart.PIE);
                FallPieChart.setView(Chart.PIE); 
                                
      break ;      
      
      case 9:
               BarCF = false ; LineCF = false ; PieCF = false ; AreaCF = true ;
               PitchAreaChart.setView(Chart.AREA);
                RollAreaChart.setView(Chart.AREA);
                FallAreaChart.setView(Chart.AREA);
                                
      break ;
    }
  }  
  
}


public void BGSlide ( int value )
{
  bgcolour = value ;
}

public void AutoCalibButt()
{
  AutoCalibFlag = true  ;
  ManuCalibFlag = false ;
  cp5.getController("AutoCalibSlide").setValue(0);
}

public void ManuCalibButt()
{
  AutoCalibFlag = false  ;
  ManuCalibFlag = true ;
  cp5.getController("ManuCalibSlide").setValue(0);
}

public void PitchEnableButt()
{
  if ( pF == false )
  {
    pF = true ;
  }
  else if ( pF == true )
  {
    pF = false ;
  }
}

public void PitchRange ( int value )
{
  minIp = value ;    // Set the Pitch Range  
  maxIp = 480.0 ;
}

public void RollEnableButt()
{
  if ( rF == false )
  {
    rF = true ;
  }
  else if ( rF == true )
  {
    rF = false ;
  }
}

public void RollRange ( int value )
{
  minIr = value ;    // Set the Roll Range
  maxIr = 480.0 ;  
}

public void FallEnableButt()
{
  if ( fF == false )
  {
    fF = true ;
  }
  else if ( fF == true )
  {
    fF = false ;
  }
}

public void FallRange ( int value )
{
  minIf = value ;    // Set the Fall Range
  maxIf = 480.0 ;
}

public void DataPointsSlide ( int value )
{
  if ( value >= ChartPoints )  
  {    
    ChartPoints = value ;
  }
  if ( value < ChartPoints )
  {
    PitchLineChart.removeData("PitchLC",ChartPoints);
    ChartPoints = value ;
  }
}

public void LineWidth ( float value )
{
    PitchLineChart.setStrokeWeight(value);
     RollLineChart.setStrokeWeight(value);
     FallLineChart.setStrokeWeight(value);
}

/******************************************************************************************************************************************************************************************
                                                                                 Functionalities
******************************************************************************************************************************************************************************************/

public void gui()
{
  
cp5 = new ControlP5(this);                                            // Instantiating ControlP5 object
                                                                      // Arrange the UI CP5 objects
  
    cp5.getTab("default")                                  // UI SETTING TAB
       .activateEvent(false)
       .setVisible(false); 
       
    cp5.addTab("UISettings")
       .setLabel("UI Settings")
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0))       
       .bringToFront();      
    
    cp5.getTab("UISettings")
       .activateEvent(true)
       .setId(2);    
       
    cp5.addTab("AutoCalib")                                // AUTOMATIC CALIBRATION TAB
       .setLabel("Automatic Calibration")
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));     
    
    cp5.getTab("AutoCalib")
       .activateEvent(true)
       .setId(3);    
       
    cp5.addTab("ManuCalib")                                // MANUAL CALIBRATION TAB
       .setLabel("Manual Calibration") 
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));

    cp5.getTab("ManuCalib")
       .activateEvent(true)
       .setId(4);
       
    cp5.addTab("Emulation")                               // EMULATION TAB
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));       
    
    cp5.getTab("Emulation")
       .activateEvent(true)
       .setId(5);       
  
    cp5.addTab("Bar Chart")                               // BAR CHART TAB
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));
    
    cp5.getTab("Bar Chart")                               
       .activateEvent(true)
       .setId(6);
       
    cp5.addTab("Line Chart")                              // LINE CHART TAB
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));     
    
    cp5.getTab("Line Chart")
       .activateEvent(true)
       .setId(7);
       
    cp5.addTab("Pie Chart")                              // PIE CHART TAB
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));     
    
    cp5.getTab("Pie Chart")
       .activateEvent(true)
       .setId(8);  
       
    cp5.addTab("Area Chart")                             // AREA CHART TAB
       .setColorBackground(color(0, 160, 100))
       .setColorLabel(color(255))
       .setColorActive(color(255,128,0));
  
      cp5.getTab("Area Chart")
       .activateEvent(true)
       .setId(9);      
    

  cp5.begin(25,25);  
  
    cp5.addSlider("BGSlide", 0 , 255 , 25 , win_h-50 , 100 , 25 )          // Background colour --> UI Visualization Tab
       .setCaptionLabel("Background")
       .moveTo("UISettings");    
    cp5.getController("BGSlide")
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .getStyle()
       .setPadding(4,4,3,4)
       .setMargin(-4,0,0,0);

    cp5.addButton("AutoCalibButt")                                    // Automatic calibration --> Automatic Calibration Tab
       .setPosition(50,100)
       .setValue(0)
       .setSize(100,20)
       .getCaptionLabel()
       .align(CENTER,CENTER);
    cp5.getController("AutoCalibButt")
       .setCaptionLabel("AUTOMATIC CALIBRATION");       
    cp5.getController("AutoCalibButt")
       .moveTo("AutoCalib");
    cp5.getController("AutoCalibButt")
       .moveTo("AutoCalib");       
    
    cp5.addSlider("AutoCalibSlide", 0 , avg, 160, 100, 300, 20)
       .moveTo("AutoCalib");                    
    cp5.getController("AutoCalibSlide")
       .setCaptionLabel("");        
    
    cp5.addButton("ManuCalibButt")                                    // Manual calibration --> Manual Calibration Tab
       .setPosition(50,100)
       .setValue(0)
       .setSize(100,20)
       .getCaptionLabel().align(CENTER,CENTER);
    cp5.getController("ManuCalibButt")
       .setCaptionLabel("MANUAL CALIBRATION");     
    cp5.getController("ManuCalibButt")
       .moveTo("ManuCalib");
  
    cp5.addSlider("ManuCalibSlide", 0 , avg, 160, 100, 300, 20)
       .moveTo("ManuCalib");
    cp5.getController("ManuCalibSlide")
       .setCaptionLabel("");  
    
    cp5.addButton("PitchEnableButt")                                  // Pitch Enable --> Emulation Tab
       .setPosition(50,100)
       .setValue(0)
       .setSize(100,20)
       .setCaptionLabel("ENABLE Pitch")
       .getCaptionLabel()
       .align(CENTER,CENTER);
    cp5.getController("PitchEnableButt")
       .moveTo("Emulation");
    
    cp5.addButton("RollEnableButt")                                   // Roll Enable --> Emulation Tab
       .setPosition(50,140)
       .setValue(0)
       .setSize(100,20)
       .setCaptionLabel("ENABLE ROLL")
       .getCaptionLabel()
       .align(CENTER,CENTER);
    cp5.getController("RollEnableButt")
       .moveTo("Emulation");
       
    cp5.addButton("FallEnableButt")                                   // Fall Enable --> Emulation Tab
       .setPosition(50,180)
       .setValue(0)
       .setSize(100,20)
       .setCaptionLabel("ENABLE FALL")
       .getCaptionLabel()
       .align(CENTER,CENTER);
    cp5.getController("FallEnableButt")
       .moveTo("Emulation");
    
    PitchRange = cp5.addRange("PitchRange")                           // Pitch Range  --> Emulation Tab
                 .setBroadcast(false) 
                 .setPosition(170,100)
                 .setSize(250,20)
                 .setRange(0,500)
                 .setRangeValues(0,500)               
                 .setHandleSize(10)
                 .setBroadcast(true)
                 .setColorForeground(color(255,40))
                 .setColorBackground(color(255,40))
                 .setCaptionLabel("PITCH")
                 .moveTo("Emulation");    
     
    RollRange = cp5.addRange("RollRange")                             // Roll Range  --> Emulation Tab
                 .setBroadcast(false) 
                 .setPosition(170,140)
                 .setSize(250,20)
                 .setRange(0,500)
                 .setRangeValues(0,500)
                 .setHandleSize(10)
                 .setBroadcast(true)
                 .setColorForeground(color(255,40))
                 .setColorBackground(color(255,40))
                 .setCaptionLabel("ROLL")  
                 .moveTo("Emulation");  
    
    
    FallRange = cp5.addRange("FallRange")                             // Fall Range --> Emulation Tab             
                 .setBroadcast(false) 
                 .setPosition(170,180)
                 .setSize(250,20)
                 .setRange(0,500)
                 .setRangeValues(0,500)
                 .setHandleSize(10)
                 .setBroadcast(true)
                 .setColorForeground(color(255,40))
                 .setColorBackground(color(255,40))
                 .setCaptionLabel("FALL")  
                 .moveTo("Emulation");    
    
    PitchBarChart = cp5.addChart("PitchBChart")                               // Pitch Chart in Chart Tab group
                       .addDataSet("PitchBC");
    PitchLineChart = cp5.addChart("PitchLChart")                              
                        .addDataSet("PitchLC");
    PitchPieChart = cp5.addChart("PitchPChart")                              
                        .addDataSet("PitchPC");
    PitchAreaChart = cp5.addChart("PitchAChart")                              
                        .addDataSet("PitchAC");
                        
    RollBarChart = cp5.addChart("RollBChart")                               // Roll Chart in Chart Tab group
                       .addDataSet("RollBC");
    RollLineChart = cp5.addChart("RollLChart")                              
                        .addDataSet("RollLC");
    RollPieChart = cp5.addChart("RollPChart")                              
                        .addDataSet("RollPC");
    RollAreaChart = cp5.addChart("RollAChart")                              
                        .addDataSet("RollAC");

    FallBarChart = cp5.addChart("FallBChart")                               // Fall Chart in Chart Tab group
                       .addDataSet("FallBC");
    FallLineChart = cp5.addChart("FallLChart")                              
                        .addDataSet("FallLC");
    FallPieChart = cp5.addChart("FallPChart")                              
                        .addDataSet("FalPC");
    FallAreaChart = cp5.addChart("FallAChart")                              
                        .addDataSet("FallAC");                        
  
    cp5.addNumberbox("PitchBNumBox")                                  // Pitch Number box in Bar Chart Tab group 
       .setCaptionLabel("")
       .setPosition(win_w-300,win_h-80)
       .setSize(50,20)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);                 
    cp5.getController("PitchBNumBox").moveTo("Bar Chart");
                                           
    cp5.addNumberbox("RollBNumBox")                                   // Roll Number box in Bar Chart Tab group
       .setCaptionLabel("")
       .setPosition(win_w-200,win_h-80)
       .setSize(50,20)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER); 
    cp5.getController("RollBNumBox").moveTo("Bar Chart");
    
    cp5.addNumberbox("FallBNumBox")                                   // Fall Number box in Bar Chart Tab group
       .setCaptionLabel("")
       .setPosition(win_w-100,win_h-80)
       .setSize(50,20)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("FallBNumBox").moveTo("Bar Chart");      


    cp5.addNumberbox("PitchLNumBox")                                  // Pitch Number box in Line Chart Tab group 
       .setCaptionLabel("")
       .setPosition(win_w-95,win_h-625)
       .setSize(50,20)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("PitchLNumBox")
       .moveTo("Line Chart");
       
    cp5.addNumberbox("RollLNumBox")                                   // Roll Number box in Line Chart Tab group
       .setCaptionLabel("")
       .setPosition(win_w-95,win_h-425)
       .setSize(50,20)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("RollLNumBox")
       .moveTo("Line Chart");
       
    cp5.addNumberbox("FallLNumBox")                                   // Fall Number box in Line Chart Tab group
       .setCaptionLabel("")
       .setPosition(win_w-95,win_h-225)
       .setSize(50,20)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("FallLNumBox")
       .moveTo("Line Chart");
    
    cp5.addSlider("DataPointsSlide", 10 , 1000, win_w/12, win_h/4, 300, 20)  // Data points Slider
       .moveTo("Line Chart");
    cp5.getController("DataPointsSlide")
       .setCaptionLabel("NUMBER OF DATA POINTS");       
       
    cp5.addSlider("LineWidth",1, 3, win_w/12, win_h/3, 300, 20)            // Line Width
       .moveTo("Line Chart")
       .setValue(1);
    cp5.getController("LineWidth")
       .setCaptionLabel("LINE WIDTH");
       

    cp5.addNumberbox("PitchPNumBox")                                  // Pitch Number box in Pie Chart Tab group 
       .setCaptionLabel("Pitch")
       .setPosition(win_w-300,win_h-80)
       .setSize(50,14)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("PitchPNumBox").moveTo("Pie Chart");
       
    cp5.addNumberbox("RollPNumBox")                                   // Roll Number box in Pie Chart Tab group
       .setCaptionLabel("Roll")
       .setPosition(win_w-200,win_h-80)
       .setSize(50,14)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("RollPNumBox")
       .moveTo("Pie Chart");
       
    cp5.addNumberbox("FallPNumBox")                                   // Fall Number box in Pie Chart Tab group
       .setCaptionLabel("Fall")
       .setPosition(win_w-100,win_h-80)
       .setSize(50,14)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("FallPNumBox")
       .moveTo("Pie Chart");

    cp5.addNumberbox("PitchANumBox")                                  // Pitch Number box in Area Chart Tab group 
       .setCaptionLabel("Pitch")
       .setPosition(win_w-300,win_h-80)
       .setSize(50,14)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("PitchANumBox")
       .moveTo("Area Chart");
       
    cp5.addNumberbox("RollANumBox")                                   // Roll Number box in Area Chart Tab group
       .setCaptionLabel("Roll")
       .setPosition(win_w-200,win_h-80)
       .setSize(50,14)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("RollANumBox")
       .moveTo("Area Chart");
       
    cp5.addNumberbox("FallANumBox")                                   // Fall Number box in Area Chart Tab group
       .setCaptionLabel("Fall")
       .setPosition(win_w-100,win_h-80)
       .setSize(50,14)
       .getCaptionLabel()
       .setColorBackground(color(10,20,30,140))
       .align(CENTER,CENTER);
    cp5.getController("FallANumBox")
       .moveTo("Area Chart"); 
 
  cp5.end();       
}


/******************************************************************************************************************************************************************************************
                                                                           UI Aesthetics & Ergonomics Management
******************************************************************************************************************************************************************************************/

void style(String theControllerName) {
  Controller c = cp5.getController(theControllerName);
 
  // adjust the height of the controller
  c.setHeight(15);
 
  // adjust the width of the controller
  c.setWidth(250);
  
  // add some padding to the caption label background
  c.getCaptionLabel().getStyle().setPadding(4,4,3,4);
  
  // shift the caption label up by 4px
  c.getCaptionLabel().getStyle().setMargin(-4,0,0,0); 
  
  // set the background color of the caption label
  c.getCaptionLabel().setColorBackground(color(10,20,30,140));
   
}

/************************************************************************************JUNKS************************************************************************************************/
    //PitchChart.addData("PitchC", pitch);//sin(frameCount*0.1)*10);
    //if(PitchChart.getDataSet("PitchC").size()>10) {
      //PitchChart.removeData("PitchC",0);
    //}
    
