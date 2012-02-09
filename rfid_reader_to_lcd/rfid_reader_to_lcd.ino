#include <LiquidCrystal.h>               // include lcd library code
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);   // initialize the library with the numbers of the interface pins

#include <SoftwareSerial.h>              // include Software serial library
SoftwareSerial rfidPort(8, 9);           // software serial: TX = not needed, set to unused pin, RX = digital pin 3

int  val = 0; 
char code[10];
char message[61];
char lastChar;
int bytesread = 0;
int messageBytesRead = 0;
int speakerPin = 6;
int currentLetter = 0;
//int numSpaces = 0;
boolean messagePresent = false;
boolean scrollLeft = true;
String trimmedMessage = "";

unsigned long lastTime;

void setup() { 
  Serial.begin(9600);                    // RFID reader SOUT pin connected to Serial RX pin at 2400bps
  pinMode(8, INPUT);                     // Set pin 8 as INPUT to accept SOUT from RFID pin
  rfidPort.begin(2400);                  // RFID reader SOUT pin connected to Serial RX pin at 2400bps 
  pinMode(9,OUTPUT);                     // Set digital pin 2 as OUTPUT to connect it to the RFID/ENABLE pin
  digitalWrite(9, LOW);                  // Activate the RFID reader
  pinMode(speakerPin, OUTPUT);           // Set pin for speaker output

  lcd.begin(16, 2);                      // set up the LCD's number of columns and rows
  lcd.setCursor(0, 0);
  lcd.print("->P.A.U.S.E.S.<-");
  lcd.setCursor(0, 1);
  lcd.print("     ready!     ");

  Serial.println("Hello World!");
  lastTime = millis();
}  

void loop() {
  //Check Hardware Serial for comms with Processing 
  if(Serial.available() > 0) {
    messageBytesRead = 0;
    val = 0; 
    char tempMessage[61];
    while(val != 10) {              // read 140 digit code 
      if( Serial.available() > 0) { 
        val = Serial.read(); 
        if((val == 10)||(val == 13)) { // if header or stop bytes before the 10 digit reading 
          break;                       // stop reading 
        } 
        message[messageBytesRead] = val;         // add the digit           
        messageBytesRead++;                   // ready to read next digit  
      } 
    }
    if(messageBytesRead > 1) {              // if 10 digit read is complete
      trimmedMessage = "";
      for (int thisChar = 0; thisChar < messageBytesRead; thisChar++) {
        trimmedMessage = trimmedMessage + message[thisChar];
      }
      lcd.clear();
      currentLetter = 0;
      lcd.setCursor(1, 0);
      lcd.print(trimmedMessage);
      messagePresent = true;
    }
  }

  //Scroll message if present
  if(messagePresent) {
    lcd.scrollDisplayLeft();
    delay(400);
  }

  //Check Software Serial for RFID readings
  if(rfidPort.available() > 0) {           // if data available from reader 
    if((val = rfidPort.read()) == 10) {    // check for header
      bytesread = 0; 
      while(bytesread<10) {              // read 10 digit code 
        if( rfidPort.available() > 0) { 
          val = rfidPort.read(); 
          if((val == 10)||(val == 13)) { // if header or stop bytes before the 10 digit reading 
            break;                       // stop reading 
          } 
          code[bytesread] = val;         // add the digit           
          bytesread++;                   // ready to read next digit  
        } 
      }
      unsigned long now = millis();
      if((now - lastTime) > 3000) {
        lastTime = now;
        digitalWrite(9, HIGH);             // deactivate the RFID reader for a moment so it will not flood
        if(bytesread == 10) {              // if 10 digit read is complete 
          Serial.print("RFID="); // possibly a good TAG 
          Serial.println(code);            // print the TAG code
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.noAutoscroll();
          lcd.print("  INTERPRETING");
          lcd.setCursor(0, 1);
          lcd.print("      DATA");
          analogWrite(speakerPin, 128);      // Send pwm wave to speaker
          delay(250);                        // wait for half a second
          digitalWrite(speakerPin, LOW);     // turn the speaker off
        }
        delay(1500);                       // wait for a bit
        digitalWrite(9, LOW);              // Activate the RFID reader
      }
      bytesread = 0;
    }
  }
} 

// extra stuff
// digitalWrite(2, HIGH);             // deactivate RFID reader 




