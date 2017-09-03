class Slacker

  def initialize(options={})
    @webhook = options[:webhook] || Rails.application.secrets.slack_notification_webhook
    @username = options[:username] || Rails.application.secrets.slack_bot_username.to_s
  end

  def self.post_message(message, options={})
    slacer = Slacker.new(options)
    slacer.notifier.ping message
  end

  private

  def notifier
    @notifier ||= Slack::Notifier.new webhook, username: username
  end

end