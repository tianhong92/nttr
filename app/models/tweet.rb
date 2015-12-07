class Tweet < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  belongs_to :user
  validates_associated :user
  validate :unique_content, on: :create

  # Sanitize tweet content and extract mentions, hashtags and hyperlinks.
  before_save :strip_html, :find_hashtags, :find_mentions, :find_links

  validates :content,
    presence: {
      message: 'Nttrs cannot be empty!'
    },
    length: { 
      maximum: 140,
      message: 'Nttrs may be only 140 characters long!'
    }

  private
    def unique_content
      # Twitter applies an interval before you are allowed to tweer the same
      # thing twice. 10 minutes is fine.
      recent_tweets = Tweet.where(user_id: self.user_id)
        .where('created_at > ?', Time.now - 10.minutes)
        .order('created_at desc')
        .limit(10)

      if recent_tweets.where(content: self.content).count > 0
        errors.add(:content, 'You have already nttrd that!') 
      end
    end

    def strip_html
      self.content = strip_tags self.content
    end

    def clean_tag(tag)
      tag.squish.gsub(/\A.*(?=[@#])/, '')
    end

    def content_scan(regex)
      if self.content =~ regex then 
        self.content.scan(regex).map{ |tag| clean_tag tag[0] }.uniq.join(',')
      end
    end

    def find_hashtags
      # Regex example:
      # See: http://rubular.com/r/8xLZneArNp
      self.hashtags = content_scan /((?!\s)#[A-Za-z]\w*\b)/
    end

    def find_mentions
      # See: http://rubular.com/r/SKQRb5lzHk
      self.mentions = content_scan /(((?=[^\w!])@\w+\b))/
    end

    def find_links
      # This regex is tentative and by no means complete. It currently only
      # matches the .com, .org, .net, .int, .edu, .gov, and .mil TLDs.
      # See: https://regex101.com/r/hA3sD8/5
      # See: http://rubular.com/r/4wf5qeSOJG
      self.links = content_scan /((?!\W)(http(s?):\/\/)?(www\.)?[a-z0-9.-]+?\.[cnoiegm][a-z]{1,2}(\/[^\s]*|(?=\W))?)/
    end
end
