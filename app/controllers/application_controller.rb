class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :new_session

  # Helper methods are made available to the application view.
  helper_method :current_user_session, :current_user

  private
    def new_session
      @user_session = UserSession.new
    end

    def current_user_session
      @current_user_session ||= UserSession.find
    end

    def current_user
      @current_user ||= current_user_session && current_user_session.user
    end

    def require_session
      unless current_user_session
        redirect_to new_user_session_url
      end
    end
end
