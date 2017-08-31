class MyadventistUser
  include ActiveModel::Model

  validates :first_name, :last_name, :email, :password, presence: true
  validates :email, email: true
  # Password complexity: at least 1 digit, uppercase, lowercase, symbol
  validates :password, length: {minimum: 8, maximum: 12}, format: { with: /(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*\W).*/, message: I18n.t("myadventist_user.validations.password_complexity") }

  attr_accessor :first_name, :last_name, :email, :password
  attr_reader :myadventist_id

  def save
    return false unless valid?
    create_account
  end

  def attributes
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password,
      verified: 1 #hmmm
    }
  end

  def create_account
    myadventist = MyadventistApi.new
    response = myadventist.create_account(attributes)
    if response.success?
      self.myadventist_id = response.data[:user_id]
      return true
    else
      map_myadventist_errors(response)
    end
    false
  end

  private

  # map myadventist errors to attributes
  def map_myadventist_errors(response)
    if response.data[:error_description].include?("Email is already in use")
      errors.add :email, "already taken"
    else
      errors.add :base, response.data[:error_description]
    end
  end

end