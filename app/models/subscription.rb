class Subscription < ApplicationRecord
  belongs_to :user, class_name: Dash.user_class
  belongs_to :subscription_notification
  belongs_to :subscribed_by, optional: true, class_name: Dash.user_class

  validates :user_id, uniqueness: { scope: :subscription_notification_id }

  def self.unsubscribe(user, subscription_notification)
    user.subscriptions.where(subscription_notification: subscription_notification).destroy_all
  end

  def self.subscribe(user, subscription_notification, options={})
    user.subscriptions.where(subscription_notification: subscription_notification).first_or_create do |s|
      s.subscribed_by = options[:subscribed_by]
    end
  end

end
