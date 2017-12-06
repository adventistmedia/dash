module Dash::CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
  end

  protected

  def current_user
    @current_user ||= Dash.user_class.constantize.active.find_by(id: session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user&.id
  end

  def authenticate_user!
    unless signed_in?
      redirect_to signin_path
    end
  end

  def signout_user
    session.delete(:user_id)
    @current_user = nil
  end

end