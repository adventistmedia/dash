module Dash::CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
  end

  protected

  def current_user
    @current_user ||= Dash.user_class.constantize.active.find_by_id(session[:user_id])
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
      store_location!
      redirect_to signin_path
    end
  end

  def signout_user
    session.delete(:user_id)
    @current_user = nil
  end

  # store location to redirect user after successful sign in
  def store_location!
    if request.url.present? && request.get? && !request.xhr?
      if uri = URI.parse(request.url) rescue nil
        path = [uri.path.sub(/\A\/+/, '/'), uri.query].compact.join('?')
        path = [path, uri.fragment].compact.join('#')
        session[:after_signin_path] = path
        return
      end
    end
    session[:after_signin_path] = nil
  end

end