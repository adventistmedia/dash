class Slacker

  def initialize(options={})
    @webhook = options[:webhook] || Rails.application.credentials.env.dig(:slack, :notification_webhook)
    @username = options[:username] || Rails.application.credentials.env.dig(:slack, :bot_username).to_s
    @enabled = Rails.application.credentials.env.dig(:slack, :enabled).to_s == "1"
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
    @notifier ||= Slack::Notifier.new @webhook, username: @username
  end

end