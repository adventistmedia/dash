class Notification < ApplicationRecord
  belongs_to :user, class_name: Dash.user_class
  belongs_to :notifiable, polymorphic: true, optional: true
  belongs_to :notification_subscription, optional: true

  scope :unread, -> { where(read: false) }
  scope :admin, -> { where(admin: true) }

  after_save :update_notifications_count
  after_destroy :update_notifications_count
  after_create :deliver_notification

  validates :user_id, :title, presence: true
  validates :url, url: true, allow_blank: true

  # Set multiple notifications as read and update the users count
  def self.read!(user, notifications)
    unread_ids = notifications.select{|n| !n.read }.map(&:id)
    if unread_ids.any?
      self.where(id: unread_ids).update_all(read: true)
      user.update_columns(notifications_count: user.notifications.unread.count)
    end
  end

  def self.remove_expired!
    where("expires_at <= ?", Date.today).destroy_all
  end

  def can_unsubscribe?
    notification_subscription_id.present?
  end

  def url?
    url.present?
  end

  def to_json_notice
    links = url? ? [{name: "View", url: url}] : []
    {
      category: category,
      title: title,
      subtitle: I18n.l(created_at.to_date),
      description: summary,
      read: read,
      links: links
    }
  end

  def deliver_notification
    NotificationMailer.delay.notify(id)
  end

  private

  def update_notifications_count
    user.update_columns(notifications_count: user.notifications.unread.count, updated_at: Time.now)
  end

end