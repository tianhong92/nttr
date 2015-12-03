module TweetsHelper
  def tweet_relative_time(timestamp)
    # Change 'about 16 hours' to '16h'
    time_regex = /(about|\s|(econd|inute|our)s?)/
    timestamp = time_ago_in_words(timestamp, include_seconds: true).to_s 
    timestamp.gsub!(time_regex, '')
  end

  # This set of methods render nttr @user mentions and #hastags into clickable
  # hyerplinks.

  def content_tag_link(content, tags)
    if tags then
      tags = tags.split(',')

      # Render #hashtag or @mention as link.
      tags.each do |tag|
        if tag.include? '@' and User.where(login: tag[1..-1]).empty? then
          # Twitter will not link to user profiles where the profile does not
          # exist. The mention will be marked up in the editor, but fail when it
          # is passed to the server to validate.
          next
        end

        href = '/'
        href += '?s=' if tag.include? '#'
        href += tag.gsub(/\A[@#]/, '')

        content.gsub!(tag, %Q'<a class="tweet-content-link" href="#{href}">#{tag}</a>')
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
