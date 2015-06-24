# d3t

### Basic MVP Scope
A bubblecloud of individual words/hashtags that are found in a twitter api query. The larger the word, the more often it occurs. The query spans a set of time, and has some basic filtering/processing. We will use three models. User, Query, Tweet. 

### Tuesday Evening Update
It's all coming together. We have a basic MVP.  
What are some possible things we could work on?  
**Rate limiting** - it would be helpful to be able to see remaining API credits.  
**User OAuth** - signing in users to their twitter profile for additional API credits.  
**Save queries in DB** - this deserves some thought, does a query have a certain lifespan more  like a cache? or can users save specific queries in their profile for the longrun?  
**Display Timespan & # of Tweets** - for each query, this would be helpful contextually.  
**Loading animations** - feels really smooth  
**Click to explore** - explore the network by clicking on an existing svg  
**Color by avg followers** - average followers together and color words across a gradient so you can see if some terms are being pushed by extra popular users, or by regular people
**Link to Twitter** - I find myself regularly going to twitter to search word combinations in order to clarify the intent/meaning of patterns I'm seeing. We have the original tweets, is there any way to cleanly display this if desired  


### Models - User, Query, Tweet 
Relationships look like this.
* A user has many queries, a query belongs to a user
* A query has many tweets, and a tweet has many queries

###### User
---
email - String  
password - Password  
OAuth Token - String ?  

###### Query
---
time - Timestamp  
filter_words - Boolean  
threshold - Integer  
query - String  
user_id - Integer  

###### Tweet
---
content - String  
time_tweeted - Timestamp  

### Decisions
* Lets store tweets "in the raw" and rebuild the results arrays as needed. We chose this direction to preserve flexibility if we change what gets used as a 'result' in the future.
* Lets process only a single word/hashtag as the Query. Possibly in the future we could parse multiple words...but we're sticking to one for immediate simplicity.
* Colors, we came up with an exciting idea of using color gradients to measure on average how far apart any particular word is from the query word (in characters). We're pushing this back to the 2nd stage. Also in that idea is that we could correlate multiple query words each along a different axis of color gradient...RGB.  
* OAuth & API access. We decided to go with OAuth access, and store tokens from previous users. In this way, we can still display previous results on the front page when a new user arrives without requiring them to create an account. We will be using the REST API as opposed to the streaming API, because it allows us to pull things back through time.
