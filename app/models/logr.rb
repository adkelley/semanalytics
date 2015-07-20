class Logr < Array
  @@log = []

  def initialize(section_name = "")
    #start(section_name)
  end

  def start (section_name = "")
    @single = {
      section: section_name,
    }

    @timeA = Time.now()
  end

  def close (report = "")
  	@timeB = Time.now()
  	ms = ((@timeB - @timeA) * 1000).to_int
  	@single[:report] = report
  	@single[:ms] = ms

  	@@log << @single
  	@single
  end

  #call this inside a start and close?
  def point (text)
    a_point = {
      report: text
    }

    @@log << a_point
    a_point
  end
  
  def to_s
     self.join ' | '
  end

  def self.output
    @@log
  end
end