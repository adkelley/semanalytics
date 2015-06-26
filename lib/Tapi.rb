class Tapi
	attr_reader :tweets, :data_stopwords, :words, :data_json, :data_corpus, :build, :data

	def initialize(string,num,seed_min = 4,seed_max=5000)
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
			config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
			config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
			
		end
		search(string,num,seed_min)
	end

  #to access, create a new Tapi
  #  t = Tapi.new
  # 
  #run a search
  #  t.search("keyword",numLimit) 
  #
  #then access with 
  #  t.data

	def self.query_word?
		@@query_word
	end

	def search(string, num, seed_min = 4, seed_max = 5000)
		@seed_min = seed_min
		@seed_max = seed_max
		options = {
			lang: "en",
			count: 100,
			result_type: "recent"
		}
		
		@@query_word = string
		@query = @@query_word.to_s + " -rt"
		data = []

		@client.search((@query), options).take(num).collect do |tweet|
			data.push({text: tweet.text})
		end

		build(
			sanitize(data)
		)

		Corpus.reset 
		Group.reset

		#loads data associations
		Corpus.load(@words,@tweets)

		#formats and outputs data
		@data = Group.data_out.to_json
	end

	# def corpus(data)
	# 	@data_corpus = []
	# 	data.each do |d|
	# 		@data_corpus.push( TfIdfSimilarity::Document.new(d) )
	# 	end

	# 	@data_corpus
	# end

	# def json(data, min_word_count = 5)
	# 	arr =[]
	# 	data.each do |word,occurences|
	# 		if (occurences > min_word_count)
	# 			swh = {name: word, size: occurences}
	# 			arr.push swh
	# 		end
	# 	end
	# 	@data_json = {name: @query, children: arr }.to_json
	# end

	def stopwords(data)
		stop = IO.read("lib/stopwords.list").split()
		data.delete_if do |k|
			if stop.include?(k)
				#deletes on true
				true
			else
				#returns false if it equals query
				k == @@query_word
			end
		end
	end

	def seed_min_max(data)
		puts data.length
		data.delete_if do |k,v|
			v <= @seed_min || @seed_max < v
		end
		puts data.length
		data
	end

	def stopwords(data)
	stop = IO.read("lib/stopwords.list").split()
		data.delete_if do |k|
			if stop.include?(k)
				#deletes on true
				true
			else
				#returns false if it equals query
				k == @@query_word
			end
		end
	end

	def build(data)
		arr = []
		straight_hash = Hash.new(0)
		words = data.join(' ').split(' ')
		words.each { |word| 
			straight_hash[word] += 1
		}

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

  def sanitize(data)
      sym = /[^a-zA-Z\d\s@#]/
    
     @tweets = data.map { |t|

      #remove urls
      tweet = t[:text].gsub(URI.regexp,'')

      #remove symbols, except @ #
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
end