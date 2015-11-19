module TweetsHelper
  def tweet_relative_time(tweet)
    # Change 'about 16 hours' to '16h'
    # TODO: Fix typo in "less than a minute ago"
    nouns = {hour: 'h', minute: 'm', day: 'd', month: 'm', year: 'y'}
    time = time_ago_in_words(tweet.created_at, include_seconds: true).to_s # .gsub('about ', '')

    nouns.each do |key, value|
      time.gsub!(Regexp.new("(\\s?)#{key.to_s}(s?)"), value)
    end

    time
  end
end
