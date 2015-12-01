class UsersController < ApplicationController
  before_filter :require_session, only: [:edit, :update, :destroy]
  before_action :all_users, only: [:index, :create, :update]
  before_action :user_id, only: [:edit, :update, :destroy, :show]

  def index
    @user = current_user ? User.find(current_user.id) : User.new
  end

  def show 
  end 

  def new
      @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_url
      flash[:notice] = 'Success!'
    else 
      # Rendering an action takes in the whole template.
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @user.destroy
    redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(
        :login,
        :nicename,
        :email,
        :password,
        :password_confirmation
      )
    end

    def all_users
      @users = User.all
    end

    def user_id
      @user = User.find(params[:id])
    end
end
