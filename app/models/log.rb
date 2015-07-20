class Log < Array
  def initialize(first)
  	self << first
  end
  def to_s
     self.join ' | '
  end
end