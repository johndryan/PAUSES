#include <LiquidCrystal.h>               // include lcd library code
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);   // initialize the library with the numbers of the interface pins

int  val = 0; 
char code[10]; 
int bytesread = 0;

void setup() { 
  Serial.begin(2400);                    // RFID reader SOUT pin connected to Serial RX pin at 2400bps 
  pinMode(7,OUTPUT);                     // Set digital pin 2 as OUTPUT to connect it to the RFID /ENABLE pin 
  digitalWrite(7, LOW);                  // Activate the RFID reader
  
  lcd.begin(16, 2);                      // set up the LCD's number of columns and rows
  lcd.setCursor(0, 0);
  lcd.print("Waiting for tag.");
}  

void loop() {
  if(Serial.available() > 0) {           // if data available from reader 
    if((val = Serial.read()) == 10) {    // check for header 
      bytesread = 0; 
      while(bytesread<10) {              // read 10 digit code 
        if( Serial.available() > 0) { 
          val = Serial.read(); 
          if((val == 10)||(val == 13)) { // if header or stop bytes before the 10 digit reading 
            break;                       // stop reading 
          } 
          code[bytesread] = val;         // add the digit           
          bytesread++;                   // ready to read next digit  
        } 
      } 
      if(bytesread == 10) {              // if 10 digit read is complete 
        Serial.print("TAG code is: ");   // possibly a good TAG 
        Serial.println(code);            // print the TAG code
        lcd.setCursor(0, 0);
        lcd.print("Tag Found.      ");
        lcd.setCursor(0, 1);
        if(code[8] == 'B') {
          lcd.print("CARD #1         ");
        }
        if(code[8] == '7') {
          lcd.print("CARD #2         ");
        }
        if(code[8] == '9') {
          lcd.print("LARGE CIRCLE TAG");
        }
        if(code[8] == '1') {
          lcd.print("KEYRING TAG     ");
        }
        if(code[8] == '8') {
          lcd.print("SMALL CIRCLE TAG");
        }
      } 
      bytesread = 0; 
      digitalWrite(7, HIGH);             // deactivate the RFID reader for a moment so it will not flood
      delay(1500);                       // wait for a bit
      digitalWrite(7, LOW);              // Activate the RFID reader
      lcd.setCursor(0, 0);
      lcd.print("Waiting for tag.");
      lcd.setCursor(0, 1);
      lcd.print("                ");
    } 
  }
} 

// extra stuff
// digitalWrite(2, HIGH);             // deactivate RFID reader 

