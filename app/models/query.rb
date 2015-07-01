class Query 
	attr_reader :search_string, :groups, :words, :tweets

	# Other models include
	# Group, Tweet, Corpus
	
	# there's a different kind of filtering/options 
	# min/max seed relationship thresholds for viewing
	# doesn't run the search again, but does require processing data
	
	def initialize(search_string, 
				   num_of_tweets = 1000,
		           options = {
						lang: "en",
						count: 100,
						result_type: "recent"
					}
		)

		@groups = Array.new
		@words = Array.new

		#tweets is an array 0f objects returned by Twitter Gem
		@tweets = search(search_string,num_of_tweets,options)

		#corpus is the flattened mass of words that inhabit the tweets
		@words = build_word_corpus(@tweets)


	end

	def search (search_string, num_of_tweets, options)
		api = Twitter::REST::Client.new do |config|
			config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
			config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
			config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
		end
		
		#any search_string formatting happens here
		@query_word = search_string
		@query = @query_word.to_s + " -rt"
		data = []

		api.search((@query), options).take(num_of_tweets).collect do |tweet|
			data.push(tweet)
		end

		#return raw search data
		data
	end

	def sanitize(data)

		@tweets = data.map { |t|

			#remove urls
			tweet = t[:text].gsub(URI.regexp,'')

			#remove symbols, except @ #
			sym = /[^a-zA-Z\d\s@#]/
			tweet = tweet.gsub(sym, '')

			#remove newlines
			tweet = tweet.gsub(/\n/,'')

			#remove single characters
			tweet = tweet.gsub(/\s.\s/,' ')

			#downcase
			tweet = tweet.downcase

		}

		#lets keep it unique, sorry retwitters
		@tweets = @tweets.uniq
	end

	#  sanitize tweets, compile wordlist,
	#  filter stopwords, access min/max
	#  calculate relationships
	def build_word_corpus(tweets)
		straight_hash = Hash.new(0)
		arr = []

		#lets pull out all the tweet texts
		tweets.map! {|tweet|
			tweet.text
		}

		#lets filter out some noise before
		#we build the word corpus
		urls = Array.new
		tweets.map! { |t|

			#store urls
			urls += URI.extract(t,['http','https'])

			#
			#urls.map!{|url|url.join}

			#remove urls
			tweet = t.gsub(URI.regexp,'')

			#remove symbols, except @ #
			sym = /[^a-zA-Z\d\s@#]/
			tweet = tweet.gsub(sym, '')

			#remove newlines
			tweet = tweet.gsub(/\n/,'')

			#remove single characters
			tweet = tweet.gsub(/\s.\s/,' ')

			#downcase
			tweet = tweet.downcase
		}

		#break into words
		words = tweets.join(' ').split(' ')
		words.each { |word| 
			straight_hash[word] += 1
		}


		binding.pry

		#get rid of stopwords before we start heavy processing
		straight_hash = stopwords(straight_hash)

		#filter out relatedness to seed above/below thresholds
		straight_hash = seed_min_max(straight_hash)

		#sort by frequency
		straight_hash = straight_hash.sort_by {|_key, value| value}.reverse.to_h

		#filter min_occur & max_occur
		 # if (occurrences >= min_occur && occurrences <= max_occur )
	  #       swh = {name: word, size: occurrences}
	  #       arr.push swh
	  #       end
   	  #       end


		straight_hash.each {|k,v|
			arr <<	{ name: k, seed_relationship: v }
		}
		@words = arr
	end

	#  tweet viewing methods
	#  raw, sanitized, filtered
	def raw_tweets
	end
	def clean_tweets
	end 





	def break_into_groups
	end

end

#  search
#  save tweets
#  sanitize weird and crazy symbols
#  build word corpus
#    decide on core
#    calculate relationships 


#additional thoughts
# uniq tweets?  If a tweet is just an object, could one tweet have many owners? That we we can still collapse away the repeats.  

# query obj only runs a single search, the api is initialized withn search function