/*--------------
Built with code from:
http://github.com/RobotGrrl/Simple-Processing-Twitter
http://arduino.cc/en/Tutorial/SerialCallResponseASCII
--------------*/
PImage bg;

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

//RFID Hashmap
HashMap rfids;

void setup() {
  size(256, 256);
  bg = loadImage("logo.png");
  background(bg);
    
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

  //Load RFID tag info
  rfids = new HashMap();
  String[] rfidTags = loadStrings("tag_list.csv");
  int counter = 0;
  for (int i=0; i<rfidTags.length; i++) {
    String[] splitline = splitTokens(rfidTags[i],",");
    RfidTag r = new RfidTag(splitline[0],splitline[1],boolean(splitline[2]),splitline[3]);
    rfids.put(splitline[1], r);
  }

  //Start listening to serial port
  //println(Serial.list()); // Print serial port list for debugging
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');

  //Connect to Twitter
  connectTwitter();
}

void draw() {
  
}

void serialEvent(Serial myPort) { 
  // When complete new line is read from Serial this function is triggered
  String incomingMessage = myPort.readStringUntil('\n');
  incomingMessage = trim(incomingMessage);
  
  println("SERIAL:" + incomingMessage);
  if( incomingMessage.indexOf("RFID") != -1 ) {
    String[] messageElements = split(incomingMessage, '=');
    String rfid = messageElements[1].substring(0, 10);
    RfidTag r = (RfidTag) rfids.get(rfid);
    say("John is currently holding " + r.name, "Alex", 200);
    //sendTweet("I am currently holding " + r.name + ".");
    println("John is currently holding " + r.name + ".");
    updateLCD("I am currently holding " + r.name + ".");
  }
}

void tellTheWorld(String message) {
  println(message);
  say(message, "Alex", 200);
  //sendTweet("I am currently holding " + r.name + ".");
  updateLCD(message);
}

void updateLCD(String message) {
  myPort.write(message);
  myPort.write(lf);
}

void say(String script, String voice, int speed) {
  try {
    Runtime.getRuntime().exec(new String[] {"say", "-v", voice, "[[rate " + speed + "]]" + script});
  }
  catch (IOException e) {
    System.err.println("IOException");
  }
}
