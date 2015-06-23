require 'ffaker'

(1..5).each do
  user_params = {}
  user_params[:email] = FFaker::Internet.email
  user_params[:password] = "fakedata"
  user_params[:password_confirmation] = user_params[:password]
  new_user = User.create(user_params)

  (1..5).each do
    new_query = Query.new
    new_query.query_string = FFaker::HipsterIpsum.word
    new_query.word_count_min = 5
    new_query.utility_words = false
    new_query.save
    new_user.queries << new_query
    
    (1..5).each do
      new_tweet = Tweet.new
      new_tweet.tweet_string = FFaker::HipsterIpsum.sentence
      new_tweet.save
      new_query.tweets << new_tweet
    end
  end
end
