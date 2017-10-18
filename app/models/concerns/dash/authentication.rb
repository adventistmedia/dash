module Dash::Authentication
  extend ActiveSupport::Concern

  module ClassMethods

    # sign in with a myadventist email or username
    def signin_from_myadventist(options={})
      options.reverse_merge!(myadventist: {})
      # get myadventist user id
      myadventist = MyadventistApi.new(options[:myadventist])
      response = myadventist.signin(options[:email], options[:password])
      return nil unless response.success?

      # get current user
      user = self.where(adventist_uid: response.data[:user_id]).first
      if user
        if user.active?
          user.track_sign_in!(options[:ip])
          return user
        end
      elsif create_on_signin?
        if user = create_user(response.data)
          user.track_sign_in!(options[:ip])
          return user
        end
      end
      nil
    end

    def create_user(data)
      user = User.create(
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
      true
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

end