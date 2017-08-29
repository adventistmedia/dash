class Slacker

  def self.post_message(message)
    if active?
      notifier.ping message
      return true
    end
    false
  end

  def self.notifier
    Slack::Notifier.new webhook.to_s, username: Rails.application.secrets.slack_bot_username
  end

  def self.webhook
    @webhook ||= Rails.application.secrets.slack_notification_webhook
  end

  def self.active?
    notifier.endpoint.class != URI::Generic
  end
end