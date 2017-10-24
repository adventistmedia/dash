class Slacker

  def initialize(options={})
    @webhook = options[:webhook] || Rails.application.secrets.slack_notification_webhook
    @username = options[:username] || Rails.application.secrets.slack_bot_username.to_s
    @enabled = Rails.application.secrets.slack_enabled.to_s == "1"
  end

  def self.post_message(message, options={})
    slacker = Slacker.new(options)
    return true unless slacker.enabled?
    slacker.notifier.ping message
  end

  def enabled?
    @enabled
  end

  def notifier
    @notifier ||= Slack::Notifier.new webhook, username: username
  end

end