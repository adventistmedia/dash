class Dash::SessionsController < ApplicationController
  layout "dash/session"
  before_action :already_signed_in, only: [:new, :create]

  # Sign in
  def new
  end

  def create
    if @user = User.signin_from_myadventist( signin_params.merge(ip: request.remote_ip) )
      after_signin_success
    else
      @signin_failed = true
      render :new
    end
  end

  # Sign out
  def destroy
    signout_user
    flash[:notice] = t("sessions.sign_out_success")
    redirect_to main_app.signin_path
  end

  private

  def after_signin_success
    self.current_user = @user
    redirect_to main_app.dashboard_root_path
  end

  def already_signed_in
    if current_user
      redirect_to main_app.dashboard_root_path
    end
  end

  def signin_params
    params.fetch(:session, {}).permit(:email, :password)
  end
end