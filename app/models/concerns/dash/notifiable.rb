module Dash::Notifiable
  extend ActiveSupport::Concern

  included do
    after_create :auto_subscribe_to_notifications
    has_many :notifications, dependent: :destroy, foreign_key: "#{Dash.user_class.downcase}_id"
    has_many :subscriptions, dependent: :destroy, foreign_key: "#{Dash.user_class.downcase}_id"
    has_many :subscription_notifications, through: :subscriptions
  end

  def auto_subscribe_to_notifications
    SubscriptionNotification.auto_subscribe_user(self)
  end
end