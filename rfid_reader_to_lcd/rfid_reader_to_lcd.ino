#include <LiquidCrystal.h>               // include lcd library code
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);   // initialize the library with the numbers of the interface pins

int  val = 0; 
char code[10]; 
int bytesread = 0;
int speakerPin = 6;

void setup() { 
  Serial.begin(2400);                    // RFID reader SOUT pin connected to Serial RX pin at 2400bps 
  pinMode(7,OUTPUT);                     // Set digital pin 2 as OUTPUT to connect it to the RFID /ENABLE pin
  digitalWrite(7, LOW);                  // Activate the RFID reader
  pinMode(speakerPin, OUTPUT);           // Set pin for speaker output
  
  lcd.begin(16, 2);                      // set up the LCD's number of columns and rows
  lcd.setCursor(0, 0);
  lcd.print("->P.A.U.S.E.S.<-");
  lcd.setCursor(0, 1);
  lcd.print("Initializing...");
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
        Serial.print("RFID="); // possibly a good TAG 
        Serial.println(code);            // print the TAG code
      } 
      bytesread = 0; 
      digitalWrite(7, HIGH);             // deactivate the RFID reader for a moment so it will not flood
      analogWrite(speakerPin, 128);      // Send pwm wave to speaker
      delay(250);                        // wait for half a second
      digitalWrite(speakerPin, LOW);     // turn the speaker off
      delay(1000);                       // wait for a bit
      digitalWrite(7, LOW);              // Activate the RFID reader
    } 
  }
} 

// extra stuff
// digitalWrite(2, HIGH);             // deactivate RFID reader 

