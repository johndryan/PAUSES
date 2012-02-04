/*--------------

Based on: http://github.com/RobotGrrl/Simple-Processing-Twitter

--------------*/

// Oauth
static String OAuthConsumerKey = "INSERT_HERE";
static String OAuthConsumerSecret = "INSERT_HERE";

// Access Token
static String AccessToken = "INSERT_HERE";
static String AccessTokenSecret = "INSERT_HERE";

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
