# Semanaltyics
Semanalytics is a fun way to visualize and analyize what hashtags, words, and phrases (i.e., query)
are trending (or not) in social media. Besides being a lot of fun, Semanaltyics' bubble visualizations helps 
you to understand the context in which your query is being used in social media by counting and drawing a
'Bubble Graph' of the number of times your query appears in a large sample (>= 500) of social media posts.

Our first implementation leverages the Twitterverse, with future versions incorporating other social media sites.
Simply type in a search query, together with the minimum (default: 5) and maximum (default: 100) times the word
should appear in your sample. Then start exploring and refining your searches. Note that you can used advanced
query techniques to narrow down your search. For example, <em>warriors - 'golden state'</em> will search on the
word <em>warriors</em> while excluding <em>golden state</em> from your search.

To save your search queries, <em>create an account and login</em> before searching. You'll find your last
10 searches on your profile page.  You can drill down further on your search by clicking on any node in
the bubble


### How it works
A bubble cloud of individual words/hashtags that are found in a twitter api query. The larger the word, the more often it occurs. The query spans a set of time, and has some basic filtering/processing to remove utility words (e.g., the, and, is) and twitter related noise (e.g., hash tags). We use two models. User, Query. 

### Models - User, Query
---
Relationships look like this.
* A user has many queries, a query belongs to a user

#### User
---
email - String  
password_digest - String

#### Query
---
time - Timestamp  
query - String  
min word count - Integer  
max word count - Integer  
user_id - Integer  

### APIs, Libraries
---
Bubble Cloud Visualization - [d3.js](http://d3js.org)
Twitter Queries - [twitter REST](https://dev.twitter.com/rest/public)

### Deployment
---
[Heroku](https://nameless-plains-8633.herokuapp.com/)