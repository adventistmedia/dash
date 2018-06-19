class Dash::PasswordsController < ApplicationController
  layout "dash/session"

  def new
  end

  def create
    response = User.request_password_reset( params[:forgot_password][:email] )
    if response.success?
      flash[:notice] = t("dash.passwords.reset_sent")
      redirect_to reset_password_path(
        reset_token: response.data[:reset_token],
        email: params[:forgot_password][:email]
      )
    else
      @reset_request_failed = true
      render :new
    end
  end

  # GET
  def reset
    @myadventist_password = MyadventistPassword.new(
      reset_token: params[:reset_token],
      reset_code: params[:reset_code],
      email: params[:email]
    )
  end

  # POST
  def update_password
    @myadventist_password = MyadventistPassword.new(myadventist_password_params)
    if @myadventist_password.save
      flash[:notice] = t("dash.passwords.reset_successfull")
      redirect_to signin_path
    else
      flash[:alert] = t("dash.password.reset_failed")
      render :reset
    end
  end

  private

  def myadventist_password_params
    params.fetch(:myadventist_password, {}).permit(:email, :reset_token, :reset_code, :password)
  end

end