class Query 
	attr_reader :search_string, :groups, :words, :tweets, :log, :core, :d3json

	# Other models include
	# Group, Tweet, Corpus
	
	# Which model sits on top?  Query holds references to everything? 


	# there's a different kind of filtering/options 
	# min/max seed relationship thresholds for viewing
	# doesn't run the search again, but does require processing data

	
	def initialize(search_string, 
				   num_of_tweets = 1000,
		           options = {
						lang: "en",
						count: 100,
						result_type: "recent"
					},
					relate_to_num = 150
		)

		@groups = Array.new
		@words = Array.new
		@core = Array.new
		@seed_min = 4
		@seed_max = 5000

		@log = Logr.new


		#tweets is an array 0f objects returned by Twitter Gem
		@tweets = search(search_string,num_of_tweets,options)
		

		#corpus is the flattened mass of words that inhabit the tweets
		@words = build_word_corpus(@tweets)

		# load @core #
		#a number of words at the 'top', when sorted by relation to seed
		@words[0..20].each do |obj|
			obj.isCore = true
			@core << obj
		end
		@log.point "#{@core.count} words selected for core"

		#calculate relations from all words to top X words?
		@log.start
		@core = @core.sort_by {|v| v.seed_relation}.reverse
		@words.each do |w|
			#how many words down does each word relate to?
			w.relate_to(relate_to_num, self)
		end
		@log.close("calculate relations")

		#break into related groups
		break_words_into_groups

		#format for d3
		@d3json = Group.data_out.to_json

		@log = Logr.output
	end

	def search (search_string, num_of_tweets, options)
		@log.start
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

		#log

		@log.close("query on #{search_string} (#{data.count} tweets)")
		#return raw search data
		data
	end

	#just for a moment
	# def list(core)
	# 	arr = []
	# 	@core.each {|word|
	# 		arr << word.name
	# 	}
	# 	arr
	# end

	def break_words_into_groups
		@log.start
		#core is sorted by top_relation_score (not seed, core is a list of X number of words with the highest seed relationship)

		@core = @core.sort_by! {|c| c.top_relation_score }.reverse
		
		#iterate through core once, break off atomic pairs
		@core.delete_if { |core_word|
			g = nil
			#@log.point(core_word.name)

			#knock out words with no top_relation
			if core_word.top_relation == nil then next true end

			#words are each other's top relations
			if (core_word.top_relation.top_relation == core_word )

				#combines word names for groupname, and adds both words to group
				g = Group.new(core_word.name.to_s + '/' + core_word.top_relation.name.to_s, core_word, core_word.top_relation)

				@log.point("Atom pair #{core_word.name} and #{core_word.top_relation.name} added to #{g.name}")

				@core.delete(core_word.top_relation)
				next true
			end
		}

		# iterate again
		# if single word's top relation is another group, join that group.

		# elseif pointing to another single, start a new group
		@core.delete_if { |core_word|
			if (g = Group.find_by_word(core_word.top_relation))
				
				#core word joins a group if strong enough, or it stays single in core
				if (core_word.top_relation_score >= g.strength.to_int / 5) 
					g.add(core_word)
					@log.point("#{core_word.name} sidles up next to #{g.name}")
					next true
				end

			#its pointing to another single, let them group!
			else
				g = Group.new(core_word.name.to_s + '/' + core_word.top_relation.name.to_s, core_word, core_word.top_relation)

				@log.point("asymmetric pair #{core_word.name} and #{core_word.top_relation.name} => #{g.name}")

				#maybe it's focal isn't core
				if @core.include? core_word.top_relation
					@core.delete(core_word.top_relation)
				end

				#regardless, remove itself from core
				next true
			end
		}

		#add any remaining core's to neutral group, using a special Group method for adding to neutral because we don't necessarily know when it first happens.
		@core.each {|core_word|
			if core_word != nil
				if !Group.find_by_word(core_word.top_relation)
					Group.addNeutral(core_word)
				else
					Group.addNeutral(core_word)
				end
			end
		}

		#might as well find a home for the rest of them
		plebs = @words - @core - Group.all_words
		plebs.each { |pleb|
			if pleb != nil
				#check if it's focal has a group, if yes, join in
				if g = Group.find_by_word(pleb.top_relation) 
					#quick strength check
					if (pleb.top_relation_score >= g.strength.to_int / 5) 
						g.add(pleb) 
					else #wasn't strong enough
						Group.addNeutral(pleb)
					end
				else #wasn't focused on a group
					Group.addNeutral(pleb)
				end
			end
		}

		@groups = Group.list
		@log.close("broke into groups")
	end

	#  sanitize tweets, compile wordlist,
	#  filter stopwords, access min/max
	#  calculate relationships
	def build_word_corpus(data)
		@log.start

		arr = []
		#lets pull out all the tweet texts
		tweets = data.map {|tweet|
			tweet.text
		}

		#lets filter out some noise before
		#we build the word corpus
		urls = Array.new
		tweets.map! { |t|

			#store urls
			urls += URI.extract(t,['http','https'])

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

		# count number of times each word occurs using a hash
		straight_hash = Hash.new(0)
		words = tweets.join(' ').split(' ')
		words.each { |word| 
			straight_hash[word] += 1
		}

		@log << "build_word_corpus found #{straight_hash.count} words"

		# do the same for urls
		url_hash = Hash.new(0)
		urls.each { |url|
			if url != nil
				url_hash[url] += 1
			end
		} 

		# sort url hash by frequency
		url_hash = url_hash.sort_by {|_key, value| value}.reverse.to_h

		# get rid of stopwords before we start heavy processing
		straight_hash = stopwords(straight_hash)

		# filter out relatedness to seed above/below thresholds
		straight_hash = seed_min_max(straight_hash)
		url_hash = seed_min_max(url_hash)

		# put urls back in
		straight_hash.merge!(url_hash)

		# sort by frequency
		straight_hash = straight_hash.sort_by {|_key, value| value}.reverse.to_h

		@log << "#{straight_hash.count} words left after stopwords and thresholds"

		# create word objects from straight_hash
		straight_hash.each {|k,v|
			arr << word = Word.new(k,v)

			#gather tweets for each word
			data.each do |tweet|
				twords = tweet.text.split()
				if twords.include?(k)
					word.tweets << tweet
				end
			end
		}


		#format for d3
		# straight_hash.each {|k,v|
		# 	arr <<	{ name: k, seed_relation: v }
		# }

		@log.close("build_word_corpus finished")

		@words = arr
	end

	def stopwords(data)
		stop = IO.read("lib/stopwords.list").split()
		data.delete_if do |k|
			if stop.include?(k)
				#deletes on true
				true
			elsif k == @query_word
				#if stopword includes query_word lets delete it too
				true
			else
				false
			end
		end
	end

	def seed_min_max(data)
		data.delete_if do |k,v|
			v <= @seed_min || @seed_max < v
		end
		data
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