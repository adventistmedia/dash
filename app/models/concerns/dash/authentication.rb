module Dash::Authentication
  extend ActiveSupport::Concern

  module ClassMethods

    # sign in with a myadventist email or username
    def signin_from_myadventist(options={})
      options.reverse_merge!(myadventist: {})
      # get myadventist user id
      myadventist = MyadventistApi.new(options[:myadventist])
      response = myadventist.signin(options[:email], options[:password])
      unless response.success?
        error_msg =
        case response.data[:error]
        when "invalid_grant"
          "Email and password do not match."
        else
          response.data[:error_description]
        end
        return SigninResponse.new(false, error: error_msg)
      end

      # get current user
      user = self.where(adventist_uid: response.data[:user_id]).first
      if user
        if user.can_signin?
          user.track_sign_in!(options[:ip])
          return SigninResponse.new(true, user: user)
        else
          SigninResponse.new(false, error: "Account has not been activated")
        end
      elsif create_on_signin?
        if user = create_user(response.data)
          user.track_sign_in!(options[:ip])
          return SigninResponse.new(true, user: user)
        else
          SigninResponse.new(false, error: "Unable to create account on sign in")
        end
      end
      SigninResponse.new(false, error: "Account does not exist")
    end

    def create_user(data)
      user = create(
        status: "active",
        first_name: data[:first_name],
        last_name: data[:last_name],
        email: data[:primary_email],
        adventist_uid: data[:user_id]
      )
      user.persisted? ? user : nil
    end

    # create the user on signup if they don't already exist
    def create_on_signin?
      Dash.create_user_on_signin
    end

    # scope when querying for the user to sign in, override to customize
    # by default we assume the user has an enum status column with option of active
    def signin_scope
      self.active
    end

    def signup_invite_only?
      false
    end

    def request_password_reset(email)
      MyadventistApi.new.request_reset_email(email)
    end

  end

  # Track the IP address and time the user logged in.
  def track_sign_in!(ip)
    self.sign_in_count += 1
    self.last_sign_in_ip = self.current_sign_in_ip
    self.last_sign_in_at = self.current_sign_in_at
    self.current_sign_in_ip = ip
    self.current_sign_in_at = Time.current
    self.save(validate: false)
  end

  # override to check if user has an active account for example
  def can_signin?
    active?
  end

end