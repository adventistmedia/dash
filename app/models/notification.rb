class Notification < ApplicationRecord
  belongs_to :user, class_name: Dash.user_class
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read: false) }

  after_save :update_notifications_count
  after_destroy :update_notifications_count

  validates :user_id, :title, presence: true

  # Set multiple notifications as read and update the users count
  def self.read!(user, notifications)
    unread_ids = notifications.select{|n| !n.read }.map(&:id)
    if unread_ids.any?
      self.where(id: unread_ids).update_all(read: true)
      user.update_columns(notifications_count: user.notifications.unread.count)
    end
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

  private

  def update_notifications_count
    user.update_columns(notifications_count: user.notifications.unread.count)
  end

end