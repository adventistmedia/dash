class Dashboard::NotificationsController < Dashboard::BaseController
  authorize_resource

  def index
    @notifications = @current_user.notifications.page(params[:page]).per(10).order('created_at DESC')
    Notification.read!(@current_user, @notifications)
    render json: {
      "meta": {
        "lastPage": @notifications.last_page?
      },
      "data": @notifications.map(&:to_json_notice)
    }
  end

  # POST
  def clear
    @current_user.notifications.destroy_all
  end

end