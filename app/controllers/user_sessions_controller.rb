class UserSessionsController < ApplicationController
  before_filter :require_session, only: [:edit, :update, :destroy]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)

    if @user_session.save
      flash[:notice] = 'Login successful!'
      redirect_to root_url
    else
      Rails.logger.error @user_session.errors.to_yaml
      render 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logout successful!'
    redirect_to root_url
  end

  private 
    def user_session_params
      params.require(:user_session).permit(
        :login,
        :password
      )
    end
end
