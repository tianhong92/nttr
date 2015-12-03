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

  def content_tag_link(content, tags)
    if tags then
      tags = tags.split(',')

      # Render #hashtag or @mention as link.
      tags.each do |tag|
        if tag.include? '@' and User.where(login: tag[1..-1]).empty? then
          # Twitter will no link to user profiles where the profile does not
          # exist. The mention will be marked up in the editor, but fail when it
          # is passed to the server to validate.
          next
        end

        href = '/'
        href += '?s=' if tag.include? '#'
        href += tag.gsub(/\A[@#]/, '')

        anchor = '<a class="tweet-content-link" href="%s">%s</a>' % [href, tag]
        content.gsub!(tag, anchor)
      end
    end

    content
  end

  def link_tweet_content_tags(tweet)
    content = content_tag_link tweet.content, tweet.mentions
    content = content_tag_link tweet.content, tweet.hashtags
    content = content_tag_link tweet.content, tweet.links
  end
end
