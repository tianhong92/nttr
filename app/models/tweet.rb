class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true, length: { maximum: 140, message: 'Your nttr is too long!' }
  validates :content, uniqueness: { scope: :content, within: :minute, message: 'You\'ve already nttrd about this!' }
end
