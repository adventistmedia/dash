class Dash::SignupsController < ApplicationController
  layout "dash/session"
  before_action :redirect_if_current_sign_in

  def new
    @myadventist_user = MyadventistUser.new
  end

  def create
    @myadventist_user = MyadventistUser.new(myadventist_user_params)
    if @myadventist_user.save
      flash[:notice] = "Successfully created account. Please sign in"
      redirect_to signin_path
    else
      flash[:alert] = "Unable to create account. Please review error messages."
      render :new
    end
  end

  private

  def myadventist_user_params
    params.fetch(:myadventist_user, {}).permit(:first_name, :last_name, :email, :password)
  end

  def redirect_if_current_sign_in
    if @current_user
      return redirect_to dashboard_root_path
    end
  end

end