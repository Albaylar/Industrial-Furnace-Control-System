#include<LiquidCrystal.h>
// defining pin numbers
#define temp_sens A1
#define heat 7
#define fan 6
float temp_check = 0;
//assume set poin is 25
float set_point = 25;
//setting LCD pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
void setup()
{

// configure the pins as per requirement
 lcd.begin(16, 2);
  pinMode(temp_sens,INPUT);
  pinMode(heat,OUTPUT);
  pinMode(fan,OUTPUT);
}

void loop()
{
//checking temperature from analog pin A0
   temp_check = analogRead(temp_sens);
   // read analog volt from sensor and save to variable temp
   temp_check = temp_check * 0.48828125;
   // convert the analog volt to its temperature equivalent
  
  //if below the set point
  if(temp_check <set_point){
    // on the heter
    digitalWrite(heat,HIGH);
    lcd.print("   Heating...");
    //off the fan
    digitalWrite(fan,LOW);
  }
  //if above the set point
  if(temp_check > set_point){
    // off the heter and on the fan
    digitalWrite(fan,HIGH);
    lcd.print("  Cooling...");
    digitalWrite(heat,LOW);
  }
//setting lcd to print the setting temperature 
  lcd.setCursor(0,0);          
  lcd.print("set : ");
  lcd.setCursor(6,0);
  lcd.print(set_point);
// setting lcd to print the temperature sensed
  lcd.setCursor(0,1);          
  lcd.print("current : ");
  lcd.setCursor(10,1);           
  lcd.print(temp_check);    
  }
