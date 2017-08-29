MandrillDm.configure do |config|
  config.api_key = Rails.application.secrets.mandrill_api_key
  # config.async = false
end