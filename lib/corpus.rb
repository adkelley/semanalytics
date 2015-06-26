#Corpus is a mixed purpose class. The individual instances would be more aptly described as Words. The class as a whole represents the entirely of a single 'pull' of twitter data.

class Corpus
	include Enumerable

	attr_reader :name, :tweets, :seed_relationship
	attr_accessor :isCore, :relations
	@@list = Array.new
	@@core = Array.new
	#has_many :tweets

	def to_s
		@name.to_s
	end

	def initialize(word, seed_relationship)
		@name = word
		@seed_relationship = seed_relationship
		@isCore = false
		@tweets = [] 
		@relations = []
		@@list << self
	end

	def top_relation 
		if self.relations.count > 0
			find (self.relations[0][:word])
		else
			nil
		end
	end		

	def top_relation_score
		if self.relations.count > 0
			self.relations[0][:relationship]
		else
			0
		end
	end

	def find(word)
		@@list.each do |obj|
			if (obj.name == word) 
				return obj
			end
		end
	end

	def self.break_into_groups

		#core is sorted by top_relation_score
		core = self.core.sort_by! {|c| c.top_relation_score }.reverse
		
		#iterate through core once, break off atomic pairs
		core.delete_if { |core_word|
			g = nil

			if (core_word.top_relation.top_relation == core_word )

				#combines word names for groupname, and adds both words to group
				g = Group.new(core_word.name.to_s + '/' + core_word.top_relation.name.to_s, core_word, core_word.top_relation)
				core.delete(core_word.top_relation)
				next true
			end
		}

		#iterate again, clean up the singles
		core.delete_if { |core_word|
			if (g = Group.find(core_word.top_relation))
				
				#core word joins a group if strong enough, or it stays single in core
				if (core_word.top_relation_score >= g.strength.to_int / 5) 
					g.add(core_word)
					next true
				end

			#its pointing to another single, let them group!
			else
				g = Group.new(core_word.name.to_s + '/' + core_word.top_relation.name.to_s, core_word, core_word.top_relation)

				#maybe it's focal isn't core
				if core.include? core_word.top_relation
					core.delete(core_word.top_relation)
				end

				#regardless, remove itself from core
				next true
			end
		}

		#add any remaining core's to neutral group, using a special Group method for adding to neutral because we don't necessarily know when it first happens.
		core.each {|core_word|
			if core_word != nil
				if !Group.find(core_word.top_relation)
					Group.addNeutral(core_word)
				else
					Group.addNeutral(core_word)
				end
			end
		}

		#might as well find a home for the rest of them
		plebs = Corpus.all - Corpus.core
		plebs.each { |pleb|
			if pleb != nil
				#check if it's focal has a group, if yes, join in
				if g = Group.find(pleb.top_relation) 
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



			#check each core both directions
				#if same, break into group
				#if not same, add to group of top_relation
			#binding.pry



			# if (core_word.top_relation.top_relation == core_word )
			# 	g = Group.new(core_word.name.to_s + '/' + core_word.top_relation.name.to_s)
			# 	g.add(core_word)
			# 	g.add(core_word.top_relation)
			# 	core.delete(core_word.top_relation)
			# 	true
			# else
			# 	g = Group.find(core_word.top_relation.name)
			# 	binding.pry
			# 	g.add(core_word)
			# 	true
			# end

			#puts coreWord.name.to_s + ">"+coreWord.top_relation_score.to_s+">" + coreWord.top_relation.name.to_s

	end

	def self.find(word)
		@@list.each do |obj|
			if (obj.name == word) 
				return obj
			end
		end
	end

	def self.load(words,tweets)
		words.each do |w|
			word = Corpus.new(w[:name], w[:seed_relationship])
			tweets.each do |tweet|
				twords = tweet.split()
				if twords.include?(word.name)
					word.tweets << tweet
				end
			end
		end

		Corpus.build_relations
		Corpus.break_into_groups
		return "Corpus loaded successfully"
	end

	def self.all
		return @@list
	end

	def self.core
		return @@core
	end

	#defines core, and builds relations
	def self.build_relations
		a = Time.now()
		@@list[0..20].each do |obj|
			obj.isCore = true
			@@core << obj
		end

		#lets straight up @@core
		@@core = @@core.sort_by {|v| v.seed_relationship}.reverse

		
		@@list.each do |w|
			w.relate_to
		end
		b = Time.now()


		return "Corpus.group completed in "+((b-a) * 1000).to_s + " ms"
	end

	#calculates relations from one word to the whole corpus
	def relate_to

		#each object of the core except yourself
		@@list[0..150].each do |obj|
			if (obj != self) 
				related = 0

				#for each tweet within the word, count relationship
				self.tweets.each do |tweet|
					if tweet.split(" ").include?(obj.name)
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