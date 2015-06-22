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

	def search(string,num)
		options = {
			lang: "en",
			result_type: "recent"
		}
		@data = []
		@client.search(string, options).take(num).collect do |tweet|
			@data.push({text: tweet.text, time: tweet.created_at})
		end
		return @data
	end

	private
	def buildWords

	end

	def cleanseSymbols
		symbols = [':', '.','"', '?','!',';','/','\\']
	end

	def cleanseUrls

	end

end