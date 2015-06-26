class Group
	attr_reader :name, :strength
	@@group_list = Array.new


	def to_s
		self.name.to_s
	end

	#the strength of a group is the relationship between its founding pair
	def initialize(name, w1 = nil, w2 = nil)
		@name = name
		@words = Array.new
		@@group_list << self

		#add parents if they're provided
		if w1 != nil 
			add(w1) 
			@strength = w1.top_relation_score
		end
		if w1 != nil then add(w2) end

		
	end

	#nil, or duplicates, just forget
	def add(word)
		if (word != nil)
			if !Group.find(word)
				@words << word
			end
		end
	end

	def words
		@words
	end

	def pwords
		@words.each {|w|
			puts w.name
		}
		false
	end

	def out
		arr = []
		@words.each {|word|
			arr << {name: word.name, size: word.seed_relationship}
		}

		{name: self.name, children: arr}
	end

	def self.reset
		Group.list.each {|g|
			g = nil
		}

		@@group_list = Array.new
	end

	def self.data_out
		arr = []
		Group.list.each {|g|
			arr << g.out 
		}

		{name: Tapi.query_word?, children: arr}
	end

	def self.list
		return @@group_list
	end

	def self.plist
		@@group_list.each {|g|
			puts g.name
		}
		false
	end

	def self.addNeutral(obj)
		if (g = self.get?("neutral"))
			g.add(obj)
		else
			Group.new("neutral",obj)
		end
	end

	#for finding the group of a word
	def self.find(word)
		@@group_list.each { |g| 
			g.words.each {|w|
				if w == word
					return g
				end
			}
		}
		return nil
	end

	#for finding a group by its name
	def self.get? (name)
		Group.list.each{|g|
			if g.name == name 
				
				return g 
			end
		}
		return false
	end

end