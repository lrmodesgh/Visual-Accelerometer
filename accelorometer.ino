int x_ch = 0 ;
int y_ch = 0 ;
int z_ch = 0 ;

int x = 0 ;
int y = 0 ;
int z = 0 ; 

int lv = 0 ;
int avg = 0 ;

double v_x = 0.0 ;
double v_y = 0.0 ;
double v_z = 0.0 ;


double scale(double value, double i_min, double i_max, double o_min, double o_max ) ;
double m_min = 0.0 ;
double m_max = 0.0 ;


void setup() {
  // put your setup code here, to run once:
  analogReference(DEFAULT);
  
  x_ch = A0 ;
  y_ch = A1 ;
  z_ch = A2 ;
  
  pinMode(x_ch, INPUT);
  pinMode(y_ch, INPUT);
  pinMode(z_ch, INPUT);  
  
  Serial.begin(9600);
 
  avg = 100 ; 
  m_min = -1.0 ;
  m_max = 1.0 ; 
  
}

void loop() {
  // put your main code here, to run repeatedly: 
 
 for ( lv = 0 ; lv < avg ; lv++)
 {
   x = analogRead(x_ch); 
   v_x = v_x + float(x) ;
   y = analogRead(y_ch); 
   v_y = v_y + float(y) ;  
   z = analogRead(z_ch); 
   v_z = v_z + float(z) ;  
 }
 
 v_x = v_x / avg ;
 v_y = v_y / avg ;
 v_z = v_z / avg ;
 
 
 v_x = float (constrain ( int(v_x), 0 , 675 ) ) ;
 
 v_y = float (constrain ( int(v_y), 0 , 675 ) ) ;
 
 v_z = float (constrain ( int(v_z), 0 , 675 ) ); 
 
 Serial.print('A');
 Serial.print(int(v_x));
 Serial.print('B');
 Serial.print(int(v_y));
 Serial.print('C');
 Serial.print(int(v_z));
 Serial.print('\n');
 
 delay (100);
 
}


double scale(double value, double i_min, double i_max, double o_min, double o_max )
{
 double slope = 0.0, val = 0.0 , c = 0.0;
  
  slope = (o_max - o_min)/(i_max - i_min) ;
  c = -1 + (-i_min*slope) ;
  
  if (slope < 0){ slope = -1 ; val = -1 ;  return val; }
  else { val = (value * slope) + c ;   return val; }
}

