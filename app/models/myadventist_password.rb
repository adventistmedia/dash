class MyadventistPassword
  include ActiveModel::Model

  validates :reset_code, :reset_token, :email, :password, presence: true
  validates :email, email: true
  # Password complexity: at least 1 digit, uppercase, lowercase, symbol
  validates :password, length: {minimum: 8, maximum: 12}, format: { with: /(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*\W).*/, message: I18n.t("dash.myadventist_user.validations.password_complexity") }

  attr_accessor :reset_code, :reset_token, :email, :password

  def save
    return false unless valid?
    reset_password
  end

  def show_reset_code?
    reset_code.blank? || errors[:reset_code].any?
  end

  def attributes
    {
      email: email,
      password: password,
      reset_code: reset_code,
      reset_token: reset_token
    }
  end

  def reset_password
    myadventist = MyadventistApi.new
    response = myadventist.reset_password(attributes)

    unless response.success?
      map_myadventist_errors(response)
    end
    response.success?
  end

  private

  # map myadventist errors to attributes
  def map_myadventist_errors(response)
    if response.data[:error_description].include?("Invalid or expired reset_token")
      errors.add :base, "Reset code has expired. Try forgot password again."
    elsif response.data[:error_description].include?("Code failed validation")
      errors.add :reset_code, "invalid"
    else
      errors.add :base, response.data[:error_description]
    end
  end

end