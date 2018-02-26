MandrillDm.configure do |config|
  config.api_key = Rails.application.credentials.dig(:mandrill, :api_key)
  # config.async = false
end