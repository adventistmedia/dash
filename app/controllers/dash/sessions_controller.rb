class Dash::SessionsController < ApplicationController
  layout "dash/session"
  before_action :already_signed_in, only: [:new, :create]

  # Sign in
  def new
  end

  def create
    @signin_response = Dash.user_class.constantize.signin_from_myadventist( signin_params.merge(ip: request.remote_ip) )
    if @signin_response.success?
      after_signin_success
    else
      render :new
    end
  end

  # Sign out
  def destroy
    signout_user
    flash[:notice] = t("dash.sessions.sign_out_success")
    redirect_to signin_path
  end

  private

  def after_signin_success
    self.current_user = @signin_response.user
    redirect_after_signin
  end

  def redirect_after_signin
    redirect_to session[:after_signin_path] || dashboard_root_path
    session.delete(:after_signin_path)
  end

  def already_signed_in
    if current_user
      redirect_to dashboard_root_path
    end
  end

  def signin_params
    params.fetch(:session, {}).permit(:email, :password)
  end
end