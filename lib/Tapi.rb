class Tapi
	attr_reader :data_sanitize, :data_stopwords, :data_build, :data_json, :data_corpus, :data
	def initialize
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
			config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
			config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
		end
	end

	#to access, create a new Tapi
	#  t = Tapi.new
	# 
	#run a search
	#  t.search("keyword",numLimit) 
	#
	#then access with 
	#  t.data

	def search(string,num,threshold = 5)
		options = {
			lang: "en",
			count: 100,
			result_type: "recent"
		}
		
		@query = string
		data = []

		@client.search(string, options).take(num).collect do |tweet|
			data.push({text: tweet.text})
		end

		json(
			stopwords(
				build(
					sane_data = sanitize(data)
					)
				)
			)

		corpus (
			sane_data
			)

	end

	def corpus(data)
		@data_corpus = []
		data.each do |d|
			@data_corpus.push( TfIdfSimilarity::Document.new(d) )
		end

		@data_corpus
	end

	def json(data, min_word_count = 5)
		arr =[]
		data.each do |word,occurences|
			if (occurences > min_word_count)
				swh = {name: word, size: occurences}
				arr.push swh
			end
		end
		@data_json = {name: @query, children: arr }.to_json
	end

	def stopwords(data)
		stop = IO.read("lib/stopwords.list").split()
		data.delete_if do |k|
			if stop.include?(k)
				puts "removing #{k}"
				true
			else
				k == @query
			end
		end
		@data_stopwords = data
	end

	def build(data)
		freq = Hash.new(0)
		words = data.join(' ').split(' ')
		words.each { |word| 
			freq[word] += 1 
		}

		#sort by frequency
		@data_build = freq.sort_by {|_key, value| value}.reverse.to_h

	end

	def sanitize(data)
		sym = /[^a-zA-Z\d\s@#]/
		# &amp; can also be a thing
		@data_sanitize = data.map { |t|

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
		@data_sanitize
	end


end