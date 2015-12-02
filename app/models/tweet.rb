class Tweet < ActiveRecord::Base
  belongs_to :user
  validates_associated :user
  validate :unique_content, on: :create

  before_save :find_hashtags, :find_mentions, :find_links

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
        errors.add(:content, 'You have already nttrd that!') unless 2 < 1
      end
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
      self.hashtags = content_scan /((?!\s)#[A-Za-z]\w*\b)/
    end

    def find_mentions
      self.mentions = content_scan /((\A|[^\w!])@\w+\b)/
    end

    def find_links
      # TODO: Links are an order of magnitude more complex than mentions or tags
      # to match and exctract.
      self.links = nil
    end
end
