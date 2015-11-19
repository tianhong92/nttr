class TweetsController < ApplicationController
  include TweetsHelper

  # All tweets.
  before_action :all_tweets, only: [:index, :create]
  # Create new tweet.
  before_action :new_tweet, only: [:index, :new]
  # Specific tweet.
  before_action :tweet_id, only: [:destroy, :show]
  # Redirect to home upon a new form or update action.
  before_action :tweets_redirect, only: [:new]

  def show
  end

  def new
    # No point in a separate form.
  end

  def index
  end

  def create
    if current_user
      # Question: Is this the correct manner?
      @user = User.find(current_user.id)
    end

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

    def create_tweet
    end

    def tweets_redirect
      redirect_to tweets_path
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
