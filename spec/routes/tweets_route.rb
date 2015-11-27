require 'spec_helper'
require 'rails_helper'

describe TweetsController, type: :routing do
  it 'routes get tweets' do
    expect(get: user_tweets_path(1)).to route_to(
      controller: 'tweets',
      action: 'index',
      user_id: '1'
    )
  end

  it 'routes get show tweet' do
    expect(get: user_tweet_path(1,1)).to route_to(
      controller: 'tweets',
      action: 'show',
      id: '1',
      user_id: '1'
    )
  end

  it 'routes get new tweet' do
    expect(get: new_user_tweet_path(1)).to route_to(
      controller: 'tweets',
      action: 'new',
      user_id: '1'
    )
  end
end
