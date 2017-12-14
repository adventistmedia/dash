class SigninResponse

  attr_reader :success, :user, :error

  def initialize(success, options={})
    @success = success
    @user = options[:user]
    @error = options[:error]
  end

  def success?
    @success
  end
end