module TweetsHelper
  def tweet_relative_time(tweet)
    # Change 'about 16 hours' to '16h'
    # TODO: Fix typo in "less than a minute ago"
    nouns = {hour: 'h', minute: 'm', day: 'd', month: 'm', year: 'y'}
    time = time_ago_in_words(tweet.created_at, include_seconds: true).to_s 

    nouns.each do |key, value|
      time.gsub!(Regexp.new("(\\s?)#{key.to_s}(s?)"), value)
    end

    time
  end

  # This set of methods render nttr @user mentions and #hastags into clickable
  # hyerplinks.

  def trim_content_tag(tag)
    # Trim all characters before the @ or # symbols.
    tag.squish.gsub(/\A.*(?=[@#])/, '')
  end

  def content_tag_link(content, tags)
    # Render #hashtag or @mention as link.
    tags.each do |tag|
      href = '/'
      href += '?s=' if tag.include? '#'
      href += tag.gsub(/[@#]/, '')

      anchor = '<a class="tweet-content-link" href="%s">%s</a>' % [href, tag]
      content.gsub!(tag, anchor)
    end
  end

  def link_tweet_content_tags(content)
    # Scan content for hashtags and mentions.
    regex = {
      user: /((\A|[^\w!])@\w+\b)/,
      hash: /((?!\s)#[A-Za-z]\w*\b)/ 
    }

    content_tags = []

    regex.each do |key, exp|
      if content =~ exp then
        content_tags += content.scan(exp).map { |v| trim_content_tag v[0] }.uniq
      end
    end

    if !content_tags.empty? then
      content_tag_link(content, content_tags)
    end

    content
  end
end
