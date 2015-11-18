class UsersController < ApplicationController
  require 'digest/md5'
  include ApplicationHelper

  before_action :all_users, only: [:index, :create, :update]
  before_action :user_id, only: [:edit, :update, :destroy, :show]
  before_action :create_user, only: [:create]

  # Create MD5 of the user's login for fetching programmatic avatars.
  before_action :login_md5, only: [:create, :update]

  def index
    if current_user
      # Question: Is this the correct manner?
      @user = User.find(current_user.id)
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
      flash[:error] = @user.errors.messages
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

    def login_md5
      @user.login_md5 = Digest::MD5.hexdigest(@user.login)
    end
end
