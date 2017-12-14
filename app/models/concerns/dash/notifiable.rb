module Dash::Notifiable
  extend ActiveSupport::Concern

  included do
    after_create :auto_subscribe_to_notifications
  end

  def auto_subscribe_to_notifications
    SubscriptionNotification.auto_subscribe_user(self)
  end
end