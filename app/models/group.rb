class Group
	attr_reader :name, :strength
	@@group_list = Array.new


	def to_s
		Group.plist
	end

	#the strength of a group is the relationship between its founding pair
	def initialize(name, w1, w2)
		@name = name
		@words = Array.new
		@@group_list << self

		#add parents
		add(w1)
		add(w2)

		@strength = w1.top_relation_score
	end

	def add(word)
		@words << word
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

	def self.list
		return @@group_list
	end

	def self.plist
		@@group_list.each {|g|
			puts g.name
		}
		false
	end

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

end