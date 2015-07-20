class Logr < Array
  @@log = []

  def initialize(section_name)
  	@single = {
  		section: section_name,
  	}

  	@timeA = Time.now()
  end

  def close (report)
  	@timeB = Time.now()
  	ms = ((@timeB - @timeA) * 1000).to_int
  	@single[:report] = report
  	@single[:ms] = ms

  	@@log << @single
  	@single
  end
  
  def to_s
     self.join ' | '
  end
end