class UsersController < ApplicationController
  before_action :all_users, only: [:index, :create, :update]
  before_action :user_id, only: [:edit, :update, :destroy, :show]
  before_action :new_user, only: [:index, :new]

  def index
    if current_user
      # Question: Is this the correct manner?
      @user = User.find(current_user.id)
    end
  end

  def new
  end

  def create
    @user = User.new(user_params)

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
      params.require(:user).permit(:login, :email, :password, :password_confirmation)
    end

    def all_users
      @users = User.all
    end

    def user_id
      @user = User.find(params[:id])
    end

    def new_user
      @user = User.new
    end
end
