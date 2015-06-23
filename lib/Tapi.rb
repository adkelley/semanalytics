class Tapi
	attr_reader :data
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


	# {
 #     "name": "events",
 #     "children": [
 #      {"name": "DataEvent", "size": 2313},
 #      {"name": "SelectionEvent", "size": 1880},
 #      {"name": "TooltipEvent", "size": 1701},
 #      {"name": "VisualizationEvent", "size": 1117}
 #     ]
 #    }

	def search(string,num)
		options = {
			lang: "en",
			result_type: "recent"
		}
		@data = []
		@client.search(string, options).take(num).collect do |tweet|
			@data.push({text: tweet.text})
		end
		return @data
	end

	def build
		freq = Hash.new(0)
		words = @data.join(' ').split(' ')
		words.each { |word| 
			freq[word] += 1 
		}

		@data = freq.sort_by {|_key, value| value}.reverse.to_h
	end

	def sanitize
		sym = /[^a-zA-Z\d\s@#]/
		# &amp; can also be a thing
		@newdata = @data.map { |t|

			#remove urls
			tweet = t[:text].gsub(URI.regexp,'')

			#remove symbols, except @
			tweet = tweet.gsub(sym, '')

			#remove newlines
			tweet = tweet.gsub(/\n/,'')

			#remove single characters
			tweet = tweet.gsub(/\s.\s/,' ')

			#downcase
			tweet = tweet.downcase
		}
		@data = @newdata
	end


end