/*--------------
Built with code from:
http://github.com/RobotGrrl/Simple-Processing-Twitter
http://arduino.cc/en/Tutorial/SerialCallResponseASCII
--------------*/

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
  size(100, 100);
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

  //Now, do the Twitter stuff
  connectTwitter();
  sendTweet("I am exploring and testing my new P.A.U.S.E.S. device.");
  //getTimeline();
  //getSearchTweets();
}

void draw() {
  background(0);
}

