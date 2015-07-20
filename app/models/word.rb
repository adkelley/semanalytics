class Word
	attr_accessor :isCore, :relations
	attr_reader :tweets, :name, :seed_relation

	def initialize(name, seed_relation, tweets = [])
		@name = name
		@seed_relation = seed_relation
		@tweets = tweets
		@isCore = false
		@relations = []

	end

	#TODO#
	# Rewrite using Word model the self being used below was a reference to an instance of 
	# Corpus, which was essentially a word. 
	#
	# Looks like it needs the list of tweets, where does this come from?
	#
	# calculates relations from one word to the whole corpus
	def relate_to(num, query)

		#top x objects except yourself
		query.words[0..num].each do |obj|
			if (obj != self) 
				related = 0

				#for each tweet within the word, count relationship
				self.tweets.each do |tweet|
					if tweet.text.split(" ").include?(obj.name)
						related += 1
					end
				end

				#don't count zeros, and sort the array
				if related > 0 then @relations << {word: obj.name, relationship: related} end

			end

		end
		
		@relations = @relations.sort_by {|v| v[:relationship]}.reverse
	end

end