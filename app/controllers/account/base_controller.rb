class Account::BaseController < Dashboard::BaseController
  layout "dashboard"

  def current_ability
    @current_ability ||= AccountAbility.new(current_user)
  end
end