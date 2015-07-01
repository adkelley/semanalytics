class Log < Array
  def to_s
     self.join ' | '
  end
end