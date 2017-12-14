class SubscriptionNotification < ApplicationRecord
  has_many :subscriptions, dependent: :destroy

  searchable on: [:name]
  scope :auto_subscribed, -> { where(auto_subscribe: true) }

  validates :name, :key, presence: true, uniqueness: true

  def self.auto_subscribe_user(user)
    SubscriptionNotification.auto_subscribed.each do |sn|
      Subscription.create(
        user: user,
        subscription_notification: sn
      )
    end
  end

end
