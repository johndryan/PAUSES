/*--------------
Built with code from:
http://github.com/RobotGrrl/Simple-Processing-Twitter
http://arduino.cc/en/Tutorial/SerialCallResponseASCII
--------------*/

//Setup serial port
import processing.serial.*;
Serial myPort;
int lf = 10;
int numMessages = 0;

// Variables for Tweeting
static String OAuthConsumerKey;
static String OAuthConsumerSecret;
static String AccessToken;
static String AccessTokenSecret;
String myTimeline;
java.util.List statuses = null;
User[] friends;
Twitter twitter = new TwitterFactory().getInstance();
RequestToken requestToken;
String[] theSearchTweets = new String[11];

void setup() {
  size(300, 300);
  background(0);
  
  //SETUP TWITTER API STUFF
  //Get the API keys/tokens from the config txt file - in the data folder
  String[] config_txt = loadStrings("twitter_api_keys_tokens.txt");
  String[] twitter_api_config = new String[4];
  int key_counter = 0;
  for (int i=0; i<config_txt.length; i++) {
    String[] splitline = splitTokens(config_txt[i],"= ");
    twitter_api_config[key_counter++] = splitline[1];
  }
  OAuthConsumerKey = twitter_api_config[0];
  OAuthConsumerSecret = twitter_api_config[1];
  AccessToken = twitter_api_config[2];
  AccessTokenSecret = twitter_api_config[3];

  //Start listening to serial port
  //println(Serial.list()); // Print serial port list for debugging
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');

  //Connect to Twitter
  connectTwitter();
}

void draw() {
  background(0);
}

void serialEvent(Serial myPort) { 
  // When complete new line is read from Serial this function is triggered
  String incomingMessage = myPort.readStringUntil('\n');
  incomingMessage = trim(incomingMessage);
  println("SERIAL:" + incomingMessage);
  if( incomingMessage.indexOf("RFID") != -1 ) {
    String[] messageElements = split(incomingMessage, '=');
    //sendTweet("I am currently interacting with object num " + messageElements[1]);
    println("I am currently interacting with object num " + messageElements[1]);
    updateLCD(messageElements[1]);
  }
}

void updateLCD(String message) {
  myPort.write("MESSAGE " + numMessages++);
  myPort.write(lf);
}
