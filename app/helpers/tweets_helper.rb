module TweetsHelper
  def tweet_relative_time(tweet)
    nouns = {hour: 'h', minute: 'm', day: 'd', month: 'm', year: 'y'}
    time = time_ago_in_words(tweet.created_at).gsub('about ', '')

    nouns.each do |key, value|
      time.gsub!(Regexp.new("(\\s?)#{key.to_s}(s?)"), value)
    end

    time
  end
end
