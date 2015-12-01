class TweetsController < ApplicationController
  before_filter :require_session, except: [:index, :show]

  # All tweets.
  before_action :all_tweets, only: [:index, :create]
  # Create new tweet.
  before_action :new_tweet, only: [:index, :new]
  # Specific tweet.
  before_action :tweet_id, only: [:destroy, :show]
  # Redirect to home upon a new form or update action.

  def index
  end

  def show
  end

  def new
    @user = User.find(current_user.id)
  end

  def create
    @user ||= User.find(current_user.id)
    @tweet = @user.tweets.create(tweet_params)

    if @tweet.save 
      render partial: 'tweets/tweet', locals: { tweet: @tweet }
    else 
      # Ask how to correctly raise an error here, then dispatch HTML and
      # expect it at the client level.
      # render json: @tweet.errors.messages, status: 422
      render partial: 'error', locals: { tweet: @tweet }, status: 422
    end
  end

  def destroy
    @tweet.destroy

    render json: {
      status: 200
    }
  end

  private 
    def tweet_params
      params.require(:tweet).permit(:content)
    end

    def tweet_id
      @tweet = Tweet.find(params[:id])
    end

    def all_tweets
      @tweets = Tweet.all
    end

    def new_tweet
      @tweet = Tweet.new
    end
end
