module Dash::AdminNotifiable
  extend ActiveSupport::Concern

  included do
    audited
    belongs_to :owner, polymorphic: true, optional: true
    has_many :notifications, as: :notifiable, dependent: :destroy
    scope :ownerless, -> { where(owner: nil) }

    validates :title, :summary, presence: true
    validate :valid_expires_at

    searchable on: [:title]

    after_create :delay_sending
  end

  def object_title # used for audits
    title
  end

  def add_notifications
    notification_users.find_each do |user|
      user.notifications.create(
        notifiable: self,
        title: title,
        summary: summary,
        url: url,
        expires_at: expires_at
      )
    end
  end

  def notification_users
    Dash.user_class.constantize.active
  end

  private

  def valid_expires_at
    if new_record? && expires_at.present? && expires_at <= Date.today
      errors.add :expires_at, "must be on a future date"
    end
  end

  def delay_sending
    add_notifications
  end

end