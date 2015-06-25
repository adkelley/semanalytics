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

  def search(string,num,min_occur = 5, max_occur = 100)
    options = {
      lang: "en",
      count: 100,
      result_type: "recent"
    }
    
    @query = string
    @data = []
    @client.search(string, options).take(num).collect do |tweet|
      @data.push({text: tweet.text})
    end
    sanitize
    build
    stopwords
    json(min_occur, max_occur)
  end

  def stopwords
    stop = IO.read("lib/stopwords.list").split()
    @data.delete_if do |k|
      if stop.include?(k)
        puts "removing #{k}"
        true
        else
          k == @query
          end
      end
    end

  def json(min_occur, max_occur)
    arr =[]
    @data.each do |word,occurrences|
      if (occurrences >= min_occur && occurrences <= max_occur )
        swh = {name: word, size: occurrences}
        arr.push swh
        end
      end
    @data = {name: @query, children: arr }.to_json
    end

  def build
    freq = Hash.new(0)
    words = @data.join(' ').split(' ')
    words.each { |word| 
      freq[word] += 1 
      }

    #sort by frequency
    @data = freq.sort_by {|_key, value| value}.reverse.to_h

    #lets remove the first element which *should* be the query
    #not always reliable if there's another word that ends up first
    #@data.shift
    end

  def sanitize
    sym = /[^a-zA-Z\d\s@#]/
    # &amp; can also be a thing
    @newdata = @data.map { |t|

      #remove urls
      tweet = t[:text].gsub(URI.regexp,'')

      #remove symbols, except @ #
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
