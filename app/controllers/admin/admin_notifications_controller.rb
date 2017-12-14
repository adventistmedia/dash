class Admin::AdminNotificationsController < Admin::BaseController
  sort_options [:title, :created_at]
  before_action :find_or_initialize_admin_notification, except: [:index]
  authorize_resource

  def index
    @admin_notifications = AdminNotification.ownerless.search(params[:q]).paginate(params).reorder(sort_order)
  end

  def show
  end

  def new
  end

  def create
    if @admin_notification.save
      flash[:notice] = t("flash.create_success", title: @admin_notification.title)
      redirect_to admin_admin_notifications_path
    else
      flash[:alert] = t("flash.create_failed")
      render :new
    end
  end

  private

  def find_or_initialize_admin_notification
    @admin_notification = params[:id] ? AdminNotification.ownerless.find(params[:id]) : AdminNotification.new(admin_notification_params)
  end

  def admin_notification_params
    params.fetch(:admin_notification, {}).permit(:title, :summary, :url, :expires_at)
  end

end