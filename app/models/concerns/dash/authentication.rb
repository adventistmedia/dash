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
      if user = self.signin_scope.where(myadventist_user_id: response.data[:user_id]).first
        user.track_sign_in!(options[:ip])
      end
      user
    end

    # scope when querying for the user to sign in, override to customize
    # by default we assume the user has an enum status column with option of active
    def signin_scope
      self.active
    end

    def signup_invite_only?
      false
    end

  end

  # Track the IP address and time the user logged in.
  def track_sign_in!(ip)
    self.last_sign_in_ip = self.current_sign_in_ip
    self.last_sign_in_at = self.current_sign_in_at
    self.current_sign_in_ip = ip
    self.current_sign_in_at = Time.current
    self.save(validate: false)
  end

end