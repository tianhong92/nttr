class UsersController < ApplicationController
  include ApplicationHelper

  before_action :all_users, only: [:index, :create, :update]
  before_action :user_id, only: [:edit, :update, :destroy, :show]
  before_action :create_user, only: [:create]

  # Totally debug.
  # The gist here is that you must be logged in before you may view a user's profile.
  # before_filter :require_session, only: :show

  def index
    if current_user
      # Question: Is this the correct manner?
      @user = User.find(current_user.id)
    else 
      @user = User.new
    end
  end

  def new
      @user = User.new
  end

  def create
    if @user.save
      redirect_to root_url
      flash[:notice] = 'Success!'
    else 
      render template: 'users/new', locals: { user: @user }
    end
  end

  def show 
  end 

  def edit
  end

  def update
  end

  def destory
  end

  private
    def user_params
      params.require(:user).permit(:login, :nicename, :email, :password, :password_confirmation)
    end

    def all_users
      @users = User.all
    end

    def user_id
      @user = User.find(params[:id])
    end

    def create_user
      @user = User.new(user_params)
    end
end
