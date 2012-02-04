/*--------------

Based on: http://github.com/RobotGrrl/Simple-Processing-Twitter

--------------*/

// Oauth
static String OAuthConsumerKey;
static String OAuthConsumerSecret;

// Access Token
static String AccessToken;
static String AccessTokenSecret;

// Variables
String myTimeline;
java.util.List statuses = null;
User[] friends;
Twitter twitter = new TwitterFactory().getInstance();
RequestToken requestToken;
String[] theSearchTweets = new String[11];

void setup() {
  size(100, 100);
  background(0);

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

// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Sending a tweet
void sendTweet(String t) {
  try {
    Status status = twitter.updateStatus(t);
    println("Successfully updated the status to [" + status.getText() + "].");
  } 
  catch(TwitterException e) { 
    println("Send tweet: " + e + " Status code: " + e.getStatusCode());
  }
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// Get your tweets
void getTimeline() {
  try {
    statuses = twitter.getUserTimeline();
  } 
  catch(TwitterException e) { 
    println("Get timeline: " + e + " Status code: " + e.getStatusCode());
  }
  for (int i=0; i<statuses.size(); i++) {
    Status status = (Status)statuses.get(i);
    println(status.getUser().getName() + ": " + status.getText());
  }
}

// Search for tweets
void getSearchTweets() {
  String queryStr = "@_johndryan";
  try {
    Query query = new Query(queryStr);    
    query.setRpp(10); // Get 10 of the 100 search results  
    QueryResult result = twitter.search(query);    
    ArrayList tweets = (ArrayList) result.getTweets();    
    for (int i=0; i<tweets.size(); i++) {	
      Tweet t = (Tweet)tweets.get(i);	
      String user = t.getFromUser();
      String msg = t.getText();
      Date d = t.getCreatedAt();	
      theSearchTweets[i] = msg.substring(queryStr.length()+1);
      println(theSearchTweets[i]);
    }
  } 
  catch (TwitterException e) {    
    println("Search tweets: " + e);
  }
}
