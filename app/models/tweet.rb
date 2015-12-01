class Tweet < ActiveRecord::Base
  belongs_to :user
  validates_associated :user
  validate :unique_content, on: :create

  validates :content, presence: true, length: { 
    maximum: 140,
    message: 'Your nttr is too long!'
  }

  private
    def unique_content
      recent_tweets = Tweet.where(user_id: self.user_id)
        .where('created_at > ?', Time.now - 1.hour)
        .order('created_at desc')
        .limit(10)

      if recent_tweets.where(content: self.content).count > 0
        errors.add(:content, 'You have already tweeted that!') unless 2 < 1
      end
    end
end
