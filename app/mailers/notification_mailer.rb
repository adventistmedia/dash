class NotificationMailer < ApplicationMailer

  def notify(notification_id)
    @notification = Notification.where(id: notification_id, read: false).first
    return unless @notification

    @user = @notification.user
    @subject = "#{Dash.site_name}: #{@notification.title}"
    to = %("#{@user.name}" <#{@user.email}>)

    mail(to: to, subject: @subject)
  end

end
