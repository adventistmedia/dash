require "securerandom"

class MyadventistApi

  def initialize(options={})
    @client_id = Rails.application.secrets.myadventist_client_id
    @client_secret = Rails.application.secrets.myadventist_client_secret
    @redirect_host = options[:host] || Rails.application.secrets.myadventist_redirect_host
    @redirect_uri = "#{@redirect_host}/auth/myadventist/callback"
    @reset_password_redirect_uri = "#{@redirect_host}/passwords/reset"
    @state = SecureRandom.hex(10)
    @test = options.key?(:test) ? options[:test] : !Rails.env.production?
    @api_host = @test ? "https://test.myadventist.org.au" : "https://myadventist.org.au"
  end

  def signin(username, password)
    signin_response = signin_request(username, password)
    return signin_response unless signin_response.success?

    # Get user details
    user_request(signin_response.data[:access_token])
  end

  def create_account(attributes)
    create_response = create_account_request(attributes)
    return create_response unless create_response.success?

    # Get user details
    user_request(create_response.data[:access_token])
  end

  def request_reset_email(email)
    post_request("/OAuth/RequestResetEmail",
      email: email,
      scope: "email"
    )
  end

  def reset_password(attributes)
    post_request("/OAuth/ResetPassword",
      reset_token: attributes[:reset_token],
      reset_code: attributes[:reset_code],
      email: attributes[:email],
      password: attributes[:password],
      scope: "email",
      redirect_uri: @reset_password_redirect_uri
    )
  end

  def create_account_request(attributes)
    post_request("/OAuth/CreateUser",
      firstname: attributes[:first_name],
      lastname: attributes[:last_name],
      email: attributes[:email],
      password: attributes[:password],
      scope: "email",
      verified: attributes[:verified]
    )
  end

  def user_request(access_token)
    post_request("/OAuth/userinfo",
      grant_type: "authorization_code",
      access_token: access_token
    )
  end

  def signin_request(username, password)
    post_request(
      "/OAuth/Authorize",
      response_type: "password",
      scope: "email",
      username: username,
      password: password
    )
  end

  private

  def post_request(path, options)
    conn = Faraday.new(url: @api_host, headers: {"Content-Type" => "application/json"})
    body = default_request_options.reverse_merge(options)
    response = conn.post path, body.to_json
    unless response.success?
      Rails.logger.debug "MyAdventist API request failed: #{response.status} code - #{response.body}"
    end
    MyadventistResponse.new(response)
  end

  def default_request_options
    {
      client_id: @client_id,
      client_secret: @client_secret,
      state: @state,
      redirect_uri: @redirect_uri
    }
  end

end